import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/manage/CorpManagerInfo.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';


class ManagerSelectScreen extends StatefulWidget {
  const ManagerSelectScreen({Key? key}) : super(key: key);

  @override
  State<ManagerSelectScreen> createState() => _ManagerSelectScreenState();
}

class _ManagerSelectScreenState extends State<ManagerSelectScreen> {
  int selectedIndex = -1;

  List<CorpManagerInfo> listManager = [];

  PageModel pageModel = PageModel();

  Corp?   currentCorp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      if (null != currentCorp) {
        loadData();
      }
    });
  }

  Future loadData() async {
    var params = {'corpId': currentCorp!.id!};

    try {
      var retData = await DioUtils().request(
          HttpApi.corp_manager_info_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listManager = (retData as List).map((e) => CorpManagerInfo.fromJson(e)).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('选择人员'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('选择')),
          ],
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
                              label: Text('姓名'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('职位'),
                            ),
                            DataColumn2(
                              label: Text('手机号码'),
                            )
                          ],
                          rows: List<DataRow>.generate(
                              listManager.length,
                              (index) => DataRow(
                                      selected: index == selectedIndex,
                                      onSelectChanged: (val) {
                                        setState(() {
                                          selectedIndex = index;

                                          String jsonStr = json.encode(listManager[index].toJson());
                                          Navigator.of(context).pop(jsonStr);
                                        });
                                      },
                                      cells: [
                                        DataCell(
                                            Text('${listManager[index].id}')),
                                        DataCell(Text(
                                            '${listManager[index].nickName}')),
                                        DataCell(
                                            Text('${listManager[index].position}')),
                                        DataCell(
                                            Text('${listManager[index].mobile}'))
                                      ]))),
                    ))
                  ]))));
        }));
  }
}
