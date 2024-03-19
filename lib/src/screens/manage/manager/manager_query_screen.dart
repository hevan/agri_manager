import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/manage/CorpManagerInfo.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/manage/components/corp_manager_info_card.dart';
import 'package:agri_manager/src/screens/manage/depart/depart_query_screen.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_edit_screen.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_view_screen.dart';
import 'package:agri_manager/src/screens/manage/role/corp_role_query_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:sp_util/sp_util.dart';

class ManagerQueryScreen extends StatefulWidget {

  const ManagerQueryScreen({Key? key}) : super(key: key);

  @override
  State<ManagerQueryScreen> createState() => _ManagerQueryScreenState();
}

class _ManagerQueryScreenState extends State<ManagerQueryScreen> {

  List<CorpManagerInfo> listData = [];

  Corp?   currentCorp;

  CorpManagerInfo selectManager = new CorpManagerInfo() ;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      if (null != currentCorp) {
        loadData();
      }
    });
  }


  Future loadData() async {
    var params = {'corpId': currentCorp!.id!};

    try {
      var retData = await DioUtils().request(
          HttpApi.corp_manager_info_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listData = (retData as List).map((e) => CorpManagerInfo.fromJson(e)).toList();
          selectManager = listData[0];
        });

        debugPrint(json.encode(listData));
        debugPrint(json.encode(retData));
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('企业管理'),
    ),
    body:  ResponsiveBuilder(
    mobileBuilder: (context, constraints) {
        return _buildQuery(constraints);
    },
    tabletBuilder: (BuildContext context, BoxConstraints constraints) {
      return Row(children: [
        Flexible(flex: 4, child: _buildQuery(constraints)),
        SizedBox(width: 15, height: constraints.maxHeight,),
        Flexible(flex: 4, child: ManagerViewScreen(data: selectManager,)),
      ]);
    },
    desktopBuilder: (BuildContext context, BoxConstraints constraints) {
      return Row(children: [
        Flexible(flex: 4, child: _buildQuery(constraints)),
        SizedBox(width: 15, height: constraints.maxHeight,),
        Flexible(flex: 6, child: ManagerViewScreen(data: selectManager,)),
      ]);
    },
    )
    );
  }


  toAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  const ManagerEditScreen()),
    );
  }

  toSelectView(CorpManagerInfo corpManagerInfo){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ManagerViewScreen(data: corpManagerInfo)),
    );
  }

  toSelect(CorpManagerInfo corpManagerInfo){
    setState(() {
      selectManager = corpManagerInfo;
    });
  }

  Widget _buildQuery(BoxConstraints viewportConstraints){
    return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: viewportConstraints.maxHeight,
          ),
          child: IntrinsicHeight(
          child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(kSpacing),
                  alignment: Alignment.center,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style:  primaryButtonStyle,
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DepartQueryScreen()),
                        );
                      },
                      child: const Text('部门管理'),
                    ),
                    const SizedBox(width: 20,),
                    ElevatedButton(
                      style:  primaryButtonStyle,
                      onPressed:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RoleQueryScreen()),
                        );
                      },
                      child: const Text('角色管理'),
                    )
                  ],
                ),),
      Container(
      // A fixed-height child.
      height: 80.0,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: kSpacing, right: kSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            style:  secondButtonStyle,
            onPressed: (){
              loadData();
            },
            child: const Text('查询'),
          ),
          const SizedBox(width: 20,),
          ElevatedButton(
            style:  primaryButtonStyle,
            onPressed:toAdd,
            child: const Text('增加'),
          )
        ],
      ),
    ),
     Expanded(child:
     ListView.builder(
                itemCount: listData.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  if(ResponsiveBuilder.isMobile(context)) {
                    return CorpManagerInfoCard(data: listData[index],
                        onSelected: () => toSelectView(listData[index]));
                  }else{
                    return CorpManagerInfoCard(data: listData[index],
                        onSelected: () => toSelect(listData[index]));
                  }
                }
            )),

      ])));
  }
}