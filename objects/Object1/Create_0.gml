/// @description Variáveis do Inimigo

// --- CONFIGURAÇÃO DE VIDA DE BOSS ---
vida_max = 30;          // 30 Hits para morrer
vida_atual = vida_max;  // Começa cheio
invencivel = false;     // Começa podendo tomar dano

// --- FÍSICA ---
hsp = 0;
vsp = 0;
grv = 0.3;
velocidade = 2;

// --- COMBATE ---
vida_max = 30;
vida_atual = vida_max;
dano = 1;
timer_ataque = 0; // Tempo entre ataques

// --- IA (Inteligência) ---
alcance_visao = 200; // Distância para começar a perseguir
alcance_ataque = 30; // Distância para parar e bater

enum ESTADO_INIMIGO {
    PARADO,
    PERSEGUINDO,
    ATACANDO,
    HIT,
    MORTE
}
estado = ESTADO_INIMIGO.PARADO;