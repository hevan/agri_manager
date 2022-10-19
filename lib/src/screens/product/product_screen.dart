import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/page_model.dart';
import 'package:znny_manager/src/model/product/Product.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/product/product_edit_screen.dart';
import 'package:znny_manager/src/screens/product/product_view_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  bool _initialized = false;

  List<Product> listProduct = [];

  PageModel pageModel = PageModel();

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {'corpId': HttpApi.corpId, 'name': '', 'page': pageModel.page, 'size': pageModel.size};

    try {
      var retData = await DioUtils().request(
          HttpApi.product_query, "GET", queryParameters: params);
      if(retData != null && retData['content'].length > 0) {
        setState(() {
          listProduct =
              (retData['content'] as List).map((e) => Product.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('产品管理'),
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                      child: Column(children: <Widget>[
                    Container(
                      // A fixed-height child.
                      height: 80.0,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style:  elevateButtonStyle,
                            onPressed: (){
                              loadData();
                            },
                            child: const Text('查询'),
                          ),
                          Container(width: 20,),
                          ElevatedButton(
                            style:  elevateButtonStyle,
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ProductEditScreen()),
                              );
                            },
                            child: const Text('增加产品'),
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1,),
                    Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                        child: Container(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                          height: 300,
                      child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          smRatio: 0.75,
                          lmRatio: 1.5,
                          columns: const [
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('id'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('分类'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('产品编号'),
                            ),
                            DataColumn2(
                              label: Text('产品名称'),
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: Text('操作'),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              listProduct.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text('${listProduct[index].id}')),
                                    DataCell(
                                        Text('${listProduct[index].categoryName}')),
                                DataCell(
                                    Text('${listProduct[index].code}')),
                                    DataCell(
                                        Text('${listProduct[index].name}')),
                                   DataCell(
                                    Row(children: [
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  ProductEditScreen(id: listProduct[index].id)),
                                          );
                                        },
                                        child: const Text('编辑'),
                                      ),

                                      Container(width: 10.0,),
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){

                                        },
                                        child: const Text('删除'),
                                      ),
                                      Container(width: 10.0,),
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  ProductViewScreen(id: listProduct[index].id)),
                                          );
                                        },
                                        child: const Text('查看'),
                                      ),
                                    ],))
                                  ]))),
                    ))
                  ]))));
        }));
  }
}
