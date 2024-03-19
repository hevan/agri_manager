import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/manage/CorpRole.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/manage/role/corp_role_edit_screen.dart';
import 'package:agri_manager/src/screens/manage/role/corp_role_view_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

class RoleQueryScreen extends StatefulWidget {

  const RoleQueryScreen({Key? key}) : super(key: key);

  @override
  State<RoleQueryScreen> createState() => _RoleQueryScreenState();
}

class _RoleQueryScreenState extends State<RoleQueryScreen> {

  List<CorpRole> listData = [];

  Corp?   currentCorp;

  CorpRole selectRole = new CorpRole() ;

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
          HttpApi.role_findAll, "GET", queryParameters: params, isJson: true);
      if (retData != null) {
        setState(() {
          listData = (retData as List).map((e) => CorpRole.fromJson(e)).toList();
          selectRole = listData[0];
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
        title: const Text(' 角色管理'),
    ),
    body:  ResponsiveBuilder(
    mobileBuilder: (context, constraints) {
        return _buildQuery(constraints);
    },
    tabletBuilder: (BuildContext context, BoxConstraints constraints) {
      return Row(children: [
        Flexible(flex: 4, child: _buildQuery(constraints)),
        SizedBox(width: 15, height: constraints.maxHeight,),
        Flexible(flex: 4, child: CorpRoleViewScreen(data: selectRole,)),
      ]);
    },
    desktopBuilder: (BuildContext context, BoxConstraints constraints) {
      return Row(children: [
        Flexible(flex: 4, child: _buildQuery(constraints)),
        SizedBox(width: 15, height: constraints.maxHeight,),
        Flexible(flex: 6, child: CorpRoleViewScreen(data: selectRole,)),
      ]);
    },
    )
    );
  }


  toAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  const CorpRoleEditScreen()),
    );
  }

  toSelectView(CorpRole corpRole){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CorpRoleViewScreen(data: corpRole)),
    );
  }

  toSelect(CorpRole corpRole){
    setState(() {
      selectRole = corpRole;
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
                    return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: InkWell(
                          onTap: () => toSelectView(listData[index]),
                          child:Padding(
                            padding: const EdgeInsets.all(kSpacing),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${listData[index].id ?? ''} ${listData[index].name ?? ''} ', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        )
                    );
                  }else{
                    return    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kBorderRadius),
                        ),
                        child: InkWell(
                          onTap: () => toSelect(listData[index]),
                          child:Padding(
                            padding: const EdgeInsets.all(kSpacing),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${listData[index].id ?? ''} ${listData[index].name ?? ''} ', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        )
                    );
                  }
                }
            )),

      ])));
  }
}