/// @description Lógica Completa e Corrigida

// --- 0. GERENCIAMENTO DE TIMER (Novo) ---
// Isso faz o tempo do combo diminuir a cada frame
if (timer_combo > 0) {
    timer_combo -= 1;
}

// --- INPUTS ---
var key_left    = keyboard_check(ord("A"));
var key_right   = keyboard_check(ord("D"));
var key_jump    = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
var key_dash    = keyboard_check_pressed(vk_shift);
var key_special = keyboard_check_pressed(ord("Q"));
var key_attack  = mouse_check_button_pressed(mb_left);
var key_up      = keyboard_check(ord("W"));
var key_down    = keyboard_check(ord("S"));

// Direção
var move = key_right - key_left;

// --- MÁQUINA DE ESTADOS ---
switch (estado) 
{
    #region ESTADO: LIVRE
    case ESTADO.LIVRE:
        hsp = move * spd_walk;
        vsp = vsp + grv;
        invencivel = false;
        image_speed = 1; 

        // Chão
        if (place_meeting(x, y+1, obj_chao)) {
            if (key_jump) vsp = jmp_spd;
            
            if (move != 0) {
                image_xscale = move;
                sprite_index = Personagem_correndo;
            } else {
                sprite_index = Personagem_parado;
            }
        } 
        // Ar
        else {
            if (vsp < 0) sprite_index = Personagem_pulo;
            else sprite_index = Personagem_caindo;
        }

        // --- GATILHOS ---
        
        // Dash Normal (Shift)
        if (key_dash) {
            estado = ESTADO.DASH;
            sprite_index = Personagem_dash;
            image_index = 0;
            if (move != 0) image_xscale = move;
        }
        
        // Dash Especial (Q)
        if (key_special) {
            estado = ESTADO.DASH_ESPECIAL;
            sprite_index = Personagem_dash_especial;
            image_index = 0;
            if (move != 0) image_xscale = move;
        }

        // --- SISTEMA DE COMBATE (CORRIGIDO) ---
        if (key_attack) {
            estado = ESTADO.ATAQUE;
            hsp = 0; 
            image_index = 0; // Reinicia animação
            
            // Lógica do Combo:
            // Se já bateu uma vez (combo 1) E ainda tem tempo no timer...
            if (combo == 1 && timer_combo > 0) {
                combo = 2; // Vai para o segundo ataque
                sprite_index = Personagem_ataque_2;
            } 
            // Se não (começo do combo ou tempo acabou)...
            else {
                combo = 1; // Começa o primeiro ataque
                
                // Escolhe animação (Cima / Baixo / Normal)
                if (key_up) {
                    if (!place_meeting(x, y+1, obj_chao)) sprite_index = Personagem_pulo_up_ataque;
                    else sprite_index = Personagem_idle_up_ataque;
                }
                else if (key_down && !place_meeting(x, y+1, obj_chao)) {
                    sprite_index = Personagem_pulo_down_ataque;
                }
                else {
                    sprite_index = Personagem_ataque_1;
                }
            }
        }
    break;
    #endregion

    #region ESTADO: DASH
    case ESTADO.DASH:
        vsp = 0; 
        hsp = image_xscale * spd_dash;
        
        if (key_attack) {
            estado = ESTADO.DASH_ATAQUE;
            sprite_index = Personagem_dash_ataque;
            image_index = 0;
        }
    break;
    #endregion

    #region ESTADO: DASH ATAQUE
    case ESTADO.DASH_ATAQUE:
        vsp = 0;
        invencivel = true; 
        hsp = image_xscale * spd_dash;
    break;
    #endregion

    #region ESTADO: DASH ESPECIAL
    case ESTADO.DASH_ESPECIAL:
        vsp = 0;
        hsp = 0; 
        invencivel = true;
    break;
    #endregion

    #region ESTADO: ATAQUE
    case ESTADO.ATAQUE:
        hsp = 0; // Para o personagem
        vsp = vsp + grv; // Mantém gravidade

        // --- HITBOX DE DANO ---
        // Se estiver nos frames de "corte" (Ex: frame 2 a 7)
        if (image_index >= 2 && image_index <= 7) {
            
            var inimigo = instance_place(x, y, Object1);
            
            if (inimigo != noone) {
                with (inimigo) {
                    if (!invencivel) {
                        vida_atual -= 1;
                        invencivel = true;
                        alarm[1] = 15; // Tempo invencível do inimigo
                        
                        image_blend = c_red;
                        
                        var dir_hit = sign(x - other.x);
                        if (dir_hit == 0) dir_hit = 1;
                        hsp = dir_hit * 4; 
                    }
                }
            }
        }
    break;
    #endregion
    
    #region ESTADO: HIT
    case ESTADO.HIT:
        hsp = 0;
        vsp = vsp + grv;
    break;
    #endregion
}

// --- COLISÃO FINAL ---

// Horizontal
if (place_meeting(x + hsp, y, obj_chao)) {
    while (!place_meeting(x + sign(hsp), y, obj_chao)) {
        x = x + sign(hsp);
    }
    hsp = 0;
}
x = x + hsp;

// Vertical
if (place_meeting(x, y + vsp, obj_chao)) {
    while (!place_meeting(x, y + sign(vsp), obj_chao)) {
        y = y + sign(vsp);
    }
    vsp = 0;
}
y = y + vsp;

// Desentupidor de Parede
if (place_meeting(x, y, obj_chao)) {
    if (!place_meeting(x - 1, y, obj_chao)) x -= 1; 
    else if (!place_meeting(x + 1, y, obj_chao)) x += 1;
    else if (!place_meeting(x, y - 1, obj_chao)) y -= 1;
}

// Piscar quando toma dano
if (invencivel && estado == ESTADO.HIT) {
    if (image_alpha == 1) image_alpha = 0.5;
    else image_alpha = 1;
}

// Morte
if (vida_atual <= 0) {
    room_restart();
}