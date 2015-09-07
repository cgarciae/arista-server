//redstone
import 'package:redstone/redstone.dart';
//mapper
import 'package:redstone_mapper/mapper.dart';
import 'package:redstone_mapper/mapper_factory.dart';
import 'package:redstone_mapper_pg/manager.dart';
//di
import 'package:di/di.dart';
//plugins
import 'package:redstone_cookies_plugin/redstone_cookies_plugin.dart';
import 'package:redstone_configuration_plugin/redstone_configuration_plugin.dart';
import 'package:redstone_mapper/plugin.dart';
import 'package:redstone_mvc/redstone_mvc.dart';
import 'package:redstone_security_plugin/redstone_security_plugin.dart';
//shelf
import 'package:shelf_static/shelf_static.dart';
//arista
import 'package:arista-server/models.dart';
import 'package:arista-server/config.dart';
import 'package:arista-server/controllers.dart';
//import 'package:arista-server/models.dart';
import 'dart:mirrors';
import 'dart:convert';

Env env;

main() async {

  print("INIT ARISTA SERVER");

  bootstrapMapper();
  //Build configuration
  var configurationBuilder = new ConfigurationBuilder()
    ..addConfiguration("config.json");

  env = getEnvironmentAs(configurationBuilder, Env);

  //postgres
  var uri =
      "postgres://${env.dbUser}:${env.dbPassword}@${env.dbHost}:${env.dbPort}/${env.dbName}";
  var dbManager = new PostgreSqlManager(uri, min: 5, max: 15);
  var conn = await dbManager.getConnection();
  print("Got connection");

  //Mvc Configuration
  configureMvc(new MvcConfig(encoding:LATIN1));

  //DI
  var requestModule = new Module()
    ..bind(PostgreSql, toValue: null)
    ..bind(Env, toValue: env)
    ..bind(UserServices)
    ..bind(UsersController)
    ..bind(FileServices)
    ..bind(FilesController)
    ..bind(ElementosInteractivosServices)
    ..bind(VistasServices)
    ..bind(ObjetosUnityServices)
    ..bind(LocalTargetsServices)
    ..bind(CloudTargetsServices)
    ..bind(EventosServices)
    ..bind(VuforiaTargetRecordsServices)
    ..bind(TagsServices);
  //DI for ini
  var initModule = new Module()
    ..bind(PostgreSql, toValue: conn)
    ..bind(Env, toValue: env)
    ..bind(UserServices)
    ..bind(UsersController)
    ..bind(FileServices)
    ..bind(FilesController)
    ..bind(ElementosInteractivosServices)
    ..bind(VistasServices)
    ..bind(ObjetosUnityServices)
    ..bind(LocalTargetsServices)
    ..bind(CloudTargetsServices)
    ..bind(EventosServices)
    ..bind(VuforiaTargetRecordsServices)
    ..bind(TagsServices);

  addModule(requestModule);
  var requestInjector = new ModuleInjector([requestModule]);
  var initInjector = new ModuleInjector([initModule]);

  //Plugins
  addPlugin(configurationPlugin(configurationBuilder));
  addPlugin(getMapperPlugin(dbManager));
  addPlugin(mvcPluggin);
  addPlugin(cookiesPlugin);
  addPlugin(securityPlugin((Request request, String userId) {
    UserServices userServices = requestInjector.get(UserServices);
    return userServices.getUserRoles(userId);
  }, defaultRedirect: "/users/login"));

  //no error page
  showErrorPage = false;

  //file server
  setShelfHandler(createStaticHandler(env.staticFolder,
      defaultDocument: "index.html", serveFilesOutsidePath: true));

  //Start
  setupConsoleLog();
  start(port: env.appPort);

  conn.innerConn.close();
}

@GetView("/test-users",
    template: "{{#.}}userId: {{userId}} <br> nombre: {{nombre}} <br><br> {{/.}} ")
listUsers(@Attr("dbConn") PostgreSql db) async =>
    db.query("select * from users", UserSchema);

@Controller('/test')
class TestRoutes {
  @GetView("/:hola", template: "{{hola}}: {{chao}}")
  test(String hola) async {
    return {'hola': hola};
  }

  @GetView('/int-post-param')
  testIntPostParam(@DecodeQueryParams TestClass test) {
    return test.number != null ? (test..number += 1) : test;
  }

  @GetJson('/reflection')
  testReflection() {
    return reflectClass(TestClass).newInstance(
        #fromJson, [{'number': '3'}]).reflectee;
  }
}

class TestClass {
  @Field() int number;

  TestClass();

  factory TestClass.fromStringMap (Map map) {
    var number = int.parse(map['number']);
    map.remove('number');

    TestClass test = decode(map, TestClass);
    test.number = number;

    return test;
  }
}

@GetJson("/users/:id/change")
newUser(String id, @Attr("dbConn") PostgreSql db, @Decode(
    fromQueryParams: true) UserSchema user) {
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

  return db.query(query, UserSchema, user);
}

@Interceptor(r'/.*')
handleResponseHeader() async {
  await chain.next();
  return response.change(headers: _specialHeaders());
}
_specialHeaders() {
  var cross = {"Access-Control-Allow-Origin": "*"};

  if (env.buildPriority <= BuildPriority.js) {
    cross['Cache-Control'] =
        'private, no-store, no-cache, must-revalidate, max-age=0';
  }

  return cross;
}
