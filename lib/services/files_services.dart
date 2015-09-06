part of arista_server.controllers;

@Controller('/api/files')
class FileServices extends PostgresController<FileSchema> {
  Env env;

  FileServices(PostgreSql conn, this.env) : super('files', 'fileId', conn);

  Future<FileSchema> newFile(HttpBodyFileUpload file, {String filename}) async {
    FileSchema fileDb = new FileSchema()
      ..fileId = new Uuid().v1()
      ..fileUploadDate = new DateTime.now()
      ..filename = filename != null ? filename : file.filename
      ..contentType = file.contentType.value
      ..version = 1;

    var fileContent = getContentFromBodyFile(file);
    await writeFile(fileDb.fileId, fileContent);
    await insert(fileDb, correctMap: (map) {
      map.fileUploadDate = fileDb.fileUploadDate.toUtc();
    });

    return fileDb;
  }

  Future writeFile(String id, List<int> data) async {
    var file = new File('${env.filesPath}/$id');
    await file.writeAsBytes(data);
  }

  Future updateFile (String fileId, HttpBodyFileUpload file) async {
    var fileContent = getContentFromBodyFile(file);
    await writeFile(fileId, fileContent);
  }

  Stream<List<int>> readFile(String id) async* {
    var file = new File("${env.filesPath}/$id");

    if (await file.exists()) {
      yield* file.openRead();
    } else {
      yield [];
    }
  }

  @Get('/:id')
  Future<shelf.Response> downloadFile(String id) async {
    try {
      FileSchema metadata = await getMetadata(id);
      return new shelf.Response.ok(readFile(id),
          headers: {
            "Content-Type": metadata.contentType,
            "Content-Disposition": "attachment; filename=${metadata.filename};"
          });
    } catch (e, s) {
      return new shelf.Response.ok("Server Error: $e \n $s");
    }
  }

  Future<FileSchema> getMetadata(String fileId) async {
    return findByPrimaryKey(fileId);
  }

  Future<FileSchema> updateMetadata(String fileId, FileSchema delta) async {
    await updateOnPrimaryKey(delta, fileId);
    return getMetadata(fileId);
  }

  Future deleteFile(String id) async {
    var file = new File("${env.filesPath}/$id");
    if (await file.exists()) await file.delete();
    await deleteMetadata(id);
  }

  Future deleteMetadata(String id) async {
    return deleteOnPrimaryKey(id);
  }

  List<int> getContentFromBodyFile (HttpBodyFileUpload file) => file.content is String?
    UTF8.encode(file.content): file.content;
}
