
import 'package:data_table_2/data_table_2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class EntityCheckTraceScreen extends StatefulWidget {
  final int entityId;
  final String entityName;
  const EntityCheckTraceScreen({Key? key, required this.entityId, required this.entityName}) : super(key: key);

  @override
  State<EntityCheckTraceScreen> createState() => _EntityCheckTraceScreenState();
}

class _EntityCheckTraceScreenState extends State<EntityCheckTraceScreen>{

  List<CheckTrace> listData = [];


  PageModel pageModel = PageModel();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    super.initState();

    loadData();
  }

  Future loadData() async{
    var params = {'entityId': widget.entityId, 'entityName': widget.entityName, 'page': pageModel.page, 'size':pageModel.size};

    try {
      var retData = await DioUtils().request(
          HttpApi.check_trace_query, "GET", queryParameters: params);
      if(retData != null && null != retData['content']) {
        setState(() {
          listData = (retData['content'] as List).map((e) => CheckTrace.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      body:  Column(children: <Widget>[
                      ListView.separated(
                              shrinkWrap: true,
                              itemCount: listData.length,
                              separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                height: defaultPadding,
                                color: Colors.grey,
                              ),
                              itemBuilder: (context, index) {
                                CheckTrace tempData = listData[index];
                                return ListTile(
                                  title:  Text('${tempData.title}'),
                                  subtitle:  Text('${tempData.createdUser?.nickName}'),
                                  trailing: Text(AgriUtil.showCheckTraceStatus(tempData.status)),
                                );
                              }),
                    ]));
  }

}