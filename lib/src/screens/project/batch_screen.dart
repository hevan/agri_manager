
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/ConstType.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/project/BatchFinanceAnalysis.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/project/batch_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchProductScreen extends StatefulWidget {
  const BatchProductScreen({Key? key}) : super(key: key);

  @override
  State<BatchProductScreen> createState() => _BatchProductScreenState();
}

class _BatchProductScreenState extends State<BatchProductScreen> {

  List<BatchProduct> listProductBatch = [];


  PageModel pageModel = PageModel();
  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }
  @override
  void initState() {
    super.initState();

      setState(() {
        curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
        userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      });


  }
  Future loadData() async {
    var params = {'corpId': curCorp?.id, 'page': pageModel.page, 'size': pageModel.size};

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_query, "GET", queryParameters: params);
      if(retData != null && retData['content'].length > 0) {
        setState(() {
          listProductBatch =
              (retData['content'] as List).map((e) => BatchProduct.fromJson(e)).toList();
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
          title: const Text('项目管理'),
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
                                MaterialPageRoute(builder: (context) => const BatchEditScreen()),
                              );
                            },
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
                              size: ColumnSize.S,
                              label: Text('编号'),
                            ),
                            DataColumn2(
                              label: Text('名称'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('产品名'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('种植面积'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('开始日期'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('结束日期'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('状态'),
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: Text('操作'),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              listProductBatch.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text('${listProductBatch[index].id}')),
                                DataCell(
                                    Text('${listProductBatch[index].code}')),
                                    DataCell(
                                        Text('${listProductBatch[index].name}')),
                                DataCell(
                                    Text('${listProductBatch[index].product?.name}')),
                                DataCell(
                                    Text('${listProductBatch[index].area}')),
                                DataCell(
                                    Text('${listProductBatch[index].startAt}')),
                                DataCell(
                                    Text('${listProductBatch[index].endAt}')),

                                DataCell(
                                    Text(ConstType.getTaskStatus(listProductBatch[index].status))),
                                   DataCell(
                                    Row(children: [
                                      Expanded(flex:2, child:
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  BatchEditScreen(id: listProductBatch[index].id)),
                                          );
                                        },
                                        child: const Text('编辑'),
                                      )),
                                      Expanded(flex:2, child:
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){

                                        },
                                        child: const Text('删除'),
                                      )),
                                      Expanded(flex:2, child:
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  BatchViewScreen(id: listProductBatch[index].id)),
                                          );
                                        },
                                        child: const Text('查看'),
                                      )),
                                    ],))
                                  ]))),
                    ))
                  ]))));
        }));
  }
}
