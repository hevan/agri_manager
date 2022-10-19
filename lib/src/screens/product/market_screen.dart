import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/product/Market.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'market_edit_screen.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  List<Market> listData = [];

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {
    var params = {
      'corpId': HttpApi.corpId,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.market_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData =
              (retData as List).map((e) => Market.fromJson(e)).toList();
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
          title: const Text('全国市场'),
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(children: <Widget>[
            Container(
              // A fixed-height child.
              height: 100.0,
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
                    onPressed: toAdd,
                    child: const Text('增加'),
                  )
                ],
              ),
            ),
            const Divider(
              height: 1,
            ),
            Expanded(child:
            DataTable2(
                columnSpacing: 10,
                horizontalMargin: 12,
                minWidth: 1200,
                columns: const [
                  DataColumn2(
                    size: ColumnSize.S,
                    label: Text('id'),
                  ),
                  DataColumn2(
                    label: Text('市场名称'),
                  ),
                  DataColumn2(
                    label: Text('区域'),
                  ),
                  DataColumn2(
                    label: Text('省份'),
                  ),
                  DataColumn2(
                    label: Text('城市'),
                  ),
                  DataColumn2(
                    label: Text('地址'),
                  ),
                  DataColumn2(
                    size:ColumnSize.L,
                    label: Text('操作'),
                  ),
                ],
                rows: List<DataRow>.generate(
                    listData.length,
                    (index) => DataRow(cells: [
                          DataCell(Text('${listData[index].id}')),
                          DataCell(Text('${listData[index].name}')),
                          DataCell(Text('${listData[index].area}')),
                          DataCell(Text('${listData[index].province}')),
                          DataCell(Text('${listData[index].city}')),
                          DataCell(Text('${listData[index].address}')),
                          DataCell(
                            Container(
                              width: 600,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MarketEditScreen(
                                                    id: listData[index].id)),
                                      );
                                    },
                                    child: const Text('编辑'),
                                  ),
                                  ElevatedButton(

                                    onPressed: () {},
                                    child: const Text('删除'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MarketEditScreen(
                                                    id: listData[index].id)),
                                      );
                                    },
                                    child: const Text('查看'),
                                  ),
                                ],
                              ),
                            )

                          )
                        ])))),
          ]);
        }));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarketEditScreen()),
    );
  }
}
