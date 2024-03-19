import 'package:flutter/material.dart';
import 'package:agri_manager/src/shared_components/chart_percent_indicator.dart';
import 'package:agri_manager/src/utils/constants.dart';

class ProjectTotalData {
  final double percent;
  final int totalDone;
  final int totalInProgress;
  final int totalUndone;

  const ProjectTotalData({
    required this.percent,
    required this.totalDone,
    required this.totalInProgress,
    required this.totalUndone,
  });
}

class ProjectTotalCard extends StatelessWidget {
  const ProjectTotalCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final ProjectTotalData data;
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
              Color.fromRGBO(255, 110, 49, 1),
              Color.fromRGBO(255, 110, 49, 1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
         Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '项目统计',
                  style:  TextStyle(color: Colors.white),
                ),
                const SizedBox(height: kSpacing,),
                Text(
                  '待进行 ${data.totalUndone}',
                  style: const TextStyle(color: Colors.white, fontSize: miniTextStyleSize),
                ),
                Text(
                  "进行中 ${data.totalInProgress}",
                  style: const TextStyle(color: Colors.white, fontSize: miniTextStyleSize),
                ),
                Text(
                  "已完成 ${data.totalDone}",
                  style: const TextStyle(color: Colors.white, fontSize: miniTextStyleSize),
                ),
              ],
            ),
          const Spacer(),
          ChartPercentIndicator(percent: data.percent),
        ]),
          ),
    );
  }
}
