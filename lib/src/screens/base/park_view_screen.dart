import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/base/Park.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/base/park_base_edit_screen.dart';
import 'package:agri_manager/src/screens/base/park_base_screen.dart';
import 'package:agri_manager/src/screens/base/park_edit_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class ParkViewScreen extends StatefulWidget {
  final Park data;

  const ParkViewScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<ParkViewScreen> createState() => _ParkViewScreenState();
}

class _ParkViewScreenState extends State<ParkViewScreen> with TickerProviderStateMixin {

  TabController? _tabController;


  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  Corp?   currentCorp;
  LoginInfoToken? userInfo;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();

    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });
  }



  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ParkEditScreen(id: widget.data.id)),
    );
  }

  toEditBase() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ParkBaseEditScreen()),
    );
  }

  Future toDelete(int id) async {
    try {
      await DioUtils().request('${HttpApi.customer_delete}${id}', "DELETE");
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


  List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            margin: const EdgeInsets.all(defaultPadding),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  <Widget>[
                 Row(children: [
                    const Expanded(child:  Text('名称:'), flex: 2,),
                    Expanded(child:  Text('${widget.data.name}'), flex:6,)
                 ]),
                  Row(children: [
                    const Expanded(child:  Text('面积:'), flex: 2,),
                    Expanded(child:  Text('${widget.data.area}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('实际面积:'), flex: 2,),
                    Expanded(child:  Text('${widget.data.areaUse}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('描述:'), flex: 2,),
                    Expanded(child:  Text('${widget.data.description}'), flex:6,)
                  ]),
                  SizedBox(height: kSpacing,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: elevateButtonStyle,
                        onPressed: () {
                          toEdit();
                        },
                        child: const Text('编辑'),
                      ),
                      SizedBox(
                        width: kSpacing,
                      ),
                      ElevatedButton(
                        style: elevateButtonStyle,
                        onPressed: () {
                          confirmDeleteDialog(context, widget.data.id!);
                        },
                        child: const Text('删除'),
                      )
                    ],
                  ),
                  SizedBox(height: kSpacing,),
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
            )
          ],
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: ResponsiveBuilder.isMobile(context) ?  AppBar(
        title: const Text('基地信息查看'),
      ) : null,
      body:  NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body:  TabBarView(
              controller: _tabController,
              children: [
                  null != widget.data.id ? ParkBaseScreen(parkId: widget.data.id!, parkName: widget.data.name!,) : const Center(),
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