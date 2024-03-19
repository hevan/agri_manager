import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsCategory.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/cms/cms_category_edit_screen.dart';
import 'package:agri_manager/src/screens/product/category_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
class CmsCategoryScreen extends StatefulWidget {
  const CmsCategoryScreen({Key? key}) : super(key: key);

  @override
  State<CmsCategoryScreen> createState() => _CmsCategoryScreenState();
}

class _CmsCategoryScreenState extends State<CmsCategoryScreen> {


  List<CmsCategory> listCategory = [];

  Corp? curCorp;
  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  void initState(){
    super.initState();
    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });
  }

  Future loadData() async {
    var params = {'corpId': curCorp?.id};

    try {
      DioUtils().request(
          HttpApi.cms_category_findAll, "GET", queryParameters: params).then((res) {

            if(mounted) {
              setState(() {
                listCategory =
                    (res as List).map((e) => CmsCategory.fromJson(e)).toList();
              });
            }
      });

    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

  }

  Future deleteCategory(num id) async {
    try {
      var retData = await DioUtils().request(
          HttpApi.cms_category_delete  + id.toString(), "DELETE");

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
          title: const Text('资讯分类管理'),
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
                                MaterialPageRoute(builder: (context) => const CmsCategoryEditScreen()),
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
                              label: Text('代码'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('分类名称'),
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
                                    Text('${listCategory[index].code}')),
                                DataCell(
                                    Text('${listCategory[index].name}')),
                                DataCell(
                                    Row(children: [
                                      ElevatedButton(
                                        style:  elevateButtonStyle,
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  CmsCategoryEditScreen(editCategory: listCategory[index])),
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
  confirmDeleteDialog(BuildContext context, num id) {
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
