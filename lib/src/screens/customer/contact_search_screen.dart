import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/contract/Contract.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/customer/customer_contact_edit_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_contract_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:sp_util/sp_util.dart';

class ContractSearchScreen extends StatefulWidget {
  const ContractSearchScreen({Key? key}) : super(key: key);

  @override
  State<ContractSearchScreen> createState() => _ContractSearchScreenState();
}

class _ContractSearchScreenState extends State<ContractSearchScreen> {
  List<Contract> listData = [];

  final _textName = TextEditingController();
  PageModel pageModel = PageModel();

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    _textName.dispose();
    super.dispose();
  }

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
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'name': _textName.text,
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.contract_query, "GET",
          queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData =
              (retData['content'] as List).map((e) => Contract.fromJson(e)).toList();
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
          title: const Text('合约管理'),
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(children: <Widget>[
            Center(
              child: Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: TextField(
                    controller: _textName,
                    decoration: const InputDecoration(
                      border:  OutlineInputBorder(),
                      labelText: '合同标题',
                      hintText: '输入合同标题',
                    ),
                  ),
              ),
            ),
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
                    label: Text('编号'),
                  ),
                  DataColumn2(
                    label: Text('签约日期'),
                  ),
                  DataColumn2(
                    label: Text('合同期'),
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
                          DataCell(Text('${listData[index].name}')),
                          DataCell(Text('${listData[index].code}')),
                          DataCell(Text('${listData[index].signAt}')),
                          DataCell(Text('${listData[index].startAt} 至 ${listData[index].endAt}')),
                          DataCell(
                            Container(
                              width: 500,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerContractViewScreen(data: listData[index])),
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

}
