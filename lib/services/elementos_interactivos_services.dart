part of arista_server.controllers;


@Controller('/api/elementos-interactivos')
class ElementosInteractivosServices
    extends PostgresController<ElementoInteractivoSchema>
    implements SchemaBuilder<ElementoInteractivoSchema> {
  FileServices fileServices;

  ElementosInteractivosServices(this.fileServices, PostgreSql conn)
      : super('elementosInteractivos', 'elementoInteractivoId', conn);

  @GetJson('/:elementoInteractivoId')
  Future<ElementoInteractivoSchema> getElementoInteractivo(
      String elementoInteractivoId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var elementoInteractivo = await findByPrimaryKey(elementoInteractivoId);

    if (build == true) {
      elementoInteractivo =
          buildFromSchema(elementoInteractivo, recursive: recursive == true);
    }

    return elementoInteractivo;
  }

  @DefaultPostJson()
  Future<ElementoInteractivoSchema> nuevoElementoInteractivo(@DecodeAny ElementoInteractivoSchema elemento) async
  {
    elemento..elementoInteractivoId = new Uuid().v1();
    await insert(elemento);
    return getElementoInteractivo(elemento.elementoInteractivoId);
  }

  @PutJson('/:elementoInteractivoId')
  Future<ElementoInteractivoSchema> updateElementoInteractivo(
      String elementoInteractivoId,
      @DecodeAny ElementoInteractivoSchema delta) async {
    await updateOnPrimaryKey(delta, elementoInteractivoId);
    return getElementoInteractivo(elementoInteractivoId);
  }

  @DeleteJson('/:elementoInteractivoId')
  Future deleteElementoInteractivo(String elementoInteractivoId) =>
      deleteOnPrimaryKey(elementoInteractivoId);

  @DefaultGetJson()
  Future<List<ElementoInteractivoSchema>> allVistas() => find();

  @override
  Future<ElementoInteractivo> buildFromSchema(ElementoInteractivoSchema schema,
      {bool recursive}) async {
    ElementoInteractivo elemento = cast(schema, ElementoInteractivo);

    if (elemento.imagenId != null) elemento.imagen =
        await fileServices.getMetadata(elemento.imagenId);

    if (recursive) {

    }

    return elemento;
  }
}
