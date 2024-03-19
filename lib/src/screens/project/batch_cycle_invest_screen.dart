import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchCycleInvest.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_invest_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleInvestScreen extends StatefulWidget {
  final int batchId;

  const BatchCycleInvestScreen(
      {Key? key, required this.batchId})
      : super(key: key);

  @override
  State<BatchCycleInvestScreen> createState() => _BatchCycleInvestScreenState();
}

class _BatchCycleInvestScreenState extends State<BatchCycleInvestScreen> {
  List<BatchCycleInvest> listData = [];

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
      'page': 0,
      'size': 60
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_invest_query, "GET",
          queryParameters: params);
      if (retData != null) {
        setState(() {
        listData =
            (retData['content'] as List).map((e) => BatchCycleInvest.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  buildItem(List<BatchCycleInvest> listItem) {
    List<Widget> itemWdiget = [];
    for (int i = 0; i < listItem.length; i++) {
      BatchCycleInvest curTemp = listItem[i];
      itemWdiget.add(
          ListTile(
            leading: Text('${curTemp.batchCycle?.name}'),
            title: Text('${curTemp.product?.name} ${curTemp.productSku}'),
            subtitle: Text('数量：${curTemp.quantity}  金额： ${curTemp.amount}'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BatchCycleInvestEditScreen(
                            id: curTemp?.id,
                            batchId: widget.batchId
                        )),
              );
            },
          )
      );
    }

    return itemWdiget;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(height: kSpacing,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ElevatedButton(onPressed: toAdd, child: const Text('增加'))],
        ),
        const SizedBox(height: kSpacing,),
        Column( children:
        buildItem(listData)
        ),
      ],
    ));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchCycleInvestEditScreen(
                batchId: widget.batchId
              )),
    );
  }

}
