library arista_server.models;

import 'package:redstone_mapper/mapper.dart';
//import 'config.dart';

part 'models/user.dart';
part 'models/file.dart';

abstract class Ref {
  String get href;
}