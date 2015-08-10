part of arista_server.controllers;

@Controller('/api/dummy-objects')
class DummyObjectsServices
    extends PostgresController<DummyObjectSchema>
    implements SchemaBuilder<DummyObjectSchema> {
  FileServices fileServices;

  DummyObjectsServices(this.fileServices, PostgreSql conn)
      : super('dummyObjects', 'dummyObjectId', conn);

  @GetJson('/:dummyObjectId')
  Future<DummyObjectSchema> getDummyObject(
      String dummyObjectId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var dummyObject = await findByPrimaryKey(dummyObjectId);

    if (build == true) {
      dummyObject =
          buildFromSchema(dummyObject, recursive: recursive == true);
    }

    return dummyObject;
  }

  @DefaultPostJson()
  Future<DummyObjectSchema> nuevoDummyObject(@DecodeAny DummyObjectSchema object) async
  {
    object..dummyObjectId = new Uuid().v1();
    await insert(object);
    return getDummyObject(object.dummyObjectId);
  }

  @PutJson('/:dummyObjectId')
  Future<DummyObjectSchema> updateDummyObject(
      String dummyObjectId,
      @DecodeAny DummyObjectSchema delta) async {
    await updateOnPrimaryKey(delta, dummyObjectId);
    return getDummyObject(dummyObjectId);
  }

  @DeleteJson('/:dummyObjectId')
  Future deleteDummyObject(String dummyObjectId) =>
      deleteOnPrimaryKey(dummyObjectId);

  @DefaultGetJson()
  Future<List<DummyObjectSchema>> allDummyObjects() => find();

  @override
  Future<DummyObject> buildFromSchema(DummyObjectSchema schema,
      {bool recursive}) async {
    DummyObject object = cast(schema, DummyObject);

    if (object.imagenId != null) object.imagen =
        await fileServices.getMetadata(object.imagenId);

    if (recursive) {

    }

    return object;
  }
}
