part of arista_server.controllers;

@Controller('/api/vistas')
class VistasServices extends PostgresController<VistaSchema>
    implements SchemaBuilder<VistaSchema> {
  FileServices fileServices;
  ElementosInteractivosServices elementosInteractivosServices;
  ObjetosUnityServices objetosUnityServices;
  LocalTargetsServices localTargetServices;

  VistasServices(this.localTargetServices, this.objetosUnityServices,
      this.elementosInteractivosServices, this.fileServices, PostgreSql conn)
      : super('vistas', 'vistaId', conn);

  @GetJson('/:vistaId')
  Future<VistaSchema> getVista(String vistaId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var vista = await findByPrimaryKey(vistaId);

    if (build == true) {
      vista = buildFromSchema(vista, recursive: recursive == true);
    }

    return vista;
  }

  @DefaultPostJson()
  Future<VistaSchema> nuevaVista(@DecodeAny VistaSchema vista) async {
    vista..vistaId = new Uuid().v1();
    await insert(vista);
    return getVista(vista.vistaId);
  }

  @PutJson('/:vistaId')
  Future<VistaSchema> updateVista(
      String vistaId, @DecodeAny VistaSchema delta) async {
    await updateOnPrimaryKey(delta, vistaId);
    return getVista(vistaId);
  }

  @DeleteJson('/:vistaId')
  Future deleteVista(String vistaId) => deleteOnPrimaryKey(vistaId);

  @DefaultGetJson()
  Future<List<VistaSchema>> allVistas() => find();

  @override
  Future<VistaSchema> buildFromSchema(VistaSchema schema,
      {bool recursive}) async {
    if (schema.type == TiposVista.vista3d) {
      return _buildVista3D(schema, recursive: recursive);
    } else {
      throw new Exception("Tipo de vista '${schema.type}' no es valido");
    }
  }

  _buildVista3D(VistaSchema schema, {bool recursive}) async {
    Vista3D vista = cast(schema, Vista3D);

    vista.elementosInteractivos = await elementosInteractivosServices.find("""
          "vistaId" = @vistaId
    """, {'vistaId': vista.vistaId});

    if (vista.objetoUnityId != null) vista.objetoUnity =
        await objetosUnityServices.getObjetosUnity(vista.objetoUnityId,
            build: recursive, recursive: recursive);

    if (vista.localTargetId != null) vista.localTarget =
        await localTargetServices.getLocalTarget(vista.localTargetId,
            build: recursive, recursive: recursive);

    if (recursive) {
      vista.elementosInteractivos = await Future.wait(
          vista.elementosInteractivos.map(
              (elem) async => elementosInteractivosServices
                  .getElementoInteractivo(elem.elementoInteractivoId,
                      build: recursive, recursive: recursive)));
    }

    return vista;
  }
}
