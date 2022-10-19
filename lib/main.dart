
import 'package:flutter/material.dart';
import 'src/app.dart';
import 'package:sp_util/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// STEP 1. Create catcher configuration.
  await SpUtil.getInstance();

  runApp(const MyApp());
}
