import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/customer/CustomerTrace.dart';
import 'package:znny_manager/src/model/page_model.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/customer/customer_link_edit_screen.dart';
import 'package:znny_manager/src/screens/customer/customer_trace_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CustomerTraceScreen extends StatefulWidget {
  final int customerId;
  final String customerName;
  const CustomerTraceScreen({Key? key, required this.customerId, required this.customerName}) : super(key: key);

  @override
  State<CustomerTraceScreen> createState() => _CustomerTraceScreenState();
}

class _CustomerTraceScreenState extends State<CustomerTraceScreen> {
  List<CustomerTrace> listData = [];

  PageModel pageModel = PageModel();

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
      'customerId': widget.customerId,
      'managerId': 1,
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.customer_trace_query, "GET",
          queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData =
              (retData['content'] as List).map((e) => CustomerTrace.fromJson(e)).toList();
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
                    label: Text('日期'),
                  ),
                  DataColumn2(
                    label: Text('主题'),
                  ),
                  DataColumn2(
                    label: Text('描述'),
                  ),
                  DataColumn2(
                    size:ColumnSize.L,
                    label: Text('操作'),
                  )
                ],
                rows: List<DataRow>.generate(
                    listData.length,
                    (index) => DataRow(cells: [
                          DataCell(Text('${listData[index].id}')),
                          DataCell(Text('${listData[index].occurAt}')),
                          DataCell(Text('${listData[index].title}')),
                          DataCell(Text('${listData[index].description}')),
                          DataCell(
                            Container(
                              width: 400,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerTraceEditScreen(
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
                                                CustomerTraceEditScreen(
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
      MaterialPageRoute(builder: (context) =>  CustomerTraceEditScreen(customerId: widget.customerId,customerName: widget.customerName,)),
    );
  }
}
