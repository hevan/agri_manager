import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/customer/Customer.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/customer/customer_info_card.dart';
import 'package:agri_manager/src/screens/customer/customer_view_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

import 'customer_edit_screen.dart';

class CustomerSelectScreen extends StatefulWidget {
  const CustomerSelectScreen({Key? key}) : super(key: key);

  @override
  State<CustomerSelectScreen> createState() => _CustomerSelectScreenState();
}

class _CustomerSelectScreenState extends State<CustomerSelectScreen> {
  List<Customer> listData = [];

  PageModel pageModel = PageModel();

  Customer selectCustomer = Customer();

  int? selectedIndex = 0;

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });


    loadData();
  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'name': '',
      'page': pageModel.page,
      'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.customer_query, "GET", queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData = (retData['content'] as List)
              .map((e) => Customer.fromJson(e))
              .toList();

          if (listData.length > 0) {
            selectCustomer = listData[0];
          }
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
          title: const Text('客户选择'),
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
                              label: Text('名称'),
                            ),
                            DataColumn2(
                              size: ColumnSize.S,
                              label: Text('代码'),
                            )
                          ],
                          rows: List<DataRow>.generate(
                              listData.length,
                              (index) => DataRow(
                                      selected: index == selectedIndex,
                                      onSelectChanged: (val) {
                                        setState(() {
                                          selectedIndex = index;

                                          String jsonStr = json.encode({
                                            'id': listData[index].id,
                                            'name': listData[index].name
                                          });
                                          Navigator.of(context).pop(jsonStr);
                                        });
                                      },
                                      cells: [
                                        DataCell(Text('${listData[index].id}')),
                                        DataCell(Text(
                                            '${listData[index].name}')),
                                        DataCell(
                                            Text('${listData[index].code}')),
                                      ]))),
                    ))
                  ]))));
        }));
  }

  Widget _buildQuery(BoxConstraints viewportConstraints) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                // A fixed-height child.
                height: 80.0,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: kSpacing, right: kSpacing),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: secondButtonStyle,
                      onPressed: () {
                        loadData();
                      },
                      child: const Text('查询'),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: listData.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (ResponsiveBuilder.isMobile(context)) {
                          return CustomerInfoCard(
                              data: listData[index],
                              onSelected: () => toSelect(listData[index]));
                        } else {
                          return CustomerInfoCard(
                              data: listData[index],
                              onSelected: () => toSelect(listData[index]));
                        }
                      })),
            ])));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerEditScreen()),
    );
  }

  toSelectView(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerViewScreen(data: customer)),
    );
  }

  toSelect(Customer customer) {
    setState(() {
      selectCustomer = customer;
    });
  }
}
