part of arista_server.tests;

userServicesTests(){

  group("Basic Tests", () {
    Module module;
    ConnectionMock conn;
    Env env;

    setUp(() async {
      var configurationBuilder = new ConfigurationBuilder()
        ..addConfiguration("config.json");

      env = getEnvironmentAs(configurationBuilder, Env);

      conn = new ConnectionMock();

      module = new Module()
        ..bind(Env, toValue: env)
        ..bind(UserServices)
        ..bind(PostgreSql, toValue: new PostgreSql(conn));

    });

    test("get user roles", () async {

      when(conn.query(any, any)).thenReturn (RowImpl.streamFromMapList([
        {"roleName": "admin"},
        {"roleName": "user"}
      ]));

      var injector = new ModuleInjector([module]);

      UserServices userServices = injector.get(UserServices);
      var roles = await userServices.getUserRoles("1234");

      expect(roles, equals(["admin", "user"]));
    });

  });

}