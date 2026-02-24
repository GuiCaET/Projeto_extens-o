/// @description Inicializar Variáveis do Player

// --- FÍSICA ---
hsp = 0;
vsp = 0;
spd_walk = 4;
spd_dash = 10;
grv = 0.3;
jmp_spd = -9;

// --- COMBATE E VIDA ---
// Sincroniza a vida local com a global do obj_game
if (variable_global_exists("vida_atual")) {
    vida_max = global.vida_max;
    vida_atual = global.vida_atual;
} else {
    // Caso o obj_game falhe, define valores padrão
    vida_max = 3;
    vida_atual = 3;
}

combo = 0;
timer_combo = 0;
invencivel = false;

// --- MÁQUINA DE ESTADOS ---
enum ESTADO {
    LIVRE,
    ATAQUE,
    DASH,
    DASH_ATAQUE,
    DASH_ESPECIAL,
    HIT,
    MORTE
}
estado = ESTADO.LIVRE;

image_speed = 1;
mask_index = Personagem_parado;