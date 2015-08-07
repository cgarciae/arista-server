//redstone
import 'package:redstone/redstone.dart' as app;
//mapper
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper_pg/manager.dart';
//di
import 'package:di/di.dart';
//plugins
import 'package:redstone_cookies_plugin/redstone_cookies_plugin.dart';
import 'package:redstone_configuration_plugin/redstone_configuration_plugin.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mvc/redstone_mvc.dart';
//http
import 'package:http/http.dart' as http;
//shelf
import 'package:shelf_static/shelf_static.dart';
//google
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/oauth2/v2.dart' as oauth;
//arista
import 'package:arista-server/models.dart';
import 'package:arista-server/services.dart';
import 'package:arista-server/config.dart';
import 'package:arista-server/controllers.dart';
import 'package:arista-server/models.dart';

main() async {
  var uri = "postgres://arista:arista1234@$boot2docker_ip:5432/postgres";
  var dbManager = new PostgreSqlManager(uri, min: 5, max: 15);
  await dbManager.start();
  var conn = await dbManager.getConnection();
  print("Got connection");

  //Build configuration
  var configurationBuilder = new ConfigurationBuilder()
    ..addConfiguration("config.json");

  //Mvc Configuration
  configureMvc();

  //Plugins
  app.addPlugin(configurationPlugin(configurationBuilder));
  app.addPlugin(getMapperPlugin(dbManager));
  app.addPlugin(mvcPluggin);
  app.addPlugin(cookiesPlugin);

  //DI
  var module = new Module()
    ..bind(PostgreSql, toValue: null)
    ..bind(UserServices)
    ..bind(UsersController)
    ..bind(FileServices)
    ..bind(FilesController);
  app.addModule(module);

  //no error page
  app.showErrorPage = false;

  //file server
  app.setShelfHandler(createStaticHandler(staticFolder,
    defaultDocument: "index.html", serveFilesOutsidePath: true));

  //Start
  app.setupConsoleLog();
  app.start(port: port);

  conn.innerConn.close();
}

@GetView("/test-users",
    template: "{{#.}}userId: {{userId}} <br> nombre: {{nombre}} <br><br> {{/.}} ")
listUsers(@app.Attr("dbConn") PostgreSql db) async =>
    db.query("select * from users", User);

@Controller('/test')
class TestRoutes {
  @GetView("/:hola", template: "{{hola}}: {{chao}}")
  test(String hola) async {
    return {'hola': hola};
  }
}

@GetJson("/users/:id/change")
newUser(String id, @app.Attr("dbConn") PostgreSql db, @Decode(
    fromQueryParams: true) User user) {
  Map userMap = encode(user);
  List<String> modKeys = userMap.keys.map((s) => '"$s"').toList();
  String structure = '(' + modKeys.join(',') + ')';
  String values = '(' + userMap.keys.map((s) => "@$s").join(',') + ')';

  var query = """
      UPDATE users
        SET $structure = $values
      WHERE "userId" = @userId
      """;

  user.userId = id;

  return db.query(query, User, user);
}

@app.Interceptor(r'/.*')
handleResponseHeader() async {
    await app.chain.next();
    return app.response.change(headers: _specialHeaders());
}
_specialHeaders() {
  var cross = {"Access-Control-Allow-Origin": "*"};

  if (tipoBuild <= TipoBuild.jsTesting) {
    cross['Cache-Control'] =
    'private, no-store, no-cache, must-revalidate, max-age=0';
  }

  return cross;
}