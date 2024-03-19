import 'package:flutter/material.dart';
import 'package:agri_manager/src/screens/business/corp_check_apply_screen.dart';
import 'package:agri_manager/src/screens/business/corp_check_trace_screen.dart';

class CorpManageCheckScreen extends StatefulWidget {
  const CorpManageCheckScreen({Key? key}) : super(key: key);

  @override
  State<CorpManageCheckScreen> createState() => _CorpManageCheckScreenState();
}

class _CorpManageCheckScreenState extends State<CorpManageCheckScreen> with TickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState(){
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
             Tab(icon: Icon(Icons.check_box), child:  Text('待审批')),
             Tab(icon: Icon(Icons.bookmark_added_sharp), child: Text('已审核'))
          ],
        ),
        title: const Text('审核的记录'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const CorpCheckTraceScreen(isShowBar: false, status: 0,),
          const CorpCheckTraceScreen(isShowBar: false, status: 1)
        ],
      ),
    );
  }
}