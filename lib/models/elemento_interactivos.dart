part of arista_server.models;

class ElementoInteractivoSchema {
  @Field() String elementoInteractivoId;
  @Field() String tag;
  @Field() String titulo;
  @Field() String imagenId;
  @Field() String texto;
  @Field() String vistaId;
  @Field() String ownerId;
}

class ElementoInteractivo extends ElementoInteractivoSchema {
  @Field() FileSchema imagen;
}