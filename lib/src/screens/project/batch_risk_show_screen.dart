import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchRisk.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/project/batch_risk_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_risk_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchRiskShowScreen extends StatefulWidget {
  final int batchId;
  final String batchName;
  final int productId;
  final String productName;

  const BatchRiskShowScreen(
      {Key? key,
      required this.batchId,
      required this.batchName,
      required this.productId,
      required this.productName})
      : super(key: key);

  @override
  State<BatchRiskShowScreen> createState() => _BatchRiskShowScreenState();
}

class _BatchRiskShowScreenState extends State<BatchRiskShowScreen> {
  List<BatchRisk> listData = [];

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
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.batch_risk_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listData =
              (retData as List).map((e) => BatchRisk.fromJson(e)).toList();
        });

        debugPrint(jsonEncode(retData));
        debugPrint(jsonEncode(listData));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

   buildItem(List<BatchRisk> listItem) {
     List<Widget> itemWdiget = [];
     for (int i = 0; i < listItem.length; i++) {
       BatchRisk curTemp = listItem[i];
       itemWdiget.add(Row(children: [
         Expanded(child:
         ListTile(
           title:  Text('${curTemp.name}'),
           subtitle:  Text('${curTemp.description}'),
           trailing: const Icon(Icons.arrow_forward_ios),
           onTap: (){
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) =>  BatchRiskViewScreen(data: curTemp,))
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
          builder: (context) => BatchRiskEditScreen(
                batchId: widget.batchId,
                batchName: widget.batchName,
                productId: widget.productId,
                productName: widget.productName,
              )),
    );
  }
}
