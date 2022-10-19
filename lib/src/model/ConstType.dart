

// this file focused on enum data

import 'package:flutter/material.dart';

enum TaskType {
  todo,
  inProgress,
  done,
}

class ConstType {
  static final List<Map<String, dynamic>> taskStatus = [
    {'id': 0, 'name': '待启动'},
    {'id': 1, 'name': '进行中'},
    {'id': 2, 'name': '已完成'},
    {'id': -1, 'name': '已终止'}
  ];

  static String getTaskStatus(int? status){
    if(status == null){
      return "未确定";
    }
    String str = '';
    for(int i=0;i<taskStatus.length;i++){
      if(taskStatus[i]['id'] == status){
        str= taskStatus[i]['name'];
        break;
      }
    }

    return str;
  }

  static Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
/*
{
"id":1,
"batchId":1,
'batchName":"",
"managerId":1,
"managerName":"",
"createdAt":"",
"isManager":true,
}
 */