import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchBase.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/project/batch_base_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

import 'batch_base_view_screen.dart';

class BatchBaseShowScreen extends StatefulWidget {
  final int batchId;
  final String batchName;
  final int parkId;
  final String? parkName;

  const BatchBaseShowScreen(
      {Key? key,
      required this.batchId,
      required this.batchName,
      required this.parkId,
         this.parkName})
      : super(key: key);

  @override
  State<BatchBaseShowScreen> createState() => _BatchBaseShowScreenState();
}

class _BatchBaseShowScreenState extends State<BatchBaseShowScreen> {
  List<BatchBase> listData = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    var params = {
      'batchId': widget.batchId,
      'page':0,
      'size': 100,
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.batch_base_query, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listData =
              (retData['content'] as List).map((e) => BatchBase.fromJson(e)).toList();
        });

        debugPrint(jsonEncode(retData));
        debugPrint(jsonEncode(listData));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

   buildItem(List<BatchBase> listItem) {
     List<Widget> itemWdiget = [];
     for (int i = 0; i < listItem.length; i++) {
       BatchBase curTemp = listItem[i];
       itemWdiget.add(Row(children: [
         Expanded(child:
         ListTile(
           title:  Text('${curTemp.parkBaseDto?.parkBaseName}'),
           subtitle:  Text('面积：${curTemp.area} 数量：${curTemp.quantity}'),
           trailing: const Icon(Icons.arrow_forward_ios),
           onTap: (){
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>  BatchBaseViewScreen(data: curTemp, parkId: widget.parkId,))
             );
           },
         )),

       ]));
     }

     return itemWdiget;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
       Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                loadData();
              },
              child: const Text('查询'),
            ),
            Container(
              width: 20,
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: toAdd,
              child: const Text('增加'),
            )
          ],
        ),
          Container(
            margin: const EdgeInsets.all(10),
          child:
          Column( children:
          buildItem(listData),
          )),
     ])));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchBaseEditScreen(
                batchId: widget.batchId,
                batchName: widget.batchName,
                parkId: widget.parkId,
              )),
    );
  }
}
