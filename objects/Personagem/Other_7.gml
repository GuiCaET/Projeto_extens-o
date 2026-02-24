/// @description Finalizar Animações e Combos

// --- 1. FIM DA MORTE ---
// (A morte agora é reiniciada com segurança direto no Step Event, 
// então não precisamos de nenhum código aqui para evitar conflitos!)

// --- 2. FIM DO DASH ESPECIAL ---
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

// --- 3. FIM DO DASH OU DASH ATAQUE ---
if (estado == ESTADO.DASH || estado == ESTADO.DASH_ATAQUE) 
{
    estado = ESTADO.LIVRE;
    invencivel = false;
    hsp = 0;
}

// --- 4. FIM DO ATAQUE / COMBO ---
if (estado == ESTADO.ATAQUE) 
{
    estado = ESTADO.LIVRE; 

    if (sprite_index == Personagem_ataque_1) {
        combo = 1;
        timer_combo = 30; 
    }
    else {
        combo = 0;
        timer_combo = 0;
    }
}

// --- 5. FIM DO HIT (Dano) ---
if (estado == ESTADO.HIT) 
{
    estado = ESTADO.LIVRE;
    hsp = 0;
}