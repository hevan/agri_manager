import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/market/MarkProductMarket.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/market/mark_product_market_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class MarkProductMarketScreen extends StatefulWidget {
  final bool isShowBar;
  const MarkProductMarketScreen({Key? key, this.isShowBar = false}) : super(key: key);

  @override
  State<MarkProductMarketScreen> createState() => _MarkProductMarketScreenState();
}

class _MarkProductMarketScreenState extends State<MarkProductMarketScreen> {
  List<MarkProductMarket> listData = [];

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
      'page': 0,
      'size': 100,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.mark_product_market_query, "GET",
          queryParameters: params);
      if (retData != null && retData['content'] != null) {
        print(retData);
        setState(() {
          listData =
              (retData['content'] as List).map((e) => MarkProductMarket.fromJson(e)).toList();
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
        appBar: widget.isShowBar ? AppBar(
          title: const Text('市场行情'),
        ): null,
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(children: <Widget>[
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
                    label: Text('市场'),
                  ),
                  DataColumn2(
                    label: Text('产品名称'),
                  ),
                  DataColumn2(
                    label: Text('日期'),
                  ),
                  DataColumn2(
                    label: Text('单位'),
                  ),
                  DataColumn2(
                    label: Text('批发价'),
                  ),
                  DataColumn2(
                    label: Text('零售价'),
                  ),
                ],
                rows: List<DataRow>.generate(
                    listData.length,
                    (index) => DataRow(cells: [
                          DataCell(Text('${listData[index].id}')),
                          DataCell(Text('${listData[index].market?.name}')),
                          DataCell(Text('${listData[index].product?.name}')),
                          DataCell(Text('${listData[index].occurAt}')),
                          DataCell(Text('${listData[index].quantity}${listData[index].calcUnit}')),
                          DataCell(Text('${listData[index].priceWholesale}')),
                          DataCell(Text('${listData[index].priceRetal}')),

                        ])))),
          ]);
        }));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarkProductMarketEditScreen()),
    );
  }
}
