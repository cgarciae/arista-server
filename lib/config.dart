library arista_server.config;

import 'package:path/path.dart' as path;

const int tipoBuild = TipoBuild.desarrollo;

int get port => 9090;

final String boot2docker_ip = "192.168.59.103";
final String host_ip = "45.55.155.202";

final String staticFolder = "web";

String get partialHost {
  switch (tipoBuild)
  {
    case TipoBuild.desarrollo:
    case TipoBuild.jsTesting:
      return "localhost:9090";
    case TipoBuild.dockerTesting:
      return "$boot2docker_ip:9090";
    case TipoBuild.deploy:
      return host_ip;
  }
}



String get localHost => "http://${partialHost}/";

String get partialDBHost {
  switch (tipoBuild)
  {
    case TipoBuild.desarrollo:
    case TipoBuild.jsTesting:
      return "$boot2docker_ip:8095";
    case TipoBuild.dockerTesting:
    case TipoBuild.deploy:
      return "db";
  }
}

class TipoBuild
{
  static const int desarrollo =  0;
  static const int jsTesting =  1;
  static const int dockerTesting =  2;
  static const int deploy =  3;
}

String get filesPath {
  switch (tipoBuild)
  {
    case TipoBuild.desarrollo:
    case TipoBuild.jsTesting:
      return '${path.current}/files';
    case TipoBuild.dockerTesting:
    case TipoBuild.deploy:
      return "/data/files";
  }
}
