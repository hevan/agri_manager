
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'src/app.dart';
import 'package:sp_util/sp_util.dart';
import 'package:flutter_web_plugins/url_strategy.dart';


void main() async {
   //WidgetsFlutterBinding.ensureInitialized();
  /// STEP 1. Create catcher configuration.

  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await SpUtil.getInstance();
  usePathUrlStrategy();
  runApp(const MyApp());
}
