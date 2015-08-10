part of arista_server.controllers;

@Controller('/api/cloud-targets')
class CloudTargetsServices
    extends PostgresController<CloudTargetSchema>
    implements SchemaBuilder<CloudTargetSchema> {
  FileServices fileServices;

  CloudTargetsServices(this.fileServices, PostgreSql conn)
      : super('cloudTargets', 'cloudTargetId', conn);

  @GetJson('/:cloudTargetId')
  Future<CloudTargetSchema> getCloudTarget(
      String cloudTargetId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var dummyObject = await findByPrimaryKey(cloudTargetId);

    if (build == true) {
      dummyObject =
          buildFromSchema(dummyObject, recursive: recursive == true);
    }

    return dummyObject;
  }

  @DefaultPostJson()
  Future<CloudTargetSchema> nuevoCloudTarget(@DecodeAny CloudTargetSchema target) async
  {
    target..cloudTargetId = new Uuid().v1();
    await insert(target);
    return getCloudTarget(target.cloudTargetId);
  }

  @PutJson('/:cloudTargetId')
  Future<CloudTargetSchema> updateCloudTarget(
      String cloudTargetId,
      @DecodeAny CloudTargetSchema delta) async {
    await updateOnPrimaryKey(delta, cloudTargetId);
    return getCloudTarget(cloudTargetId);
  }

  @DeleteJson('/:cloudTargetId')
  Future deleteCloudTarget(String cloudTargetId) =>
      deleteOnPrimaryKey(cloudTargetId);

  @DefaultGetJson()
  Future<List<CloudTargetSchema>> allCloudTargets() => find();

  @override
  Future<CloudTarget> buildFromSchema(CloudTargetSchema schema,
      {bool recursive}) async {
    CloudTarget target = cast(schema, CloudTarget);

    if (target.imageId != null) target.image =
    await fileServices.getMetadata(target.imageId);

    if (recursive) {

    }

    return target;
  }
}
