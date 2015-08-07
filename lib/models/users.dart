part of arista_server.models;

class User
{
  @Field() String get href => userId != null ? localHost + 'user/$userId' : null;

  @Field() String userId;
  @Field() String nombre;
  @Field() String apellido;
  @Field() String email;
}

class ProtectedUser extends User {
  @Field() num money;
  @Field() bool admin;
}
