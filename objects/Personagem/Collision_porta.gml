/// @description Transição de Sala e Salvamento de HP

// 1. SALVAR A VIDA ATUAL
// Antes de sair da sala, dizemos ao Controlador (obj_game) quanta vida temos agora.
global.vida_atual = vida_atual; 

// 2. MUDAR DE FASE
// Aqui verificamos em qual sala estamos para decidir para onde ir.
if (room == Room1) 
{
    room_goto(Room2); // Se estiver na Room1, vai para a Room2
} 
else if (room == Room2) 
{
    // Se você tiver uma Room3, mude aqui. 
    // Por enquanto, vamos supor que ele volta para a 1 ou vai para um Menu.
    room_goto(Room1); 
}

/* DICA: Se você quiser que a porta seja automática para qualquer sala, 
   você pode usar apenas: room_goto_next(); 
   Isso levará o jogador para a próxima sala na ordem da lista (Room Manager).
*/