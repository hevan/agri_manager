import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/product/Category.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/product/category_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  bool _initialized = false;

  List<Category> listCategory = [];

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      DioUtils().request(
          HttpApi.product_category_findAll, "GET", queryParameters: params).then((res) {

            if(mounted) {
              setState(() {
                listCategory =
                    (res as List).map((e) => Category.fromJson(e)).toList();
              });
            }
      });

    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

  }

  Future deleteCategory(int id) async {
    try {
      var retData = await DioUtils().request(
          HttpApi.product_category_delete + '/' + id.toString(), "DELETE");

        loadData();
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('产品分类管理'),
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
                          Container(width:20.0),
                          ElevatedButton(
                            style:  elevateButtonStyle,
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CategoryEditScreen()),
                              );
                            },
                            child: const Text('增加分类'),
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
                          height: 1000,
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
                              label: Text('分类名称'),
                            ),
                            DataColumn2(
                              label: Text('分类路径'),
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: Text('操作'),
                            ),

                          ],
                          rows: List<DataRow>.generate(
                              listCategory.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text('${listCategory[index].id}')),
                                    DataCell(
                                        Text('${listCategory[index].name}')),
                                    DataCell(
                                        Text('${listCategory[index].pathName}')),
                                DataCell(
                                    Row(children: [
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  CategoryEditScreen(editCategory: listCategory[index])),
                                          );
                                        },
                                        child: const Text('编辑'),
                                      ),
                                      Container(width: 20.0,),
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          confirmDeleteDialog(context, listCategory[index].id!);
                                        },
                                        child: const Text('删除'),
                                      ),
                                    ],))
                                  ]))),
                    ))
                  ]))));
        }));
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
              style:  elevateButtonStyle,
              onPressed: (){
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              style:  elevateButtonStyle,
              onPressed: () async{
                 await deleteCategory(id);
                 Navigator.of(context).pop();
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
