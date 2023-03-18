
import 'package:sp_util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/project/BatchProduct.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/project/batch_cycle_expense_screen.dart';
import 'package:znny_manager/src/screens/project/batch_cycle_screen.dart';
import 'package:znny_manager/src/screens/project/batch_risk_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class BatchViewScreen extends StatefulWidget {
  final int? id;

  const BatchViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<BatchViewScreen> createState() => _BatchViewScreenState();
}

class _BatchViewScreenState extends State<BatchViewScreen> with TickerProviderStateMixin {

  TabController? _tabController;

  BatchProduct _batch = BatchProduct(corpId: HttpApi.corpId);
  int? userId;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

    loadData();

    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  Future loadData() async {

    if(widget.id != null){
      try {
        var retData = await DioUtils().request(
            HttpApi.batch_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _batch = BatchProduct.fromJson(retData);
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException = CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }


  }

  List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
       SliverAppBar(
        leading:  GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('${_batch.name}'),
        centerTitle: true, // 标题居中
        floating: true, // 随着滑动隐藏标题
        pinned: true
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(defaultPadding),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                 Row(children: [
                    const Expanded(child:  Text('名称:'), flex: 2,),
                    Expanded(child:  Text('${_batch.name}'), flex:6,)
                 ]),
                  Row(children: [
                    const Expanded(child:  Text('编码:'), flex: 2,),
                    Expanded(child:  Text('${_batch.code}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('产品:'), flex: 2,),
                    Expanded(child:  Text('${_batch.product?.name}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('描述:'), flex: 2,),
                    Expanded(child:  Text('${_batch.description}'), flex:6,)
                  ]),
                  const Divider(height: 1.0,)
                ],
            ),
          )
        ]),
      ),
       SliverPersistentHeader(
        delegate: _SilverAppBarDelegate(TabBar(
          controller: _tabController,
          tabs:const [
             Tab(
              text: "生长周期",
            ),
             Tab(
              text: "病虫害",
            ),
             Tab(
              text: "种植成本",
            ),
          ],
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body:  TabBarView(
              controller: _tabController,
              children: [
                  null != _batch.name ? BatchCycleScreen(batchId: _batch.id!) : const Center(),
                  null != _batch.name ? BatchRiskScreen(batchId: _batch.id!, batchName: _batch.name!, productId: _batch.id!, productName: _batch.name!) : const Center(),

                  null != _batch.name ? BatchCycleExpenseScreen(batchId: _batch.id!,) : const Center(),

              ],
            ),
          )),
    );
  }
}

class _SilverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SilverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return  Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}