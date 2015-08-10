part of arista_server.controllers;


@Controller('/api/local-targets')
class LocalTargetsServices
extends PostgresController<LocalTargetSchema>
implements SchemaBuilder<LocalTargetSchema> {
  FileServices fileServices;

  LocalTargetsServices(this.fileServices, PostgreSql conn)
  : super('localTargets', 'localTargetId', conn);

  @GetJson('/:localTargetId')
  Future<LocalTargetSchema> getLocalTarget(
      String localTargetId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var localTarget = await findByPrimaryKey(localTargetId);

    if (build == true) {
      localTarget =
      buildFromSchema(localTarget, recursive: recursive == true);
    }

    return localTarget;
  }

  @DefaultPostJson()
  Future<LocalTargetSchema> nuevoLocalTarget(@DecodeAny LocalTargetSchema target) async
  {
    target..localTargetId = new Uuid().v1();
    await insert(target);
    return getLocalTarget(target.localTargetId);
  }

  @PutJson('/:localTargetId')
  Future<LocalTargetSchema> updateLocalTarget(
      String localTargetId,
      @DecodeAny LocalTargetSchema delta) async {
    await updateOnPrimaryKey(delta, localTargetId);
    return getLocalTarget(localTargetId);
  }

  @DeleteJson('/:localTargetId')
  Future deleteLocalTarget(String localTargetId) =>
  deleteOnPrimaryKey(localTargetId);

  @DefaultGetJson()
  Future<List<LocalTargetSchema>> allLocalTargets() => find();

  @override
  Future<LocalTarget> buildFromSchema(LocalTargetSchema schema,
                                              {bool recursive}) async {
    LocalTarget target = cast(schema, LocalTarget);

    if (target.datId != null) target.dat =
    await fileServices.getMetadata(target.datId);

    if (target.xmlId != null) target.xml =
    await fileServices.getMetadata(target.xmlId);

    if (target.imageId != null) target.image =
    await fileServices.getMetadata(target.imageId);

    if (recursive) {

    }

    return target;
  }
}
