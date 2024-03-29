import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/market/MarkProduct.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class MarkProductSelectScreen extends StatefulWidget {
  const MarkProductSelectScreen({Key? key}) : super(key: key);

  @override
  State<MarkProductSelectScreen> createState() => _MarkProductSelectScreenState();
}

class _MarkProductSelectScreenState extends State<MarkProductSelectScreen> {
  int selectedIndex = -1;

  List<MarkProduct> listProduct = [];

  PageModel pageModel = PageModel();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  Future loadData() async {
    var params = {
      'page': pageModel.page,
      'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.mark_product_query, "GET", queryParameters: params);
      if (retData != null && retData['content'].length > 0) {
        setState(() {
          listProduct = (retData['content'] as List)
              .map((e) => MarkProduct.fromJson(e))
              .toList();
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
          title: const Text('产品选择'),
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
                              label: Text('分类'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('产品编号'),
                            ),
                            DataColumn2(
                              label: Text('产品名称'),
                            )
                          ],
                          rows: List<DataRow>.generate(
                              listProduct.length,
                              (index) => DataRow(
                                      selected: index == selectedIndex,
                                      onSelectChanged: (val) {
                                        setState(() {
                                          selectedIndex = index;

                                          String jsonStr = json.encode({
                                            'id': listProduct[index].id,
                                            'name': listProduct[index].name
                                          });
                                          Navigator.of(context).pop(jsonStr);
                                        });
                                      },
                                      cells: [
                                        DataCell(
                                            Text('${listProduct[index].id}')),
                                        DataCell(Text(
                                            '${listProduct[index].markCategory?.name}')),
                                        DataCell(
                                            Text('${listProduct[index].code}')),
                                        DataCell(
                                            Text('${listProduct[index].name}'))
                                      ]))),
                    ))
                  ]))));
        }));
  }
}
