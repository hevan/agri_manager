

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/shared_components/search_field.dart';
import 'package:znny_manager/src/shared_components/today_text.dart';
import 'package:znny_manager/src/utils/constants.dart';

class _Header extends StatelessWidget {
  const _Header({Key? key,  required this.data}) : super(key: key);

  final UserInfo data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TodayText(),
        const SizedBox(width: kSpacing),
        Expanded(child: SearchField()),
      ],
    );
  }
}
