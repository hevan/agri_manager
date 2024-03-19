import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/project/BatchBase.dart';
import 'package:agri_manager/src/screens/project/batch_base_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_risk_edit_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../net/dio_utils.dart';
import '../../net/exception/custom_http_exception.dart';
import '../../net/http_api.dart';

class BatchBaseViewScreen extends StatefulWidget {
  final BatchBase data;
  final int parkId;

  const BatchBaseViewScreen({
    Key? key,
    required this.data,
    required this.parkId
  }) : super(key: key);

  @override
  State<BatchBaseViewScreen> createState() => _BatchBaseViewScreenState();
}

class _BatchBaseViewScreenState extends State<BatchBaseViewScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /*
  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};
    try {
      var retData =
          await DioUtils().request('${HttpApi.corp_find}${widget.id}', "GET");
      if (retData != null) {
        setState(() {
          _corp = Corp.fromJson(retData);
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }
   */

  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchBaseEditScreen(id: widget.data.id!.toInt(), batchId: widget.data!.batchId!.toInt(), parkId: widget.data!.batchProductDto!.productId!.toInt(),)),
    );
  }

  Future deleteCategory(int id) async {
    try {
      await DioUtils().request('${HttpApi.batch_base_delete}${id}', "DELETE");
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  AppBar(
         title: const Text('种植地块查看'),
       ),
        body: Center(
       child:Container(
           constraints: const BoxConstraints(
             maxWidth: 500,
           ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '名称', data: widget.data.parkBaseDto!.parkBaseName ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
              title: '产品', data: widget.data.batchProductDto!.productName ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '面积', data: '${widget.data.area}'),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '数量', data: '${widget.data.quantity}'),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
            title: '描述',
            data: widget.data.description ?? '',
            dataLine: 4,
          ),
          const SizedBox(
            height: kSpacing,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  toEdit();
                },
                child: const Text('编辑'),
              ),
              SizedBox(
                width: kSpacing,
              ),
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  confirmDeleteDialog(context, widget.data!.id!.toInt());
                },
                child: const Text('删除'),
              )
            ],
          ),
        ],
      ))),
    );
  }

  confirmDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("确定删除"),
          content: const Text("确定要删除该记录吗?，若存在关联数据将无法删除"),
          actions: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () async {
                await deleteCategory(id);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
