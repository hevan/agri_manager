import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/model/sys/LoginInfoToken.dart';
import 'package:znny_manager/src/model/sys/sys_menu.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/shared_components/responsive_builder.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:sp_util/sp_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      userInfo =
          LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      //selectCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      Map? mapCorpSelect = SpUtil.getObject(Constant.currentCorp);

      if (null != mapCorpSelect && mapCorpSelect.isNotEmpty) {
        selectCorp = Corp.fromJson(mapCorpSelect);
      }
    });
    loadCorp();
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
          selectCorp = listCorp[0];

          loadMenu();
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
              ],
            );
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                buildNavigatorButton(6),
              ],
            );
          },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                buildNavigatorButton(8),
              ],
            );
          },
        )));
  }

  Widget buildNavigatorButton(int ratioCount) {
    return AlignedGridView.count(
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
        ),
      ),
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
