part of arista_server.services;

@Controller('/api/users/v1')
class UserServices extends PostgresController<User> {
  UserServices(PostgreSql conn) : super('users', conn);

}
