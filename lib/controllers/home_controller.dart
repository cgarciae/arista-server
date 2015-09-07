part of arista_server.controllers;

@Action('/')
rootRedirect() => redirect('/home');

@Controller('/home')
class HomeController {
  UserServices usersServices;
  EventosServices eventosServices;
  PostgreSql postgreSql;

  HomeController(this.usersServices, this.eventosServices, this.postgreSql);

  @DefaultGetView(viewLocalPath: '/index', ignoreMaster:true)
  index() => {};


}
