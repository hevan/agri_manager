

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ChartPercentIndicator extends StatelessWidget {
  const ChartPercentIndicator({required this.percent, Key? key}) : super(key: key);

  final double percent;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 40,
      lineWidth: 5,
      percent: percent,
      circularStrokeCap: CircularStrokeCap.round,
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (percent * 100).toString() + " %",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
          ),
          const Text(
            "完成",
            style: TextStyle(color: Colors.white54, fontWeight: FontWeight.w300, fontSize: 12),
          ),
        ],
      ),
      progressColor: Colors.white,
      backgroundColor: Colors.white.withOpacity(.3),
    );
  }
}
