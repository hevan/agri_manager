import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/customer/Customer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/customer/customer_contact_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_edit_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_link_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_trace_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CustomerViewScreen extends StatefulWidget {
  final Customer data;

  const CustomerViewScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<CustomerViewScreen> createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> with TickerProviderStateMixin {

  TabController? _tabController;

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


    setState(() {
      userId = SpUtil.getInt(Constant.userId);
    });
  }

  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerEditScreen(id: widget.data.id)),
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
                    const Expanded(child:  Text('编码:'), flex: 2,),
                    Expanded(child:  Text('${widget.data.code}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('类型:'), flex: 2,),
                    Expanded(child: widget.data.isCustomer! ? const Text('客户'): const Text(''), flex:3,),
                    Expanded(child:  widget.data.isSupply ! ? const Text('供应商'): const Text(''), flex:3,)
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
              text: "跟进记录",
            ),
             Tab(
              text: "合约",
            ),
             Tab(
              text: "联系人",
            ),
          ],
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     appBar: ResponsiveBuilder.isMobile(context) ?  AppBar(
        title: const Text('客户信息查看'),
      ) : null,
      body: null != widget.data.id ? SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body:  TabBarView(
              controller: _tabController,
              children: [
                  null != widget.data.id ? CustomerTraceScreen(customerId: widget.data.id!, customerName: widget.data.name!,) : const Center(),
                  null != widget.data.id ? CustomerContractScreen(customerId: widget.data.id!, customerName: widget.data.name!,) : const Center(),

                  null != widget.data.id ? CustomerLinkScreen(customerId: widget.data.id!): const Center(),

              ],
            ),
          )): Center(),
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