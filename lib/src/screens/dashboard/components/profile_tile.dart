import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/utils/constants.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile(
      {required this.data, required this.onPressedNotification, Key? key})
      : super(key: key);

  final UserInfo data;
  final Function() onPressedNotification;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: data.headerUrl != null ? CircleAvatar(backgroundImage:  NetworkImage(data.headerUrl!)): CircleAvatar(backgroundImage:Image.asset(ImageRasterPath.avatar1).image),
      title: Text(
        '${data.nickName}',
        style: TextStyle(fontSize: 14, color: kFontColorPallets[0]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${data.mobile}',
        style: TextStyle(fontSize: 12, color: kFontColorPallets[2]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onPressedNotification,
        icon: const Icon(EvaIcons.bellOutline),
        tooltip: "notification",
      ),
    );
  }
}
