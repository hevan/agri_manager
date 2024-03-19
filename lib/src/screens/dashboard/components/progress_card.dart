import 'package:flutter/material.dart';
import 'package:agri_manager/src/utils/constants.dart';

class ProgressCardData {
  final String assetIcon;
  final String title;
  final int totalUndone;
  final int totalTaskInProress;

  const ProgressCardData({
    required this.assetIcon,
    required this.title,
    required this.totalUndone,
    required this.totalTaskInProress,
  });
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final ProgressCardData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(kSpacing),
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child:InkWell(child:Row( children: [
          Expanded(child: CircleAvatar(
            child: Image.asset(data.assetIcon, width: 32, height: 32,),
            radius: 45,
              backgroundColor: Colors.white70), flex:2),
         Expanded(child:
         Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.title}'
                ),
                SizedBox(
                  height: kSpacing,
                ),
                Text(
                  "待完成 ${data.totalUndone}"
                ),
              ],
            ), flex: 4,),]),onTap: onPressedCheck,
          )),
    );
  }
}
