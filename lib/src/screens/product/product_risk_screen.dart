
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/product/ProductRisk.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/product/product_risk_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class ProductRiskScreen extends StatefulWidget {
  final int productId;
  final String productName;

  const ProductRiskScreen({Key? key, required this.productId, required this.productName}) : super(key: key);

  @override
  State<ProductRiskScreen> createState() => _ProductRiskScreenState();
}

class _ProductRiskScreenState extends State<ProductRiskScreen>{

  List<ProductRisk> listData = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future loadData() async{
    var params = {'productId': widget.productId, };

    try {
      var retData = await DioUtils().request(
          HttpApi.product_risk_findAll, "GET", queryParameters: params);
      if(retData != null) {
        setState(() {
          listData = (retData as List).map((e) => ProductRisk.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
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
                              onPressed:toAdd,
                              child: const Text('增加'),
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
                                    label: Text('产品名称'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('生长阶段'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('风险分类'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.S,
                                    label: Text('名称'),
                                  ),
                                  DataColumn2(
                                    size: ColumnSize.L,
                                    label: Text('操作'),
                                  ),
                                ],
                                rows: List<DataRow>.generate(
                                    listData.length,
                                        (index) => DataRow(cells: [
                                      DataCell(Text('${listData[index].id}')),

                                      DataCell(
                                          Text('${listData[index].productName}')),
                                      DataCell(
                                          Text('${listData[index].cycleName}')),
                                          DataCell(
                                              Text('${listData[index].riskCategory}')),
                                          DataCell(
                                              Text('${listData[index].name}')),
                                      DataCell(
                                          Row(children: [
                                            ElevatedButton(
                                              style:  elevateButtonStyle,
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>  ProductRiskEditScreen(id: listData[index].id, productId: widget.productId, productName: widget.productName,)),
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
                                                  MaterialPageRoute(builder: (context) =>  ProductRiskEditScreen(id: listData[index].id, productId: widget.productId,productName: widget.productName,)),
                                                );
                                              },
                                              child: const Text('查看'),
                                            ),
                                          ],))
                                    ]))),
                          ))
                    ]))));
      })
    );
  }

  toAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ProductRiskEditScreen(productId: widget.productId, productName: widget.productName,)),
    );
  }
}