part of arista_server.controllers;

@Controller('/api/vuforia-target-records')
class VuforiaTargetRecordsServices
    extends PostgresController<VuforiaTargetRecordSchema>
    implements SchemaBuilder<VuforiaTargetRecordSchema> {
  FileServices fileServices;

  VuforiaTargetRecordsServices(PostgreSql conn)
      : super('vuforiaTargetRecords', 'target_id', conn);

  @GetJson('/:target_id')
  Future<VuforiaTargetRecordSchema> getVuforiaTargetRecord(
      String target_id,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var vuforiaTargetRecord = await findByPrimaryKey(target_id);

    if (build == true) {
      vuforiaTargetRecord =
          buildFromSchema(vuforiaTargetRecord, recursive: recursive == true);
    }

    return vuforiaTargetRecord;
  }

  @DefaultPostJson()
  Future<VuforiaTargetRecordSchema> nuevoVuforiaTargetRecord(@DecodeAny VuforiaTargetRecordSchema targetRecord) async
  {
    targetRecord..target_id = new Uuid().v1();
    await insert(targetRecord);
    return getVuforiaTargetRecord(targetRecord.target_id);
  }

  @PutJson('/:target_id')
  Future<VuforiaTargetRecordSchema> updateVuforiaTargetRecord(
      String target_id,
      @DecodeAny VuforiaTargetRecordSchema delta) async {
    await updateOnPrimaryKey(delta, target_id);
    return getVuforiaTargetRecord(target_id);
  }

  @DeleteJson('/:target_id')
  Future deleteVuforiaTargetRecord(String target_id) =>
      deleteOnPrimaryKey(target_id);

  @DefaultGetJson()
  Future<List<VuforiaTargetRecordSchema>> allVuforiaTargetRecords() => find();

  @override
  Future<VuforiaTargetRecord> buildFromSchema(VuforiaTargetRecordSchema schema,
      {bool recursive}) async {
    VuforiaTargetRecord targetRecord = cast(schema, VuforiaTargetRecord);

    if (recursive) {

    }

    return targetRecord;
  }
}
