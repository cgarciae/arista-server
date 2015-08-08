part of arista_server.services;

@Controller('/api/users')
class UserServices extends PostgresController<UserSchema> {
  UserServices(PostgreSql conn) : super('users', 'userId', conn);

  @GetJson('/:userId')
  @AdmittedRoles(const [Role.admin])
  Future<UserSchema> getUser(String userId, {@app.QueryParam() String build, @app.QueryParam() String recursive}) async {
    var user = await findByPrimaryKey(userId);

    if (build == 'true') {
      user = await buildFromSchema(user, recursive: recursive == 'true');
    }

    return user;
  }

  @DefaultGetJson()
  allUsers() => find();

  @GetJson('/:userId/roles')
  Future<List<String>> getUserRoles(String userId) {
    return postgreSql.innerConn.query("""
      SELECT "role"."roleName" FROM "userRoles" "userRole"
        JOIN "roles" "role" ON "userRole"."roleId" = "role"."roleId"
        JOIN "users" "user" ON "userRole"."userId" = "user"."userId"
      WHERE "user"."userId" = @userId;
    """, {primaryKeyName: userId}).map((row) => row.roleName.trim()).toList();
  }

  Future<User> buildFromSchema(UserSchema userSchema, {bool recursive}) async {
    User user = cast(userSchema, User);
    user.roles = await getUserRoles(user.userId);

    if (recursive == true) {

    }

    return user;
  }
}
