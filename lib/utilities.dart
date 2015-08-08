library arista_server.utilities;

//redstone
import 'package:redstone/src/dynamic_map.dart';
//mapper
import 'package:redstone_mapper/mapper.dart';

//postgres
import 'package:redstone_mapper_pg/service.dart';
import 'package:redstone_mapper_pg/manager.dart' show PostgreSql;

//dart
import 'dart:async';

part 'utilities/postgres_generic_controller.dart';

cast (obj, Type type) => decode(encode(obj), type);

class Role {
  static const String superAdmin = "superAdmin";
  static const String admin = "admin";
  static const String user = "user";
}