// Desenha a "caixa" da vida (fundo preto)
draw_set_color(c_black);
draw_rectangle(10, 10, 210, 30, false);

// Calcula tamanho da barra vermelha
var porcentagem_vida = (vida_atual / vida_max) * 100;
var largura_barra = (porcentagem_vida / 100) * 200;

// Desenha a vida (vermelho)
draw_set_color(c_red);
draw_rectangle(10, 10, 10 + largura_barra, 30, false);

// Borda branca (opcional)
draw_set_color(c_white);
draw_rectangle(10, 10, 210, 30, true);