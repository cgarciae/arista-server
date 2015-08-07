library arista_server.models;

import 'package:redstone_mapper/mapper.dart';
import 'config.dart';

part 'models/users.dart';
part 'models/file_db.dart';

abstract class Ref {
  String get href;
}