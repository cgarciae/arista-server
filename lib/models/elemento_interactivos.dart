part of arista_server.models;

class ElementoInteractivoSchema {
  @Field() String elementoInteractivoId;
  @Field() String tag;
  @Field() String titulo;
  @Field() String imagenId;
  @Field() String texto;
}

class ElementoInteractivo extends ElementoInteractivoSchema {
  @Field() FileSchema imagen;
}