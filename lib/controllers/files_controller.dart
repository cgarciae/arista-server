part of arista_server.controllers;

@Controller('/files')
class FilesController extends FileServices {

  FilesController(PostgreSql conn, Env env): super(conn, env);
  
  @DefaultGetView(viewSubPath: '/all')
  allFiles() async {
    var files = await find();
    return files.map(fileDbViewMap);
  }

  @GetView('/new')
  newFormView() => {};

  @Post('/upload', allowMultipartRequest: true)
  uploadFile(@Body(FORM) DynamicMap form) async {
    var fileDb = await newFile(form.file, filename: form.filename);

    await updateMetadata(fileDb.fileId, new FileSchema()
      ..version = form.version.trim() == "" ? 1 : int.parse(form.version)
    );
    return redirect('/files/${fileDb.fileId}/view');
  }

  @Post ('/:fileId/change', allowMultipartRequest: true)
  changeFile (String fileId, @Body(FORM) DynamicMap form) async {
    HttpBodyFileUpload file = form.file;
    print(file);
    if (file == null || file.content.length < 1){
      await updateMetadata(fileId, new FileSchema()
        ..version = int.parse(form.version)
      );
    }
    else{
      await updateFile(fileId, form.file);
      await updateMetadata(fileId, new FileSchema()
        ..version = int.parse(form.version)
        ..filename = file.filename
        ..contentType = file.contentType.value
      );
    }



    return redirect('/files/$fileId/view');
  }

  @GetView("/:fileId/view", viewLocalPath: '/view')
  viewFile (String fileId) async {
    var fileDb = await findByPrimaryKey(fileId);
    return fileDbViewMap(fileDb);
  }

  @Get('/:fileId/delete')
  deleteFile(String fileId) async {
    await super.deleteFile(fileId);
    return redirect('/files');
  }

  Map fileDbViewMap (FileSchema fileDb) {
    var map = encode(fileDb);
    map['isImage'] = fileDb.contentType.contains('image');
    map['localHost'] = env.fullHost;
    map['imageHref'] = env.fullHost + '/api/files/${fileDb.fileId}';

    return map;
  }
}