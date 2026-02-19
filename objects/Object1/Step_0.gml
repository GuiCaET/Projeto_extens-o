/// @description IA Inteligente e Hitbox Precisa

// --- 1. DETECTAR O JOGADOR (Object3) ---
var alvo = Personagem; // Define quem é o alvo
var dist = 9999;
var dir_x = 0;

if (instance_exists(alvo)) {
    dist = distance_to_object(alvo);
    // Descobre se o player está na direita (1) ou esquerda (-1)
    dir_x = sign(alvo.x - x); 
}

// --- 2. MÁQUINA DE ESTADOS ---
switch (estado) 
{
    #region ESTADO: PARADO
    case ESTADO_INIMIGO.PARADO:
        hsp = 0;
        // IMPORTANTE: Troque pelo nome exato do seu sprite parado
        sprite_index = NightBorne_idle; 
        
        // Se o player entrar no alcance da visão
        if (dist < alcance_visao) {
            estado = ESTADO_INIMIGO.PERSEGUINDO;
        }
    break;
    #endregion

    #region ESTADO: PERSEGUINDO
    case ESTADO_INIMIGO.PERSEGUINDO:
        // Define o sprite correndo
        sprite_index = NightBorne_run; 
        
        // Vira o inimigo para o lado do player
        if (dir_x != 0) image_xscale = dir_x;

        // LÓGICA DE DECISÃO:
        // 1. Se chegou perto o suficiente para bater:
        if (dist < alcance_ataque) {
            estado = ESTADO_INIMIGO.ATACANDO;
            hsp = 0;
            image_index = 0; // Reinicia animação do zero
        }
        // 2. Se o player fugiu para muito longe:
        else if (dist > alcance_visao * 1.5) {
            estado = ESTADO_INIMIGO.PARADO;
        }
        // 3. Se não, continua correndo atrás:
        else {
            hsp = dir_x * velocidade;
        }
    break;
    #endregion

    #region ESTADO: ATACANDO (COM HITBOX PERFEITA)
    case ESTADO_INIMIGO.ATACANDO:
        hsp = 0;
        sprite_index = NightBorne_attack;

        // Verifica se está nos frames "fortes" do ataque (ajuste os números se precisar)
        // Ex: Se o soco acontece entre o frame 2 e 5
        if (image_index >= 10 && image_index <= 11) {
            
            // --- O TRUQUE DA PRECISÃO ---
            
            // 1. Salva a máscara atual (o retângulo do corpo)
            var mask_antiga = mask_index;
            
            // 2. Troca a máscara para ser IGUAL ao desenho do ataque
            mask_index = sprite_index;
            
            // 3. Verifica a colisão usando o desenho do ataque
            if (place_meeting(x, y, alvo)) {
                
                // Aplica dano no Object3
                with (alvo) {
                    // Só machuca se não estiver invencível
                    if (!invencivel) {
                        vida_atual -= other.dano; // Tira vida
                        estado = ESTADO.HIT;      // Trava o player
                        invencivel = true;        // Ativa invencibilidade
                        alarm[0] = 60;            // Tempo de proteção (1 seg)
                        
                        // Empurrão (Knockback) para trás
                        hsp = sign(x - other.x) * 4;
                        vsp = -3;
                    }
                }
            }
            
            // 4. MUITO IMPORTANTE: Devolve a máscara original imediatamente
            // Se esquecer isso, o inimigo pode afundar no chão
            mask_index = mask_antiga;
        }
    break;
    #endregion
    
    #region ESTADO: HIT / MORTE (Opcional, se tiver)
    case ESTADO_INIMIGO.HIT:
        hsp = 0;
        // Adicione lógica de hit aqui se tiver sprite de dano
    break;
    #endregion
}

// --- 3. FÍSICA E COLISÃO (Padrão) ---

// Aplica Gravidade
vsp = vsp + grv;

// Colisão Horizontal (Parede)
if (place_meeting(x + hsp, y, obj_chao)) {
    while (!place_meeting(x + sign(hsp), y, obj_chao)) {
        x = x + sign(hsp);
    }
    hsp = 0;
}
x = x + hsp;

// Colisão Vertical (Chão/Teto)
if (place_meeting(x, y + vsp, obj_chao)) {
    while (!place_meeting(x, y + sign(vsp), obj_chao)) {
        y = y + sign(vsp);
    }
    vsp = 0;
}
y = y + vsp;

// --- MORTE ---
if (vida_atual <= 0) {
    // Opção 1: Destruir direto
    instance_destroy();
    
    // Opção 2 (Mais chique): Mudar para sprite de morte se tiver
    // sprite_index = NightBorne_death;
    // if (animation_end()) instance_destroy();
}