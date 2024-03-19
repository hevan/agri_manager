import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleScreen extends StatefulWidget {
  final int batchId;

  const BatchCycleScreen(
      {Key? key, required this.batchId})
      : super(key: key);

  @override
  State<BatchCycleScreen> createState() => _BatchCycleScreenState();
}

class _BatchCycleScreenState extends State<BatchCycleScreen> {
  List<BatchCycle> listData = [];

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
      'batchId': widget.batchId,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_findAll, "GET",
          queryParameters: params);
      if (retData != null) {
        List<BatchCycle> listTemp =
            (retData as List).map((e) => BatchCycle.fromJson(e)).toList();

        List<BatchCycle> listTree = [];

        for (int i = 0; i < listTemp.length; i++) {
          BatchCycle curTemp = listTemp[i];
          if (null == curTemp.parentId) {
            curTemp.children = [];
            listTree.add(curTemp);
          }
        }

        for (int i = 0; i < listTemp.length; i++) {
          BatchCycle curTemp = listTemp[i];
          if (curTemp.parentId != null) {
            for (int m = 0; m < listTree.length; m++) {
              if (curTemp.parentId == listTree[m].id) {
                listTree[m].children!.add(curTemp);
              }
            }
          }
        }
        setState(() {
          listData = listTree;
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
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: toAdd, child: const Text('增加')),
            const SizedBox(width: 10,),
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
                                    tooltip: '编辑',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BatchCycleEditScreen(
                                                    id: batchCycleTemp.id,
                                                    batchId: widget.batchId
                                                )),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color:Colors.orange),
                                    tooltip: '删除',
                                    onPressed: () {
                                      toDelete(batchCycleTemp.id);
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

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchCycleEditScreen(
                batchId: widget.batchId
              )),
    );
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
                        tooltip: '编辑',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BatchCycleEditScreen(
                                      id: curTemp.id,
                                      batchId: widget.batchId
                                    )),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color:Colors.orange),
                        tooltip: '删除',
                        onPressed: () {
                          toDelete(curTemp.id);
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
