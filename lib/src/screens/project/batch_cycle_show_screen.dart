import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleShowScreen extends StatefulWidget {
  final int batchId;

  const BatchCycleShowScreen(
      {Key? key, required this.batchId})
      : super(key: key);

  @override
  State<BatchCycleShowScreen> createState() => _BatchCycleScreenState();
}

class _BatchCycleScreenState extends State<BatchCycleShowScreen> {
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
        body: Column(
      children: [
        const SizedBox(height: 20),
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
                        ListTile(leading: CircleAvatar(
                          radius:50,
                    backgroundImage: NetworkImage(
                    '${HttpApi.host_image}${batchCycleTemp.imageUrl}')),
                      title:  Text('${batchCycleTemp.name}'),
                      subtitle:  Text('${batchCycleTemp.description}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>  BatchCycleViewScreen(batchCycleId: batchCycleTemp.id!,))
                            );
                          },
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
                batchId: widget.batchId
              )),
    );
  }

  toDelete(int? id) {}

  buildItem(List<BatchCycle> listItem) {
    List<Widget> itemWdiget = [];
    for (int i = 0; i < listItem.length; i++) {
      BatchCycle curTemp = listItem[i];
      itemWdiget.add(Row(children: [
        const SizedBox(width: 15,),
        Expanded(child:
        ListTile(leading: CircleAvatar(
          radius: 50,
            backgroundImage: NetworkImage(
                '${HttpApi.host_image}${curTemp.imageUrl}'),
          ),
          title:  Text('${curTemp.name}'),
          subtitle:  Text('${curTemp.description}'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>  BatchCycleViewScreen(batchCycleId: curTemp.id!,))
            );
          },
        )),

      ]));
    }

    return itemWdiget;
  }
}
