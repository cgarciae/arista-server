part of arista_server.controllers;

@Action('/')
rootRedirect() => redirect('/home');

@AdmittedRoles(const [Role.user], failureRedirect: '/users/login')
@Controller('/home')
class HomeController {
  UserServices usersServices;
  EventosServices eventosServices;
  PostgreSql postgreSql;

  HomeController(this.usersServices, this.eventosServices, this.postgreSql);


}
