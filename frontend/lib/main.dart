import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/config/app_environment.dart';
import 'core/storage/local_storage_service.dart';
import 'features/app/math_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await LocalStorageService.initialize();

  runApp(MathApp(environment: AppEnvironment.fromDartDefine()));
}
