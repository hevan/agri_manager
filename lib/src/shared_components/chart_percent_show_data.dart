

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:agri_manager/src/utils/constants.dart';

class ChartPercentShowData extends StatelessWidget {
  const ChartPercentShowData({ required this.title, required this.percent, required this.preData, required this.realData, Key? key}) : super(key: key);

  final double percent;
  final double preData;
  final double realData;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.deepPurpleAccent, //<-- SEE HERE
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
    padding: EdgeInsets.all(kSpacing),
    child: Row(
       children: [
         Expanded(child: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
           Text('预估：${preData}'),
           Text('实际：${realData}'),
         ],), flex: 1),
         Expanded(child: CircularPercentIndicator(
      radius: 60,
      lineWidth: 5,
      percent: percent,
      header: Text(title),
      center:Text(
            (percent * 100).round().toString() + " %",
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
      progressColor: Colors.blue,
    ), flex: 1)])));
  }
}
