part of arista_server.controllers;

@Controller("/users")
class UsersController extends UserServices {
  UsersController(PostgreSql conn) : super(conn);

  @GetView('/login')
  login() => {};

  @Get('/redirect')
  redirect(@ConfigurationField() app.DynamicMap google) async {
    var id = new auth.ClientId(google.identifier, google.secrete);
    var url = authenticationUri(id, google.scopes, google.redirectUrl);
    return app.redirect(url);
  }

  @GetJson("/authenticate")
  authenticate(@app.QueryParam() String code,
      @ConfigurationField() app.DynamicMap google) async {
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

    return new User()..email = userInfo.email;
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
