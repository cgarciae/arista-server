part of arista_server.controllers;

@Controller('/eventos')
class EventosController extends EventosServices {

  EventosController(VistasServices vistasServices,
      CloudTargetsServices cloudTargetsServices, FileServices fileServices,
      PostgreSql conn)
      : super(vistasServices, cloudTargetsServices, fileServices, conn);

  @DefaultGetView(viewSubPath: '/index')
  index(@UserId String userId) async {
    List list = encode(await find("""
        "ownerId" = @userId
      """, {'userId': userId}));

    list
      ..add(list[0])
      ..add(list[0]);

    list = []..addAll(list)..addAll(list);

    return {
      'eventos': list
    };
  }

  @GetView('/:eventoId', viewLocalPath: '/evento')
  getEventoView (String eventoId) async {
    var evento = await getEvento(eventoId, build: true);
    print(evento.descripcion);
    return {
      'evento': encode(evento)
    };
  }

  @Post('/:eventoId/save-info')
  saveInfo (String eventoId, @DecodeAny EventoSchema evento) async {
    print(encode(evento));
    await updateEvento(eventoId, evento);
    return redirect('/eventos/$eventoId');
  }
}
