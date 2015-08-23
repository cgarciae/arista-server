library arista_server.tests;

import 'package:test/test.dart';
import 'package:postgresql/postgresql.dart';
import 'package:redstone_mapper_pg/manager.dart';
import 'package:di/di.dart';
import 'package:redstone_configuration_plugin/redstone_configuration_plugin.dart';
import 'package:mockito/mockito.dart';
import 'dart:async';

import 'package:arista-server/controllers.dart';
import 'package:arista-server/models.dart';
import 'package:arista-server/config.dart';
import 'package:redstone_mapper/mapper_factory.dart';

import 'mocks.dart';
import 'implementations.dart';

part 'tests/user_services_tests.dart';

main () {
  bootstrapMapper();

  userServicesTests();
}