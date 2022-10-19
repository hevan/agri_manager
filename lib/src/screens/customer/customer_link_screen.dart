import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:znny_manager/src/model/customer/CustomerLink.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/customer/customer_link_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CustomerLinkScreen extends StatefulWidget {
  final int customerId;
  const CustomerLinkScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<CustomerLinkScreen> createState() => _CustomerLinkScreenState();
}

class _CustomerLinkScreenState extends State<CustomerLinkScreen> {
  List<CustomerLink> listData = [];

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
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.customer_link_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData =
              (retData as List).map((e) => CustomerLink.fromJson(e)).toList();
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
                    label: Text('名称'),
                  ),
                  DataColumn2(
                    label: Text('电话'),
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
                          DataCell(Text('${listData[index].linkName}')),
                          DataCell(Text('${listData[index].linkMobile}')),
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
                                                CustomerLinkEditScreen(
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
                                                CustomerLinkEditScreen(
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
      MaterialPageRoute(builder: (context) =>  CustomerLinkEditScreen(customerId: widget.customerId,)),
    );
  }
}
