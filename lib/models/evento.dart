part of arista_server.models;

class EventoSchema {
  @Field() String eventoId;
  @Field() String ownerId;
  @Field() String imagenPreviewId;
  @Field() String nombre;
  @Field() String descripcion;
  @Field() String cloudTargetId;
  @Field() bool active;

  bool get valid => throw new UnimplementedError();
}

class Evento extends EventoSchema {
  @Field() String href;
  @Field() User owner;
  @Field() FileSchema imagenPreview;
  @Field() List<VistaSchema> vistas;
  @Field() CloudTarget cloudTarget;

  bool get valid
  {
    if (eventoId == null || eventoId == "")
      return false;

    if (active == null || ! active)
      return false;

    if (cloudTarget == null || cloudTargetId == null)
      return false;

    if (vistas.any((VistaSchema v) => v.valid))
      return false;

    return true;
  }
}