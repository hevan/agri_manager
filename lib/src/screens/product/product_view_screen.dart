import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:znny_manager/src/screens/product/product_edit_screen.dart';
import 'package:znny_manager/src/shared_components/show_field_text.dart';
import 'package:znny_manager/src/utils/constants.dart';

import '../../model/product/Product.dart';
import '../../net/dio_utils.dart';
import '../../net/exception/custom_http_exception.dart';
import '../../net/http_api.dart';

class ProductViewScreen extends StatefulWidget {
  final Product data;

  const ProductViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
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
          builder: (context) => ProductEditScreen(id: widget.data.id)),
    );
  }

  Future deleteCategory(int id) async {
    try {
      await DioUtils().request('${HttpApi.product_delete}${id}', "DELETE");
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
        body: FittedBox(
      fit: BoxFit.fill,
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
          ShowFieldText(title: '机构代码', data: widget.data.code ?? ''),
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
          ShowFieldText(
              title: '分类', data: '${widget.data.category!.name ?? ''}'),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '统计单位', data: '${widget.data.calcUnit ?? ''}'),
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
      ),
    ));
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
