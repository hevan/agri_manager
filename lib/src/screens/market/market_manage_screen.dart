import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/screens/market/mark_category_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_market_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_market_show_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_show_screen.dart';
import 'package:agri_manager/src/screens/market/market_screen.dart';
import 'package:agri_manager/src/screens/market/market_show_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

class MarketManageScreen extends StatefulWidget {

  const MarketManageScreen({Key? key}) : super(key: key);

  @override
  State<MarketManageScreen> createState() => _MarketManageScreenState();
}

class _MarketManageScreenState extends State<MarketManageScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;

  List<Map<String, String>> listActions = [
    {
      'name': '分类管理',
      'iconUrl': 'assets/icons/menu/icon_task.png',
      'path': 'markCategory'
    },
    {
      'name': '市场产品',
      'iconUrl': 'assets/icons/menu/icon_risk.png',
      'path': 'markProduct'
    },
    {
      'name': '市场信息',
      'iconUrl': 'assets/icons/menu/icon_bill_expense.png',
      'path': 'markMarket'
    },
    {
      'name': '市场价格采集',
      'iconUrl': 'assets/icons/menu/icon_bill_purchase.png',
      'path': 'markProductMarket'
    },
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
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

  }

  toManageAction(BuildContext context, String? actionPath){

    if(actionPath == 'markCategory') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  const MarkCategoryScreen())
      );
    }else  if(actionPath == 'markProduct') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  const MarkProductScreen())
      );
    }else  if(actionPath == 'markMarket') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  const MarketScreen())
      );
    }else  if(actionPath == 'markProductMarket') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>  const MarkProductMarketShowScreen())
      );
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
          title: Text('市场数据管理'),
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
                )
              ],
            ),
          )
        ]),
      ),
      SliverPersistentHeader(
        delegate: _SilverAppBarDelegate(TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              text: "市场产品",
            ),
            Tab(
              text: "市场信息",
            ),
            Tab(
              text: "市场价格采集",
            )
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
          const MarkProductShowScreen(),
          const MarketShowScreen(),
            const MarkProductMarketScreen(),
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
