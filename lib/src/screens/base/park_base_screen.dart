import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/base/ParkBase.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/screens/base/park_base_edit_screen.dart';
import 'package:agri_manager/src/screens/base/park_base_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class ParkBaseScreen extends StatefulWidget {
  final int parkId;
  final String parkName;

  const ParkBaseScreen({Key? key, required this.parkId, required this.parkName})
      : super(key: key);

  @override
  State<ParkBaseScreen> createState() => _ParkBaseScreenState();
}

class _ParkBaseScreenState extends State<ParkBaseScreen> {
  List<ParkBase> listParkBase = [];

  PageModel pageModel = PageModel();

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {'parkId': widget.parkId};
    try {
      var retData = await DioUtils()
          .request(HttpApi.park_base_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listParkBase =
              (retData as List).map((e) => ParkBase.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  toSelectView(ParkBase parkBase) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParkBaseViewScreen(data: parkBase)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
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
                                builder: (context) => ParkBaseEditScreen(
                                      parkId: widget.parkId,
                                      parkName: widget.parkName,
                                    )),
                          );
                        },
                        child: const Text('增加'),
                      )
                    ],
                  ),
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
                          listParkBase.length,
                          (index) => DataRow(cells: [
                                DataCell(Text('${listParkBase[index].id}')),
                                DataCell(Text('${listParkBase[index].name}')),
                                DataCell(Text('${listParkBase[index].area}')),
                                DataCell(
                                    Text('${listParkBase[index].areaUse}')),
                                DataCell(Row(
                                  children: [
                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ParkBaseEditScreen(
                                                    id: listParkBase[index].id,
                                                    parkId: widget.parkId,
                                                    parkName: widget.parkName,
                                                  )),
                                        );
                                      },
                                      child: const Text('编辑'),
                                    ),
                                    Container(
                                      width: 10.0,
                                    ),
                                    ElevatedButton(
                                      style: elevateButtonStyle,
                                      onPressed:() {
                                          toSelectView(listParkBase[index]);
                                      },
                                      child: const Text('查看'),
                                    ),
                                  ],
                                ))
                              ]))),
                ))
              ]))));
    }));
  }
}
