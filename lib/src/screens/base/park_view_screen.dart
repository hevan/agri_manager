import 'package:flutter/widgets.dart';
import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/base/Park.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/base/park_base_screen.dart';
import 'package:znny_manager/src/screens/document/document_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class ParkViewScreen extends StatefulWidget {
  final int? id;

  const ParkViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ParkViewScreen> createState() => _ParkViewScreenState();
}

class _ParkViewScreenState extends State<ParkViewScreen> with TickerProviderStateMixin {

  TabController? _tabController;

  Park _park = Park(corpId: HttpApi.corpId);
  int? userId;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
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
            HttpApi.park_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _park = Park.fromJson(retData);
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
        title: Text('${_park.name}'),
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
                    Expanded(child:  Text('${_park.name}'), flex:6,)
                 ]),
                  Row(children: [
                    const Expanded(child:  Text('面积:'), flex: 2,),
                    Expanded(child:  Text('${_park.area}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('实际面积:'), flex: 2,),
                    Expanded(child:  Text('${_park.areaUse}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('描述:'), flex: 2,),
                    Expanded(child:  Text('${_park.description}'), flex:6,)
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
              text: "地块信息",
            ),
            Tab(
              text: "基地资料",
            ),
          ],
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body:  NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body:  TabBarView(
              controller: _tabController,
              children: [
                  null != _park.name ? ParkBaseScreen(parkId: _park.id!, parkName: _park.name!,) : const Center(),
                  null != _park.name ? DocumentScreen(entityId: _park.id!, entityName: 'park', name: _park.name!,) : const Center(),
              ],
            ),
          ),
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