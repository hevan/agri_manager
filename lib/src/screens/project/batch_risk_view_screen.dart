import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/project/BatchRisk.dart';
import 'package:agri_manager/src/screens/project/batch_risk_edit_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../net/dio_utils.dart';
import '../../net/exception/custom_http_exception.dart';
import '../../net/http_api.dart';

class BatchRiskViewScreen extends StatefulWidget {
  final BatchRisk data;

  const BatchRiskViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<BatchRiskViewScreen> createState() => _BatchRiskViewScreenState();
}

class _BatchRiskViewScreenState extends State<BatchRiskViewScreen> {
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
          builder: (context) => BatchRiskEditScreen(id: widget.data.id, batchId: widget.data!.batchId!, productId: widget.data!.productId!,)),
    );
  }

  Future deleteCategory(int id) async {
    try {
      await DioUtils().request('${HttpApi.batch_risk_delete}${id}', "DELETE");
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
         title: const Text('风险查看'),
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
          ShowFieldText(title: '名称', data: widget.data.name ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '分类', data: widget.data.riskCategory ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
              title: '阶段', data: widget.data.cycleName ?? ''),
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
          ShowFieldText(title: '发生日期', data: widget.data.occurDate ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '解决方案', data: widget.data.solution ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '预计费用', data: '${widget.data.feeAmount ?? ''}'),
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
                  confirmDeleteDialog(context, widget.data.id!);
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
