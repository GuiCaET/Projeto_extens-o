/// @description Inicializar Variáveis

// --- FÍSICA ---
hsp = 0;
vsp = 0;
spd_walk = 4;
spd_dash = 10;      // Velocidade do Dash Normal
grv = 0.3;
jmp_spd = -9;       // Pulo ajustado conforme seu pedido

// --- COMBATE ---
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

// --- CORREÇÃO DE COLISÃO (IMPORTANTE) ---
// Isso impede o boneco de ficar preso no chão depois do dash
mask_index = Personagem_parado;

vida_max = 5;
vida_atual = vida_max;
// invencivel = false; // (Já deve ter essa variável do dash, se não tiver, crie)