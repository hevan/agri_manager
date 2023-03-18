import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/project/BatchCycle.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:znny_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';

class BatchCycleViewScreen extends StatefulWidget {

  final int batchCycleId;

  const BatchCycleViewScreen(
      {Key? key, required this.batchCycleId})
      : super(key: key);

  @override
  State<BatchCycleViewScreen> createState() => _BatchCycleViewScreenState();
}

class _BatchCycleViewScreenState extends State<BatchCycleViewScreen> {
  List<BatchCycle> listData = [];
  BatchCycle _curBatchCycle = BatchCycle();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    loadData();
    _curBatchCycle.id = widget.batchCycleId;
  }

  Future loadData() async {
    var params = {
      'parentId': widget.batchCycleId,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_findAll_parent, "GET",
          queryParameters: params);
      if (retData != null) {
        List<BatchCycle> listTemp =
            (retData as List).map((e) => BatchCycle.fromJson(e)).toList();

        setState(() {
          listData = listTemp;
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }

    try {
      var retBatch = await DioUtils().request(
          '${HttpApi.batch_cycle_find}/${widget.batchCycleId}', "GET");
      if (retBatch != null) {

        setState(() {
          _curBatchCycle = BatchCycle.fromJson(retBatch);
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
        body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ElevatedButton(onPressed: toAdd, child: const Text('增加'))],
        ),
        Expanded(
            child: ListView.separated(
                primary: false,
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: defaultPadding,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  BatchCycle batchCycleTemp = listData[index];

                  return Card(
                    child: Column(
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
                                      width: 120,
                                      height: 120)
                                  : Center(
                                      child: Image.asset(
                                          'assets/icons/icon_add_image.png'),
                                    ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${batchCycleTemp.name}'),
                                  Text('${batchCycleTemp.batchName}'),
                                  Text('${batchCycleTemp.description}'),
                                ],
                              ),
                              flex: 6,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: const Text('编辑'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BatchCycleEditScreen(
                                                  id: batchCycleTemp.id,
                                                  batchId: batchCycleTemp.batchId!
                                                )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    child: const Text('查看'),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                BatchCycleViewScreen(
                                                  batchCycleId: batchCycleTemp.id!
                                                )),
                                      );
                                    },
                                  ),
                                  InkWell(
                                    child: const Text('删除'),
                                    onTap: toDelete(batchCycleTemp.id),
                                  ),
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
                    ),
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
                batchId: _curBatchCycle.batchId!
              )),
    );
  }

  toDelete(int? id) {}

  buildItem(List<BatchCycle> listItem) {
    List<Widget> itemWdiget = [];
    for (int i = 0; i < listItem.length; i++) {
      BatchCycle curTemp = listItem[i];
      itemWdiget.add(SizedBox(
          height: 120,
          child: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child:curTemp.imageUrl != null
                      ? Image(
                      image: NetworkImage(
                          'http://localhost:8080/open/gridfs/${curTemp.imageUrl}'),
                      width: 80,
                      height: 80)
                      : Center(
                    child: Image.asset(
                        'assets/icons/icon_add_image.png'),
                  ),
                  flex: 4,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${curTemp.name}'),
                      Text('${curTemp.batchName}'),
                      Text('${curTemp.description}'),
                    ],
                  ),
                  flex: 6,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: const Text('编辑'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BatchCycleEditScreen(
                                      id: curTemp.id,
                                      batchId: curTemp.batchId!
                                    )),
                          );
                        },
                      ),
                      InkWell(
                        child: const Text('查看'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BatchCycleViewScreen(
                                      batchCycleId: curTemp.id!,
                                    )),
                          );
                        },
                      ),
                      InkWell(
                        child: const Text('删除'),
                        onTap: toDelete(curTemp.id),
                      ),
                    ],
                  ),
                  flex: 2,
                ),
              ],
            ),
          )));
    }

    return itemWdiget;
  }
}
