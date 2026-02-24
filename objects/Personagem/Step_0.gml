/// @description Lógica do Personagem

// --- 1. SISTEMA DE MORTE ---
if (vida_atual <= 0) {
    if (estado != ESTADO.MORTE) {
        estado = ESTADO.MORTE;
        sprite_index = Personagem_death; 
        image_index = 0;   
        image_speed = 1;   
        hsp = 0;           
    }

    // Gravidade na morte
    if (!place_meeting(x, y + 1, obj_chao)) {
        vsp += grv;
    } else {
        vsp = 0;
    }

    // Colisão simples
    if (place_meeting(x, y + vsp, obj_chao)) {
        while (!place_meeting(x, y + sign(vsp), obj_chao)) y += sign(vsp);
        vsp = 0;
    }
    y += vsp;

    // Reiniciar ao fim da animação
    if (image_index >= image_number - 1) {
        image_speed = 0; 
        global.vida_atual = global.vida_max; // Reseta a vida global para o restart
        room_restart(); 
    }

    exit;
}

// --- 2. TIMERS E INPUTS ---
if (timer_combo > 0) timer_combo -= 1;

var key_left    = keyboard_check(ord("A"));
var key_right   = keyboard_check(ord("D"));
var key_jump    = keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("W"));
var key_dash    = keyboard_check_pressed(vk_shift);
var key_special = keyboard_check_pressed(ord("Q"));
var key_attack  = mouse_check_button_pressed(mb_left);
var key_up      = keyboard_check(ord("W"));
var key_down    = keyboard_check(ord("S"));

var move = key_right - key_left;

// --- 3. MÁQUINA DE ESTADOS ---
switch (estado) 
{
    case ESTADO.LIVRE:
        hsp = move * spd_walk;
        vsp += grv;
        invencivel = false;
        image_speed = 1; 

        if (place_meeting(x, y+1, obj_chao)) {
            if (key_jump) vsp = jmp_spd;
            if (move != 0) {
                image_xscale = move;
                sprite_index = Personagem_correndo;
            } else {
                sprite_index = Personagem_parado;
            }
        } else {
            if (vsp < 0) sprite_index = Personagem_pulo;
            else sprite_index = Personagem_caindo;
        }

        if (key_dash) {
            estado = ESTADO.DASH;
            sprite_index = Personagem_dash;
            image_index = 0;
            if (move != 0) image_xscale = move;
        }
        
        if (key_special) {
            estado = ESTADO.DASH_ESPECIAL;
            sprite_index = Personagem_dash_especial;
            image_index = 0;
            if (move != 0) image_xscale = move;
        }

        if (key_attack) {
            estado = ESTADO.ATAQUE;
            hsp = 0; image_index = 0;
            if (combo == 1 && timer_combo > 0) {
                combo = 2; sprite_index = Personagem_ataque_2;
            } else {
                combo = 1;
                if (key_up) {
                    sprite_index = place_meeting(x, y+1, obj_chao) ? Personagem_idle_up_ataque : Personagem_pulo_up_ataque;
                } else if (key_down && !place_meeting(x, y+1, obj_chao)) {
                    sprite_index = Personagem_pulo_down_ataque;
                } else {
                    sprite_index = Personagem_ataque_1;
                }
            }
        }
    break;

    case ESTADO.DASH:
        vsp = 0; hsp = image_xscale * spd_dash;
        if (key_attack) {
            estado = ESTADO.DASH_ATAQUE;
            sprite_index = Personagem_dash_ataque;
            image_index = 0;
        }
    break;

    case ESTADO.DASH_ATAQUE:
        vsp = 0; invencivel = true; hsp = image_xscale * spd_dash;
    break;

    case ESTADO.DASH_ESPECIAL:
        vsp = 0; hsp = 0; invencivel = true;
    break;

    case ESTADO.ATAQUE:
        hsp = 0; vsp += grv;
        if (image_index >= 2 && image_index <= 7) {
            var inimigo = instance_place(x, y, Inimigo);
            if (inimigo != noone) {
                with (inimigo) {
                    if (!invencivel) {
                        vida_atual -= 1;
                        invencivel = true;
                        alarm[1] = 15;
                        image_blend = c_red;
                        var dir_hit = sign(x - other.x);
                        hsp = (dir_hit == 0 ? 1 : dir_hit) * 4; 
                    }
                }
            }
        }
    break;
    
    case ESTADO.HIT:
        hsp = 0; vsp += grv;
    break;
}

// --- 4. COLISÃO ---
if (place_meeting(x + hsp, y, obj_chao)) {
    while (!place_meeting(x + sign(hsp), y, obj_chao)) x += sign(hsp);
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, obj_chao)) {
    while (!place_meeting(x, y + sign(vsp), obj_chao)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

// Desentupidor
if (place_meeting(x, y, obj_chao)) {
    if (!place_meeting(x - 1, y, obj_chao)) x -= 1; 
    else if (!place_meeting(x + 1, y, obj_chao)) x += 1;
}

// Visual de Dano
if (invencivel && estado == ESTADO.HIT) image_alpha = (image_alpha == 1) ? 0.5 : 1;
else image_alpha = 1;