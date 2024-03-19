import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/CheckManager.dart';
import 'package:agri_manager/src/model/project/BatchCycleInvest.dart';
import 'package:agri_manager/src/model/project/BatchTeam.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_select_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_invest_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchTeamScreen extends StatefulWidget {
  final int batchId;

  const BatchTeamScreen({Key? key, required this.batchId})
      : super(key: key);

  @override
  State<BatchTeamScreen> createState() => _BatchTeamScreenState();
}

class _BatchTeamScreenState extends State<BatchTeamScreen> {
  List<BatchTeam> listData = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    var params = {
      'batchId': widget.batchId
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_team_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        setState(() {
          listData =
              (retData as List).map((e) => BatchTeam.fromJson(e)).toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  buildItem(List<BatchCycleInvest> listItem) {
    List<Widget> itemWdiget = [];
    for (int i = 0; i < listItem.length; i++) {
      BatchCycleInvest curTemp = listItem[i];
      itemWdiget.add(
          ListTile(
            leading: Text('${curTemp.batchCycle?.name}'),
            title: Text('${curTemp.product?.name} ${curTemp.productSku}'),
            subtitle: Text('数量：${curTemp.quantity}  金额： ${curTemp.amount}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BatchCycleInvestEditScreen(
                            id: curTemp?.id,
                            batchId: widget.batchId
                        )),
              );
            },
          )
      );
    }

    return itemWdiget;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutBuilder(builder:
        (BuildContext context, BoxConstraints viewportConstraints)
    {
      return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: kSpacing,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: toAdd, child: const Text('增加'))
                    ],
                  ),
                  const SizedBox(height: kSpacing,),
                  Expanded(
                      child: ListView.separated(
                          itemCount: listData.length,
                          separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                            height: defaultPadding,
                            color: Colors.grey,
                          ),
                          itemBuilder: (context, index) {

                            BatchTeam curTemp = listData[index];

                             return   ListTile(
                                  leading: null != curTemp.user && null != curTemp.user!.headerUrl ?
                                  CircleAvatar(
                                      radius:50,
                                      backgroundImage: NetworkImage(
                                          '${HttpApi.host_image}${curTemp.user!.headerUrl!}')): const CircleAvatar(
                                    radius: 50,
                                    backgroundImage: AssetImage('images/product_upload.png'),
                                  ),
                                  title: Text('${curTemp.user?.nickName}'),
                                  subtitle: Text('手机号码：${curTemp.user?.mobile}'),
                                  onTap: () {

                                  },
                                );
                          })),
                ],
              )));
    }));
  }

  toAdd() async {
    String retData = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ManagerSelectScreen(),
            fullscreenDialog: true));
    if (retData != null) {
      // ignore: curly_braces_in_flow_control_structures

        var retDataMap = json.decode(retData);
        CheckManager curCheck = CheckManager.fromJson(retDataMap);

        BatchTeam batchTeam = BatchTeam();
        batchTeam.batchId = widget.batchId;
        batchTeam.userId = curCheck.userId;
        batchTeam.user = curCheck;

        try {
          var retData = await DioUtils().request(
              HttpApi.batch_team_add, "POST",
              data: json.encode(batchTeam), isJson: true);
          if (retData != null) {
            loadData();
          }
        } on DioError catch (error) {
          CustomAppException customAppException = CustomAppException.create(error);
          debugPrint(customAppException.getMessage());
        }
    }
  }
}
