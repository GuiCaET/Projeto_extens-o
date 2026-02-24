/// @description Teleportar
// Verifica se foi definido um destino
if (target_room != -1)
{
    // Move o personagem
    other.x = target_x;
    other.y = target_y;

    // Muda a sala
    room_goto(target_room);
}

