import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchFinanceAnalysis.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/business/purchase_order_screen.dart';
import 'package:agri_manager/src/screens/business/sale_order_screen.dart';
import 'package:agri_manager/src/screens/project/batch_base_screen.dart';
import 'package:agri_manager/src/screens/project/batch_base_show_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_invest_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_screen.dart';
import 'package:agri_manager/src/screens/project/batch_cycle_show_screen.dart';
import 'package:agri_manager/src/screens/project/batch_risk_screen.dart';
import 'package:agri_manager/src/screens/project/batch_risk_show_screen.dart';
import 'package:agri_manager/src/screens/project/batch_team_screen.dart';
import 'package:agri_manager/src/shared_components/chart_percent_show_data.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BatchViewScreen extends StatefulWidget {
  final int? id;

  const BatchViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<BatchViewScreen> createState() => _BatchViewScreenState();
}

class _BatchViewScreenState extends State<BatchViewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  BatchProduct _batch = BatchProduct();

  BatchFinanceAnalysis _batchFinanceAnalysis = BatchFinanceAnalysis(estimatedInvest: 1, estimatedAmount: 1, realInvest: 0.0, realAmount: 0.0);
  List<_FinanceChartData> chartData = <_FinanceChartData>[];

  List<Map<String, String>> listActions = [
    {
      'name': '地块信息',
      'iconUrl': 'assets/icons/menu/icon_bill_expense.png',
      'path': 'batchBase'
    },
    {
      'name': '任务管理',
      'iconUrl': 'assets/icons/menu/icon_task.png',
      'path': 'taskManage'
    },
    {
      'name': '风险管理',
      'iconUrl': 'assets/icons/menu/icon_risk.png',
      'path': 'riskManage'
    },
    {
      'name': '采购单据',
      'iconUrl': 'assets/icons/menu/icon_bill_purchase.png',
      'path': 'purchaseOrder'
    },
    {
      'name': '销售单据',
      'iconUrl': 'assets/icons/menu/icon_bill_sale.png',
      'path': 'saleOrder'
    }
  ];

  Corp? curCorp;
  LoginInfoToken userInfo = LoginInfoToken();

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo =
          LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    loadData();
    loadFinanceData();
  }

  Future loadData() async {
    if (widget.id != null) {
      try {
        var retData = await DioUtils()
            .request(HttpApi.batch_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _batch = BatchProduct.fromJson(retData);
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  Future loadFinanceData() async {
    if (widget.id != null) {
      try {
        var retData = await DioUtils()
            .request(HttpApi.batch_analysis + widget.id!.toString(), "GET");
        if (retData != null) {
          setState(() {
            _batchFinanceAnalysis = BatchFinanceAnalysis.fromJson(retData);

            chartData.add(_FinanceChartData(
                title: '预计投入',
                amount: _batchFinanceAnalysis.estimatedInvest!.toDouble()));
            chartData.add(_FinanceChartData(
                title: '实际投入',
                amount: _batchFinanceAnalysis.realInvest!.toDouble()));
            chartData.add(_FinanceChartData(
                title: '预计销售',
                amount: _batchFinanceAnalysis.estimatedAmount!.toDouble()));
            chartData.add(_FinanceChartData(
                title: '实际销售',
                amount: _batchFinanceAnalysis.realAmount!.toDouble()));

            debugPrint(jsonEncode(_batchFinanceAnalysis));
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    }
  }

  toManageAction(BuildContext context, String? actionPath) {
    if (actionPath == 'taskManage') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BatchCycleScreen(
                    batchId: _batch.id!,
                  )));
    } else if (actionPath == 'riskManage') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BatchRiskScreen(
                  batchId: _batch.id!,
                  batchName: _batch.name!,
                  productId: _batch.productId!,
                  productName: _batch.product!.name!)));
    } else if (actionPath == 'saleOrder') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SaleOrderScreen(
                  batchId: _batch.id!, batchName: _batch.name!)));
    } else if (actionPath == 'purchaseOrder') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PurchaseOrderScreen(
                  batchId: _batch.id!, batchName: _batch.name!)));
    } else if (actionPath == 'batchBase') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BatchBaseScreen(
                  batchId: _batch.id!,
                  batchName: _batch.name!,
                  parkId: _batch.parkId!)));
    }
  }

  List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('${_batch.name}'),
          centerTitle: true,
          // 标题居中
          floating: true,
          // 随着滑动隐藏标题
          pinned: true),
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(defaultPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(children: [
                  const Expanded(
                    child: Text('名称:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.name}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('编码:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.code}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('产品:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.product?.name}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('面积:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.area}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('产量:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.quantity}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('预估销售价格:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.estimatedPrice}'),
                    flex: 6,
                  )
                ]),
                Row(children: [
                  const Expanded(
                    child: Text('描述:'),
                    flex: 2,
                  ),
                  Expanded(
                    child: Text('${_batch.description}'),
                    flex: 6,
                  )
                ]),
                AlignedGridView.count(
                  padding: EdgeInsets.symmetric(
                      horizontal: kSpacing, vertical: kSpacing),
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  crossAxisCount: 5,
                  itemCount: listActions.length,
                  itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        toManageAction(context, listActions[index]['path']);
                      },
                      child: SizedBox(
                        child: Column(
                          children: [
                            Image.asset(
                              listActions[index]['iconUrl']!,
                              width: 42,
                              height: 42,
                            ),
                            Text('${listActions[index]['name']}')
                          ],
                        ),
                      )),
                ),
                ChartPercentShowData(title: '投入进度分析' , percent: 0 == _batchFinanceAnalysis.estimatedInvest! ? 0: ((_batchFinanceAnalysis.realInvest! /
                    _batchFinanceAnalysis.estimatedInvest!) *100).round() / 100,
                    preData: _batchFinanceAnalysis.estimatedInvest!.toDouble(),
                    realData: _batchFinanceAnalysis.realInvest!.toDouble()),
                ChartPercentShowData(title: '销售进度分析', percent:  0 == _batchFinanceAnalysis.estimatedAmount! ? 0:((_batchFinanceAnalysis.realAmount! /
                    _batchFinanceAnalysis.estimatedAmount!)*100).round() / 100,
                    preData: _batchFinanceAnalysis.estimatedAmount!.toDouble(),
                    realData: _batchFinanceAnalysis.realAmount!.toDouble()),

              ],
            ),
          ),
        ]),
      ),
      SliverPersistentHeader(
        delegate: _SilverAppBarDelegate(TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "基地地块",
            ),
            Tab(
              text: "项目周期",
            ),
            Tab(
              text: "投入预估",
            ),
            Tab(
              text: "风险管理",
            ),
            Tab(
              text: "项目团队",
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
        body: TabBarView(
          controller: _tabController,
          children: [
            null != _batch.id
                ? BatchBaseShowScreen(
                    batchId: _batch.id!,
                    batchName: _batch.name!,
                    parkId: _batch.parkId!)
                : const Center(),
            null != _batch.id
                ? BatchCycleShowScreen(batchId: _batch.id!)
                : const Center(),
            null != _batch.id
                ? Container(child: BatchCycleInvestScreen(batchId: _batch.id!))
                : const Center(),
            null != _batch.id
                ? Container(
                    child: BatchRiskShowScreen(
                        batchId: _batch.id!,
                        batchName: _batch.name!,
                        productId: _batch.product!.id!,
                        productName: _batch.product!.name!))
                : const Center(),
            null != _batch.id
                ? Container(child: BatchTeamScreen(batchId: _batch.id!))
                : const Center(),
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
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class _FinanceChartData {
  _FinanceChartData({required this.title, required this.amount});

  final String title;
  final double amount;
}
