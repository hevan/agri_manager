import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class UserBatchCycleScreen extends StatefulWidget {

  const UserBatchCycleScreen(
      {Key? key})
      : super(key: key);

  @override
  State<UserBatchCycleScreen> createState() => _UserBatchCycleScreenState();
}

class _UserBatchCycleScreenState extends State<UserBatchCycleScreen> {
  List<BatchCycle> listData = [];

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
      'createdUserId': userInfo?.userId,
      'page': 0,
      'size': 100
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_query, "GET",
          queryParameters: params);
      if (retData != null && null != retData['content']) {
        List<BatchCycle> listTemp =
            (retData['content'] as List).map((e) => BatchCycle.fromJson(e)).toList();

        setState(() {
          listData = listTemp;
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
        appBar: AppBar(title: const Text('计划管理')),
        body: Column(
      children: [
        const SizedBox(height: kSpacing,),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: loadData, child: const Text('查询')),
            const SizedBox(width: 10,)
          ],
        ),
        Expanded(
            child: ListView.separated(
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: defaultPadding,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  BatchCycle batchCycleTemp = listData[index];
                  return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: batchCycleTemp.imageUrl != null
                                  ? Image(
                                      image: NetworkImage(
                                          '${HttpApi.host_image}${batchCycleTemp.imageUrl}'),
                                      width: 60,
                                      height: 60)
                                  : Center(
                                      child: Image.asset('assets/icons/icon_add_image.png', width: 60, height: 60),
                                    ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${batchCycleTemp.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('时间：${batchCycleTemp.startAt} 至 ${batchCycleTemp.endAt}', style: TextStyle(color: Colors.grey)),
                                  Text('描述：${batchCycleTemp.description}', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              flex: 6,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,),
                                    tooltip: '查看',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BatchCycleViewScreen(
                                                    batchCycleId: batchCycleTemp.id!,
                                                )),
                                      );
                                    },
                                  )
                                ],
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                        null != batchCycleTemp.children
                            ? Column(
                                children: buildItem(batchCycleTemp.children!),
                              )
                            : Container(),
                      ],
                  );
                })),
      ],
    ));
  }


  toDelete(int? id) async {
    try {
      await DioUtils().request('${HttpApi.batch_cycle_delete}${id}', "DELETE");
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

  buildItem(List<BatchCycle> listItem) {
    List<Widget> itemWidget = [];
    for (int i = 0; i < listItem.length; i++) {
      BatchCycle curTemp = listItem[i];
      itemWidget.add(SizedBox(
          height: 70,
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child:curTemp.imageUrl != null
                      ? Image(
                      image: NetworkImage(
                          '${HttpApi.host_image}${curTemp.imageUrl}'),
                      width: 60,
                      height: 60)
                      : Center(
                    child: Image.asset(
                        'assets/icons/icon_add_image.png', width: 60, height: 60,),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${curTemp.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('时间：${curTemp.startAt} 至 ${curTemp.endAt}', style: TextStyle(color: Colors.grey)),
                      Text('描述：${curTemp.description}', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit,),
                        tooltip: '查看',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BatchCycleViewScreen(
                                      batchCycleId: curTemp.id!,
                                    )),
                          );
                        },
                      )
                    ],
                  ),
                  flex: 2,
                ),
              ],
            ),
          )));
    }

    return itemWidget;
  }

  confirmDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("确定删除"),
          content: const Text("确定要删除该记录吗?，若存在关联数据将无法删除"),
          actions: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () async {
                await toDelete(id);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
