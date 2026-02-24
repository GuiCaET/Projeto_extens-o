/// @description Desenhar Barra de Vida Completa

// --- 1. VERIFICAÇÃO DE SEGURANÇA ---
// Isso impede o jogo de crashar se as variáveis não estiverem prontas
var v_atual = (variable_instance_exists(id, "vida_atual")) ? vida_atual : 3;
var v_max = (variable_instance_exists(id, "vida_max")) ? vida_max : 3;

// --- 2. CÁLCULOS ---
// Previne divisão por zero
if (v_max <= 0) v_max = 3; 

// Calcula tamanho da barra vermelha
var porcentagem_vida = (v_atual / v_max) * 100;
var largura_total = 200; // Largura da caixa preta
var largura_barra = (porcentagem_vida / 100) * largura_total;

// --- 3. DESENHO DA INTERFACE ---

// Desenha a "caixa" da vida (fundo preto)
draw_set_color(c_black);
draw_rectangle(10, 10, 10 + largura_total, 30, false);

// Desenha a vida (vermelho)
draw_set_color(c_red);
// A barra vermelha desenha do início (10) até onde a porcentagem alcança
draw_rectangle(10, 10, 10 + largura_barra, 30, false);

// Borda branca (opcional)
draw_set_color(c_white);
draw_rectangle(10, 10, 10 + largura_total, 30, true);

// Opcional: Desenha o texto da vida para depuração
draw_set_halign(fa_left);
draw_text(10, 35, "HP: " + string(v_atual) + " / " + string(v_max));

// Resetar a cor para branco (evita que o resto do jogo fique vermelho/preto)
draw_set_color(c_white);