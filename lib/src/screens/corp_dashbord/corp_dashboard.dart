import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/business/CheckApply.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/model/sys/sys_menu.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/business/corp_check_apply_screen.dart';
import 'package:agri_manager/src/screens/business/corp_check_trace_screen.dart';
import 'package:agri_manager/src/screens/dashboard/components/progress_card.dart';
import 'package:agri_manager/src/screens/project/user_batch_cycle_screen.dart';
import 'package:agri_manager/src/screens/project/user_batch_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

class CorpDashboardScreen extends StatefulWidget {
  const CorpDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CorpDashboardScreen> createState() => _CorpDashboardScreenState();
}

class _CorpDashboardScreenState extends State<CorpDashboardScreen> {
  List<Corp> listCorp = [];
  List<SysMenu> corpListMenu = [];

  LoginInfoToken userInfo = new LoginInfoToken();
  final ScrollController controllerButton = ScrollController();

  Corp? selectCorp;

  var gridViewLists = [];

  List<CheckApply> listCheckApply = [];
  List<CheckTrace> listCheckTrace = [];

  List<BatchProduct> listBatch = [];
  List<BatchCycle> listBatchCycle = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    setState(() {
      userInfo =
          LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));

      if(null !=  SpUtil.getObject(Constant.currentCorp)) {
        selectCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      }
      loadMenu();
    });
    loadCorp();
    loadData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

  }

  loadData(){
    loadApply();
    loadCheckTrace();
    loadBatch();
    loadBatchCycle();
  }



  Future loadApply() async {
    var params = {
      'userId': userInfo?.userId,
      'corpId': selectCorp?.id,
      'status': 1,
      'page': 0,
      'size': 10
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.check_apply_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listCheckApply = (retData['content'] as List)
              .map((e) => CheckApply.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }
  Future loadCheckTrace() async {
    var params = {
      'userId': userInfo?.userId,
      'corpId': selectCorp?.id,
      'status': 0,
      'page': 0,
      'size': 10
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.check_trace_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listCheckTrace = (retData['content'] as List)
              .map((e) => CheckTrace.fromJson(e))
              .toList();
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(
          error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future loadBatch() async{
    var params = {'userId': userInfo?.userId, 'corpId': selectCorp?.id, 'status': 1, 'page': 0, 'size':10};

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_query, "GET", queryParameters: params);
      if(retData != null && null != retData['content']) {
        setState(() {
          listBatch = (retData['content'] as List).map((e) => BatchProduct.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future loadBatchCycle() async{
    var params = {'createdUserId': userInfo?.userId, 'corpId': selectCorp?.id, 'status': 1, 'page': 0, 'size':10};

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_query, "GET", queryParameters: params);
      if(retData != null && null != retData['content']) {
        setState(() {
          listBatchCycle = (retData['content'] as List).map((e) => BatchCycle.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }


  Future loadCorp() async {
    var params = {'userId': userInfo.userId};
    debugPrint(json.encode(params));
    try {
      var retData = await DioUtils()
          .request(HttpApi.corp_find_by_user, "GET", queryParameters: params);
      debugPrint(json.encode(retData));
      if (retData != null) {
        debugPrint(json.encode(retData));
        setState(() {
          listCorp = (retData as List).map((e) => Corp.fromJson(e)).toList();

          if(null == selectCorp) {
            selectCorp = listCorp[0];
            SpUtil.putObject(Constant.currentCorp, selectCorp!.toJson());
            loadMenu();
          }
        });
        debugPrint(json.encode(retData));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  Future loadCorpData() async {}

  Future loadMenu() async {
    try {
      var params = {'corpId': selectCorp!.id};
      var resData = await DioUtils()
          .request(HttpApi.sys_menu_findAllSub, "GET", queryParameters: params);
      if (resData != null) {
        setState(() {
          corpListMenu =
              (resData as List).map((e) => SysMenu.fromJson(e)).toList();
          for (var i = 0; i < corpListMenu.length; i += 10) {
            gridViewLists.add(corpListMenu.sublist(i,
                i + 10 > corpListMenu.length ? corpListMenu.length : i + 10));
          }
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${selectCorp?.name ?? ''}管理台',
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset(
                'assets/icons/icon_change.png',
                color: Colors.white,
              ),
              onPressed: () {
                showCorpSelectDialog();
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(
              children: [
                buildNavigatorButton(4),
                _buildProgress(axis: Axis.vertical),
              ],
            );
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                buildNavigatorButton(6),
                _buildProgress(axis: Axis.horizontal),
              ],
            );
          },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                buildNavigatorButton(8),
                _buildProgress(axis: Axis.horizontal),
              ],
            );
          },
        )));
  }


  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
        child: (axis == Axis.horizontal)
            ? Row(
          children: [
            Flexible(
              flex: 5,
              child: ProgressCard(
                data:  ProgressCardData(
                  title: '项目',
                  assetIcon: 'assets/icons/menu/icon_project.png',
                  totalUndone: listBatch.length,
                  totalTaskInProress: listBatch.length,
                ),
                onPressedCheck: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const UserBatchProductScreen()));

                },
              ),
            ),
            const SizedBox(width: kSpacing / 2),
            Flexible(
              flex: 5,
              child: ProgressCard(
                data:  ProgressCardData(
                  title: '任务',
                  assetIcon: 'assets/icons/menu/icon_task.png',
                  totalUndone: listBatchCycle.length,
                  totalTaskInProress: listBatchCycle.length,
                ),
                onPressedCheck: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const UserBatchCycleScreen()));
                },
              ),
            ),
            const SizedBox(width: kSpacing / 2),
            Flexible(
              flex: 5,
              child:  ProgressCard(
                data:  ProgressCardData(
                  title: '单据',
                  assetIcon: 'assets/icons/menu/icon_bill.png',
                  totalUndone: listCheckApply.length,
                  totalTaskInProress: listCheckApply.length,
                ),
                onPressedCheck: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CorpCheckApplyScreen(isShowBar: true,)));

                },
              ),
            ),
            const SizedBox(width: kSpacing / 2),
            Flexible(
              flex: 5,
              child: ProgressCard(
                data:  ProgressCardData(
                  title: '审核',
                  assetIcon: 'assets/icons/menu/icon_bill_check.png',
                  totalUndone: listCheckTrace.length,
                  totalTaskInProress: listCheckTrace.length,
                ),
                onPressedCheck: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CorpCheckTraceScreen(isShowBar: true,)));
                },
              ),
            ),
          ],
        )
            : Column(
          children: [
            Row(children: [
              Expanded(
                flex: 5,
                child: ProgressCard(
                  data:  ProgressCardData(
                    title: '项目',
                    assetIcon: 'assets/icons/menu/icon_project.png',
                    totalUndone: listBatch.length,
                    totalTaskInProress: listBatch.length,
                  ),
                  onPressedCheck: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const UserBatchProductScreen()));
                  },
                ),
              ),
              const SizedBox(width: kSpacing / 2),
              Expanded(
                flex: 5,
                child: ProgressCard(
                  data:  ProgressCardData(
                    title: '任务',
                    assetIcon: 'assets/icons/menu/icon_task.png',
                    totalUndone: listBatchCycle.length,
                    totalTaskInProress: listBatchCycle.length,
                  ),
                  onPressedCheck: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const UserBatchCycleScreen()));
                  },
                ),
              )
            ]),
            Row(children: [
              Expanded(
                flex: 5,
                child:   ProgressCard(
                  data:  ProgressCardData(
                    title: '单据',
                    assetIcon: 'assets/icons/menu/icon_bill.png',
                    totalUndone: listCheckApply.length,
                    totalTaskInProress: listCheckApply.length,
                  ),
                  onPressedCheck: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CorpCheckApplyScreen(isShowBar: true,)),
                    );
                  },
                ),
              ),
              const SizedBox(width: kSpacing / 2),
              Expanded(
                flex: 5,
                child: ProgressCard(
                  data:  ProgressCardData(
                    title: '审核',
                    assetIcon: 'assets/icons/menu/icon_bill_check.png',
                    totalUndone: listCheckTrace.length,
                    totalTaskInProress: listCheckTrace.length,
                  ),
                  onPressedCheck: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const CorpCheckTraceScreen(isShowBar: true,)),
                    );

                  },
                ),
              )
            ])
          ],
        ));
  }


  Widget buildNavigatorButton(int ratioCount) {
    return  AlignedGridView.count(
      padding: EdgeInsets.symmetric(horizontal: kSpacing, vertical: kSpacing),
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      crossAxisCount: ratioCount,
      itemCount: corpListMenu.length,
      itemBuilder: (context, index) => InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(corpListMenu[index].path!);
          },
          child: SizedBox(
            child: Column(
              children: [
                Image.asset(
                  corpListMenu[index].iconUrl!,
                  width: 42,
                  height: 42,
                ),
                Text('${corpListMenu[index].name}')
              ],
            ),
          )),
    );
  }

  Future<void> showCorpSelectDialog() async {
    int? index = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        var child = Container(
            padding: const EdgeInsets.all(kSpacing),
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 400,
            ),
            child: Column(
              children: <Widget>[
                ElevatedButton(onPressed: (){
                  Navigator.of(context).pushNamed( '/corpQuery' );
                }, child: const Text('添加企业')),
                Expanded(
                    child: ListView.separated(
                        itemCount: listCorp.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('${listCorp[index].name}'),
                            onTap: () => Navigator.of(context).pop(index),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        })),
              ],
            ));
        //使用AlertDialog会报错
        //return AlertDialog(content: child);
        return Dialog(child: child);
      },
    );
    if (index != null) {
      setState(() {
        selectCorp = listCorp[index];
        SpUtil.putObject(Constant.currentCorp, selectCorp!.toJson());
      });
    }
  }
}
