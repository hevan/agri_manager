
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/utils/constants.dart';



class CorpShowCard extends StatelessWidget {
  const CorpShowCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final Corp data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(kSpacing),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(kBorderRadius),
    ),
    child:Padding(
    padding: EdgeInsets.all(kSpacing),
    child:Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data.name!,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18),),
              const SizedBox(height: 5),
              Row(
                children: [
                  Expanded(child: Column(children: [
                    Text('${data.countProject}',  style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
                    Text('进行的项目', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],), flex: 1,),
                  Expanded(child: Column(children: [
                    Text('${data.countTask}',  style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
                    Text('进行的任务', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],), flex: 1,),
                  Expanded(child: Column(children: [
                    Text('${data.countApply}',  style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
                    Text('处理中单据', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],), flex: 1,),
                  Expanded(child: Column(children: [
                    Text('${data.countCheck}',  style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
                    Text('待审核', overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],), flex: 1,),
                ],
              )
            ],
          ),
          flex:4,
        ),
        Expanded(child: Container(
            alignment: Alignment.center,
            child:IconButton(
          onPressed: onPressedCheck,
          icon: const Icon(EvaIcons.arrowIosForward),
          tooltip: "more",
        )), flex: 1,)
      ],
    )));
  }
}

