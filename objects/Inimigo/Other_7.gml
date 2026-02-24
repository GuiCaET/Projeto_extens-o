if (estado == ESTADO_INIMIGO.ATACANDO) {
    estado = ESTADO_INIMIGO.PARADO;
    // Pequena pausa para não atacar igual uma metralhadora
    alarm[0] = 30; // Opcional
}