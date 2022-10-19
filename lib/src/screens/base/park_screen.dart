import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/base/Park.dart';
import 'package:znny_manager/src/model/page_model.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/base/park_edit_screen.dart';
import 'package:znny_manager/src/screens/base/park_view_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class ParkScreen extends StatefulWidget {
  const ParkScreen({Key? key}) : super(key: key);

  @override
  State<ParkScreen> createState() => _ParkScreenState();
}

class _ParkScreenState extends State<ParkScreen> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  bool _initialized = false;

  List<Park> listPark = [];

  PageModel pageModel = PageModel();

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData = await DioUtils()
          .request(HttpApi.park_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listPark = (retData as List).map((e) => Park.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('基地管理'),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ParkEditScreen()),
                              );
                            },
                            child: const Text('增加'),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1,
                    ),
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
                              label: Text('名称'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('面积'),
                            ),
                            DataColumn2(
                              label: Text('实用面积'),
                            ),
                            DataColumn2(
                              size: ColumnSize.L,
                              label: Text('操作'),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                              listPark.length,
                              (index) => DataRow(cells: [
                                    DataCell(Text('${listPark[index].id}')),
                                    DataCell(Text('${listPark[index].name}')),
                                    DataCell(Text('${listPark[index].area}')),
                                    DataCell(
                                        Text('${listPark[index].areaUse}')),
                                    DataCell(
                                        Row(
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => ParkEditScreen(id: listPark[index].id)),
                                                );
                                              },
                                              child: Container(width: 160, child: Text('编辑')),
                                            ),
                                            flex: 2),
                                        Container(width: 10,),
                                        Expanded(
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {},
                                              child: Container(width: 160, child: Text('删除')),
                                            ),
                                            flex: 2),
                                        Container(width: 10,),
                                        Expanded(
                                            child: ElevatedButton(
                                              style: elevateButtonStyle,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ParkViewScreen(
                                                              id: listPark[
                                                                      index]
                                                                  .id)),
                                                );
                                              },
                                              child: Container(width: 160, child: Text('查看')),
                                            ),
                                            flex: 2),
                                      ],
                                    ))
                                  ]))),
                    ))
                  ]))));
        }));
  }
}
