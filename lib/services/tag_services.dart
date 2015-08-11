part of arista_server.controllers;

@Controller('/api/tags')
class TagsServices
    extends PostgresController<TagSchema>
    implements SchemaBuilder<TagSchema> {

  TagsServices(PostgreSql conn)
      : super('tags', 'tagId', conn);

  @GetJson('/:tagId')
  Future<TagSchema> getTag(
      String tagId,
      {@QueryParam() bool build, @QueryParam() bool recursive}) async {
    var tag = await findByPrimaryKey(tagId);

    if (build == true) {
      tag =
          buildFromSchema(tag, recursive: recursive == true);
    }

    return tag;
  }

  @DefaultPostJson()
  Future<TagSchema> nuevoTag(@DecodeAny TagSchema tag) async
  {
    tag..tagId = new Uuid().v1();
    await insert(tag);
    return getTag(tag.tagId);
  }

  @PutJson('/:tagId')
  Future<TagSchema> updateTag(
      String tagId,
      @DecodeAny TagSchema delta) async {
    await updateOnPrimaryKey(delta, tagId);
    return getTag(tagId);
  }

  @DeleteJson('/:tagId')
  Future deleteTag(String tagId) =>
      deleteOnPrimaryKey(tagId);

  @DefaultGetJson()
  Future<List<TagSchema>> allTags() => find();

  @override
  Future<TagSchema> buildFromSchema(TagSchema schema,
      {bool recursive}) async {

    return schema;
  }
}
