part of arista_server.controllers;

@Controller('/files')
@AdmittedRoles(const [Role.admin])
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
    return redirect('/files/${fileDb.fileId}/view');
  }

  @Post ('/:fileId/change', allowMultipartRequest: true)
  changeFile (String fileId, @Body(FORM) DynamicMap form) async {
    await updateFile(fileId, form.file);
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