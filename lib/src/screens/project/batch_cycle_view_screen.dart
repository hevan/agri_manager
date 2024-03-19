import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchCycleExecute.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:dio/dio.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_edit_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_execute_edit_screen.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BatchCycleViewScreen extends StatefulWidget {

  final int batchCycleId;

  const BatchCycleViewScreen(
      {Key? key, required this.batchCycleId})
      : super(key: key);

  @override
  State<BatchCycleViewScreen> createState() => _BatchCycleViewScreenState();
}

class _BatchCycleViewScreenState extends State<BatchCycleViewScreen> with TickerProviderStateMixin{
  List<BatchCycle> listData = [];
  List<BatchCycleExecute> listExecute = [];
  BatchCycle _curBatchCycle = BatchCycle(status: 0);

  late final TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _curBatchCycle.id = widget.batchCycleId;

    _tabController = TabController(length: 2, vsync: this);

    loadData();
    loadExecute();
  }

  Future loadExecute() async{
    var params = {
      'batchCycleId': widget.batchCycleId,
      'page': 0,
      'size': 100,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_execute_query, "GET",
          queryParameters: params);
      debugPrint(json.encode(retData));
      if (retData != null) {

        setState(() {
          listExecute =  (retData['content'] as List).map((e) => BatchCycleExecute.fromJson(e)).toList();
        });

      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future loadData() async {
    var params = {
      'parentId': widget.batchCycleId,
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.batch_cycle_findAll_parent, "GET",
          queryParameters: params);
      debugPrint(json.encode(retData));
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
          '${HttpApi.batch_cycle_find}${widget.batchCycleId}', "GET");
      if (retBatch != null) {

        debugPrint(json.encode(retBatch));
        setState(() {
          _curBatchCycle = BatchCycle.fromJson(retBatch);
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  toDeleteExecute(int id) async{
    try {
      var retBatch = await DioUtils().request(
          '${HttpApi.batch_cycle_execute_delete}${id}', "DELETE");
    }on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                "任务详情",
              ),
              centerTitle: true,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Center(
          child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(
          maxWidth: 500,
          ),
          child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: kSpacing,),
                Row(children: [
                const Expanded(child:  Text('名称:'), flex: 2,),
                Expanded(child:  Text('${_curBatchCycle.name}'), flex:6,)
                ]),
            Row(children: [
              const Expanded(child:  Text('描述:'), flex: 2,),
              Expanded(child:  Text('${_curBatchCycle.description}'), flex:6,)
            ]),
            Row(children: [
              const Expanded(child:  Text('时间:'), flex: 2,),
              Expanded(child:  Text('${_curBatchCycle.startAt}-${_curBatchCycle.endAt}'), flex:6,)
            ]),
            Row(children: [
              const Expanded(child:  Text('状态:'), flex: 2,),
              Expanded(child:  Text(AgriUtil.showTaskStatus(_curBatchCycle.status!)), flex:6,)
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: toAdd, child: const Text('增加子任务')),
                const SizedBox(width: 10,),
                ElevatedButton(onPressed: toAddExecute, child: const Text('添加跟踪记录'))],
            ),
                  ],
                ))),
              ),
              expandedHeight: 260.0,
              bottom: TabBar(
                  indicatorColor: Colors.black,
                  labelPadding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  controller: _tabController,
                  tabs: [
                    Text("子任务"),
                    Text("执行情况"),
                  ]),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView.separated(
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  height: defaultPadding,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  BatchCycle batchCycleTemp = listData[index];

                  return ListTile(leading: CircleAvatar(
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
                  );
                }),

            ListView.separated(
                itemCount: listExecute.length,
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  height: defaultPadding,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  BatchCycleExecute cycleExecute = listExecute[index];

                  return Container(
                      height: 100,
                      padding: EdgeInsets.all(kSpacing),
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${cycleExecute.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text('描述：${cycleExecute.description}', style: TextStyle(color: Colors.grey)),
                                  Text('时间：${cycleExecute.startAt} 至 ${cycleExecute.endAt}', style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              flex: 6,
                            ),
                        Expanded( child: Text(AgriUtil.showTaskStatus(cycleExecute.status!)),flex:1),
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
                                                BatchCycleExecuteEditScreen(id: cycleExecute.id, batchCycleId: cycleExecute.batchCycle!.id!, batchCycleName: cycleExecute.batchCycle!.name!)

                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color:Colors.orange),
                                    tooltip: '删除',
                                    onPressed: () {
                                      toDeleteExecute(cycleExecute.id!);
                                    },
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                          ]) );
                }),

          ],
        ),
      ),
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [

        Center(
        child: Container(
        padding: const EdgeInsets.all(defaultPadding),
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: Column( children: [
      Row(children: [
          const Expanded(child:  Text('名称:'), flex: 2,),
          Expanded(child:  Text('${_curBatchCycle.name}'), flex:6,)
        ]),
        Row(children: [
          const Expanded(child:  Text('描述:'), flex: 2,),
          Expanded(child:  Text('${_curBatchCycle.description}'), flex:6,)
        ]),
        Row(children: [
          const Expanded(child:  Text('时间:'), flex: 2,),
          Expanded(child:  Text('${_curBatchCycle.startAt}-${_curBatchCycle.endAt}'), flex:6,)
        ]),
        Row(children: [
          const Expanded(child:  Text('状态:'), flex: 2,),
          Expanded(child:  Text(AgriUtil.showTaskStatus(_curBatchCycle.status!)), flex:6,)
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: toAdd, child: const Text('增加子任务')),
            const SizedBox(width: 10,),
            ElevatedButton(onPressed: toAddExecute, child: const Text('添加跟踪记录'))],
        ),]))),
        Expanded(child:
        TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: '子任务'),
            Tab(text: '执行记录'),
          ],
        )),
        Expanded(
            child:
            TabBarView(
                controller: _tabController,
                children: <Widget>[
            ListView.separated(
                itemCount: listData.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: defaultPadding,
                      color: Colors.grey,
                    ),
                itemBuilder: (context, index) {
                  BatchCycle batchCycleTemp = listData[index];

                  return ListTile(leading: CircleAvatar(
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
                  );
                }),

                  ListView.separated(
                      itemCount: listExecute.length,
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        height: defaultPadding,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) {
                        BatchCycleExecute cycleExecute = listExecute[index];

                        return Card(
                            child:Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${cycleExecute.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text('时间：${cycleExecute.startAt} 至 ${cycleExecute.endAt}', style: TextStyle(color: Colors.grey)),
                                    Text('描述：${cycleExecute.description}', style: TextStyle(color: Colors.grey)),
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
                                                  BatchCycleExecuteEditScreen(id: cycleExecute.id, batchCycleId: cycleExecute.batchCycle!.id!, batchCycleName: cycleExecute.batchCycle!.name!)

                                                  ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color:Colors.orange),
                                      tooltip: '删除',
                                      onPressed: () {
                                        toDeleteExecute(cycleExecute.id!);
                                      },
                                    )
                                  ],
                                ),
                                flex: 2,
                              ),
                            ]) );
                      }),

                ])),
      ],
    ));
  }

   */

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchCycleEditScreen(
                batchId: _curBatchCycle.batchId!
              )),
    );
  }

  toAddExecute() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BatchCycleExecuteEditScreen(
              batchCycleId: _curBatchCycle.id!,
              batchCycleName: _curBatchCycle.name!,
          )),
    );
  }
}
