part of arista_server.services;

@Controller('/api/files')
class FileServices extends PostgresController<FileDb> {
  FileServices(PostgreSql conn) : super('files', conn);

  Future<FileDb> newFile(file, {String filename}) async {
    FileDb fileDb = new FileDb()
      ..fileId = new Uuid().v1()
      ..fileUploadDate = new DateTime.now()
      ..filename = filename != null ? filename : file.filename
      ..contentType = file.contentType.value;

    var fileContent = file.content is String?
      UTF8.encode(file.content): file.content;

    await writeFile(fileDb.fileId, fileContent);
    await insert(fileDb, correctMap: (map) {
      map.fileUploadDate = fileDb.fileUploadDate;
    });

    return fileDb;
  }

  Future writeFile(String id, List<int> data) async {
    var file = new File('$filesPath/$id');
    await file.writeAsBytes(data);
  }

  Stream<List<int>> readFile(String id) async* {
    var file = new File("$filesPath/$id");

    if (await file.exists()) {
      yield* file.openRead();
    } else {
      yield [];
    }
  }

  @app.Route('/:id')
  Future<shelf.Response> downloadFile(String id) async {
    try {
      var metadata = await getMetadata(id);
      return new shelf.Response.ok(readFile(id),
          headers: {"Content-Type": metadata.contentType});
    } catch (e, s) {
      return new shelf.Response.ok("Server Error: $e \n $s");
    }
  }

  Future<FileDb> getMetadata(String fileId) async {
    return findByPrimaryKey('fileId', fileId);
  }

  Future<FileDb> updateMetadata(String fileId, FileDb delta) async {
    Map resp = await updateOnKey(delta, 'fileId', fileId);
    return getMetadata(fileId);
  }

  Future deleteFile(String id) async {
    var file = new File("$filesPath/$id");
    if (await file.exists()) await file.delete();
    await deleteMetadata(id);
  }

  Future deleteMetadata(String id) async {
    return deleteOnKey('fileId', id);
  }
}
