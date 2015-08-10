part of arista_server.controllers;

@Controller('/api/eventos')
class EventosServices extends PostgresController<EventoSchema>
    implements SchemaBuilder<EventoSchema> {
  FileServices fileServices;
  CloudTargetsServices cloudTargetsServices;
  VistasServices vistasServices;

  EventosServices(this.vistasServices, this.cloudTargetsServices,
      this.fileServices, PostgreSql conn)
      : super('eventos', 'eventoId', conn);

  @GetJson('/:eventoId')
  Future<EventoSchema> getEvento(String eventoId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var evento = await findByPrimaryKey(eventoId);

    if (build == true) {
      evento = buildFromSchema(evento, recursive: recursive == true);
    }

    return evento;
  }

  @DefaultPostJson()
  Future<EventoSchema> nuevoEvento(@DecodeAny EventoSchema evento) async {
    evento..eventoId = new Uuid().v1();
    await insert(evento);
    return getEvento(evento.eventoId);
  }

  @PutJson('/:eventoId')
  Future<EventoSchema> updateEvento(
      String eventoId, @DecodeAny EventoSchema delta) async {
    await updateOnPrimaryKey(delta, eventoId);
    return getEvento(eventoId);
  }

  @DeleteJson('/:eventoId')
  Future deleteEvento(String eventoId) => deleteOnPrimaryKey(eventoId);

  @DefaultGetJson()
  Future<List<EventoSchema>> allEventos() => find();

  @override
  Future<Evento> buildFromSchema(EventoSchema schema, {bool recursive}) async {
    Evento evento = cast(schema, Evento);

    if (evento.cloudTargetId != null) evento.cloudTarget =
        await cloudTargetsServices.getCloudTarget(evento.cloudTargetId,
            build: recursive, recursive: recursive);

    if (evento.imagenPreviewId != null) evento.imagenPreview =
        await fileServices.getMetadata(evento.imagenPreviewId);

    evento.vistas = await vistasServices.find("""
      "eventoId" = @eventoId
    """, {"eventoId": evento.eventoId});

    if (recursive) {
      evento.vistas = await Future.wait(evento.vistas.map(
          (VistaSchema vista) async => vistasServices.getVista(vista.vistaId,
              build: recursive, recursive: recursive)));
    }

    return evento;
  }
}
