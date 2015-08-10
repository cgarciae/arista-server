part of arista_server.controllers;

@Controller('/api/objetos-unity')
class ObjetosUnityServices extends PostgresController<ObjetoUnitySchema>
    implements SchemaBuilder<ObjetoUnitySchema> {
  FileServices fileServices;

  ObjetosUnityServices(this.fileServices, PostgreSql conn)
      : super('objetosUnity', 'objetoUnityId', conn);

  @GetJson('/:objetoUnityId')
  Future<ObjetoUnitySchema> getObjetosUnity(String objetoUnityId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var objetoUnity = await findByPrimaryKey(objetoUnityId);

    if (build == true) {
      objetoUnity = buildFromSchema(objetoUnity, recursive: recursive == true);
    }

    return objetoUnity;
  }

  @DefaultPostJson()
  Future<ObjetoUnitySchema> nuevoObjetosUnity(
      @DecodeAny ObjetoUnitySchema objeto) async {
    objeto..objetoUnityId = new Uuid().v1();
    await insert(objeto);
    return getObjetosUnity(objeto.objetoUnityId);
  }

  @PutJson('/:objetoUnityId')
  Future<ObjetoUnitySchema> updateObjetosUnity(
      String objetoUnityId, @DecodeAny ObjetoUnitySchema delta) async {
    await updateOnPrimaryKey(delta, objetoUnityId);
    return getObjetosUnity(objetoUnityId);
  }

  @DeleteJson('/:objetoUnityId')
  Future deleteObjetosUnity(String objetoUnityId) =>
      deleteOnPrimaryKey(objetoUnityId);

  @DefaultGetJson()
  Future<List<ObjetoUnitySchema>> allObjetosUnity() => find();

  @override
  Future<ObjetoUnity> buildFromSchema(ObjetoUnitySchema schema,
      {bool recursive}) async {
    ObjetoUnity objeto = cast(schema, ObjetoUnity);

    if (objeto.screenshotId != null) objeto.screenshot =
        await fileServices.getMetadata(objeto.screenshotId);

    if (objeto.userFileId != null) objeto.userFile =
        await fileServices.getMetadata(objeto.userFileId);

    if (objeto.iosId != null) objeto.ios =
        await fileServices.getMetadata(objeto.iosId);

    if (objeto.androidId != null) objeto.android =
        await fileServices.getMetadata(objeto.androidId);

    if (objeto.windowsId != null) objeto.windows =
        await fileServices.getMetadata(objeto.windowsId);

    if (objeto.osxId != null) objeto.osx =
        await fileServices.getMetadata(objeto.osxId);

    return objeto;
  }
}
