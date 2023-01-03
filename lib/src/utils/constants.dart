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

const defaultPadding = 10.0;
const  markTextStyleSize = 14.0;
const  miniTextStyleSize = 12.0;
final ButtonStyle elevateButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(kSpacing),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(kSpacing),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle secondButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(45, 205, 223, 0.9),
  padding: const EdgeInsets.all(kSpacing),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle waringButtonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.all(kSpacing),
  backgroundColor: const Color.fromRGBO(176, 139, 187, 0.9),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

final ButtonStyle alertButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: const Color.fromRGBO(236, 168, 105, 0.9),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
  ),
);

const kBorderRadius = 5.0;
const kSpacing = 10.0;

const kFontColorPallets = [
  Color.fromRGBO(255, 255, 255, 1),
  Color.fromRGBO(210, 210, 210, 1),
  Color.fromRGBO(170, 170, 170, 1),
];

const kNotifColor = Color.fromRGBO(74, 177, 120, 1);

class Constant {
  static const String accessToken = 'accessToken';
  static const String userId = 'current_user_id';
}