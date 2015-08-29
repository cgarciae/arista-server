part of arista_server.controllers;

@Controller("/users")
class UsersController extends UserServices {
  UsersController(PostgreSql conn) : super(conn);

  @GetView('/login')
  login() => {};

  @Get('/redirect')
  redirectUrl(@ConfigurationField() GoogleConfig google) async {
    var id = new auth.ClientId(google.identifier, google.secret);
    var url = authenticationUri(id, google.scopes, google.redirectUrl);
    return redirect(url);
  }

  @GetJson("/authenticate")
  authenticate(@QueryParam() String code,
      @ConfigurationField() GoogleConfig google) async {
    var id = new auth.ClientId(google.identifier, google.secret);
    var baseClient = new http.Client();

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaCodeExchange(baseClient, id, code,
            redirectUrl: google.redirectUrl);

    var client = auth.authenticatedClient(baseClient, credentials);
    var oauthApi = new oauth.Oauth2Api(client);
    var userInfo = await oauthApi.userinfo.get();

    client.close();
    baseClient.close();

    var user = new UserSchema()
      ..email = userInfo.email
      ..nombre = userInfo.name
      ..apellido = userInfo.familyName
      ..userId = new Uuid().v1();

    Row resp = await innerConn.query("""
      SELECT EXISTS(SELECT 1 FROM users WHERE "email" = '${user.email}');
    """).first;

    if (!resp.exists) {
      await insert(user);
      await addRole(user.userId, 2);
    } else {
      user = await findOne(condition: """
        "email" = @email
      """, values: user);
    }

    return redirect('/home');
    return new shelf.Response.ok(encodeJson(user),
        headers: {
      "Set-Cookie": new ck.Cookie('userId', user.userId).toString()
    });
  }

  String authenticationUri(
      auth.ClientId clientId, List<String> scopes, String redirectUri,
      {String state}) {
    var queryValues = [
      'response_type=code',
      'client_id=${Uri.encodeQueryComponent(clientId.identifier)}',
      'redirect_uri=${Uri.encodeQueryComponent(redirectUri)}',
      'scope=${Uri.encodeQueryComponent(scopes.join(' '))}',
    ];
    if (state != null) {
      queryValues.add('state=${Uri.encodeQueryComponent(state)}');
    }
    return Uri.parse('https://accounts.google.com/o/oauth2/auth'
        '?${queryValues.join('&')}').toString();
  }
}
