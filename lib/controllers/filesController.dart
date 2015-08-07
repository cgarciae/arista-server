part of arista_server.controllers;

@Controller('/files')
class FilesController extends FileServices {
  FilesController(PostgreSql conn): super(conn);

  @DefaultGetView(viewSubPath: '/all')
  allFiles() async {
    var files = await find();
    return files.map(fileDbViewMap);
  }

  @GetView('/new')
  newFormView() => {};

  @PostJson('/upload', allowMultipartRequest: true)
  uploadFile(@app.Body(app.FORM) DynamicMap form) async {
    var fileDb = await newFile(form.file, filename: form.filename);
    return app.redirect('/files/${fileDb.fileId}/view');
  }

  @GetView("/:fileId/view", viewLocalPath: '/view')
  viewFile (String fileId) async {
    var fileDb = await findByPrimaryKey('fileId', fileId);
    return fileDbViewMap(fileDb);
  }

  @Get('/:fileId/delete')
  deleteFile(String fileId) async {
    await super.deleteFile(fileId);
    return app.redirect('/files');
  }

  Map fileDbViewMap (FileDb fileDb) {
    var map = encode(fileDb);
    map['isImage'] = fileDb.contentType.contains('image');
    map['localHost'] = localHost;
    map['imageHref'] = localHost + 'api/files/${fileDb.fileId}';

    return map;
  }
}