/// @description Finalizar Animações e Combos

// --- 1. FIM DO DASH ESPECIAL ---
if (estado == ESTADO.DASH_ESPECIAL) 
{
    var distancia_tp = 200; 
    var dir = sign(image_xscale); 

    for (var i = 0; i < distancia_tp; i++) {
        if (!place_meeting(x + dir, y, obj_chao)) {
            x = x + dir; 
        } else {
            break; 
        }
    }
    estado = ESTADO.LIVRE;
    invencivel = false;
    hsp = 0;
}

// --- 2. FIM DOS OUTROS DASHES ---
if (estado == ESTADO.DASH || estado == ESTADO.DASH_ATAQUE) {
    estado = ESTADO.LIVRE;
    invencivel = false;
    hsp = 0;
}

// --- 3. FIM DO ATAQUE / COMBO (AQUI ESTAVA O ERRO) ---
if (estado == ESTADO.ATAQUE) 
{
    estado = ESTADO.LIVRE; // Volta a poder andar/clicar

    // SE ACABOU O ATAQUE 1:
    if (sprite_index == Personagem_ataque_1) {
        combo = 1;        // Diz que o passo 1 foi concluído
        timer_combo = 30; // Dá 30 frames (0.5 seg) para clicar de novo
    }
    
    // SE ACABOU O ATAQUE 2 (Fim do combo):
    else if (sprite_index == Personagem_ataque_2) {
        combo = 0;        // Reseta tudo
        timer_combo = 0;
    }
    
    // SE ACABOU ATAQUES AÉREOS/OUTROS:
    else {
        combo = 0;
        timer_combo = 0;
    }
}

// --- 4. FIM DO HIT ---
if (estado == ESTADO.HIT) {
    estado = ESTADO.LIVRE;
    hsp = 0;
}