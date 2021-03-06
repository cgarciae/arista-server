part of arista_server.models;

class UserSchema
{
  @Field() String userId;
  @Field() String nombre;
  @Field() String apellido;
  @Field() String email;
  @Field() num money;
}

class User extends UserSchema {
  @Field() List<String> roles;
}
