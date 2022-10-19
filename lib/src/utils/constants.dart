library constants;

import 'package:flutter/material.dart';

part 'assets_path.dart';
part 'type_status.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const creamColor = Color(0xFFFFFFFF);
const snowColor = Color(0xFFFFFAFA);
const Color compexDrawerCanvasColor = Color(0xffe3e9f7);
const Color complexDrawerBlack = Color(0xff11111d);
const Color complexDrawerBlueGrey = Color(0xff1d1b31);

const defaultPadding = 16.0;
final ButtonStyle elevateButtonStyle = ElevatedButton.styleFrom(
  minimumSize: Size(100, 42),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

const kBorderRadius = 20.0;
const kSpacing = 20.0;

const kFontColorPallets = [
  Color.fromRGBO(255, 255, 255, 1),
  Color.fromRGBO(210, 210, 210, 1),
  Color.fromRGBO(170, 170, 170, 1),
];

const kNotifColor = Color.fromRGBO(74, 177, 120, 1);

class Constant {
  static const String accessToken = 'accessToken';
  static const String userId = 'current_user_id';
  static const String USER_INFO = 'agro_user_info';
}