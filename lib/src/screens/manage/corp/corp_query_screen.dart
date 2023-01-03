import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:znny_manager/src/model/manage/Corp.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/manage/components/corp_info_card.dart';
import 'package:znny_manager/src/screens/manage/corp/corp_edit_screen.dart';
import 'package:znny_manager/src/screens/manage/corp/corp_view_screen.dart';
import 'package:znny_manager/src/shared_components/responsive_builder.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CorpQueryScreen extends StatefulWidget {
  const CorpQueryScreen({Key? key}) : super(key: key);

  @override
  State<CorpQueryScreen> createState() => _CorpQueryScreenState();
}

class _CorpQueryScreenState extends State<CorpQueryScreen> {

  List<Corp> listData = [];

   Corp selectCorp = new Corp() ;

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
    var params = {'name': '', 'page': 0, 'size': 50};

    try {
      var retData = await DioUtils().request(
          HttpApi.corp_pageQuery, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listData = (retData['content'] as List).map((e) => Corp.fromJson(e)).toList();
          selectCorp = listData[0];
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
        Flexible(flex: 4, child: CorpViewScreen(data: selectCorp,)),
      ]);
    },
    desktopBuilder: (BuildContext context, BoxConstraints constraints) {
      return Row(children: [
        Flexible(flex: 4, child: _buildQuery(constraints)),
        SizedBox(width: 15, height: constraints.maxHeight,),
        Flexible(flex: 6, child: CorpViewScreen(data: selectCorp,)),
      ]);
    },
    )
    );
  }


  toAdd(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  const CorpEditScreen()),
    );
  }

  toSelectView(Corp corp){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  CorpViewScreen(data: corp)),
    );
  }

  toSelect(Corp corp){
    setState(() {
      selectCorp = corp;
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
                    return CorpInfoCard(data: listData[index],
                        onSelected: () => toSelectView(listData[index]));
                  }else{
                    return CorpInfoCard(data: listData[index],
                        onSelected: () => toSelect(listData[index]));
                  }
                }
            )),

      ])));
  }
}