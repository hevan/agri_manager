import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:znny_manager/src/utils/constants.dart';

class ProgressCardData {
  final int totalUndone;
  final int totalTaskInProress;

  const ProgressCardData({
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
        padding: const EdgeInsets.all(kSpacing/2),
        height: 100,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(111, 88, 255, 1),
              Color.fromRGBO(157, 86, 248, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Row( children: [
         Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "待完成任务 ${data.totalUndone}",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  "进行中任务 ${data.totalTaskInProress}",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: kSpacing),
                ElevatedButton(
                  onPressed: onPressedCheck,
                  child: const Text("Check"),
                )
              ],
            ),]),
          ),
    );
  }
}
