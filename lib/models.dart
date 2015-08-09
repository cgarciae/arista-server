library arista_server.models;

import 'package:redstone_mapper/mapper.dart';
import 'utilities.dart';

part 'models/user.dart';
part 'models/file.dart';
part 'models/evento.dart';
part 'models/vista.dart';
part 'models/objeto_unity.dart';
part 'models/local_target.dart';
part 'models/cloud_target.dart';
part 'models/vuforia_target_record.dart';

abstract class Ref {
  String get href;
}