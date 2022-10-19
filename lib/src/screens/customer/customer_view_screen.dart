import 'package:sp_util/sp_util.dart';

import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/customer/Customer.dart';
import 'package:znny_manager/src/net/dio_utils.dart';
import 'package:znny_manager/src/net/exception/custom_http_exception.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/customer/customer_contact_screen.dart';
import 'package:znny_manager/src/screens/customer/customer_link_screen.dart';
import 'package:znny_manager/src/screens/customer/customer_trace_screen.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:dio/dio.dart';

class CustomerViewScreen extends StatefulWidget {
  final int? id;

  const CustomerViewScreen({Key? key, this.id}) : super(key: key);

  @override
  State<CustomerViewScreen> createState() => _CustomerViewScreenState();
}

class _CustomerViewScreenState extends State<CustomerViewScreen> with TickerProviderStateMixin {

  TabController? _tabController;

  Customer _customer = Customer(corpId: HttpApi.corpId, isSupply: false,isCustomer: false);
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
            HttpApi.customer_find + '/' + widget.id!.toString(), "GET");

        if(retData != null) {
          setState(() {
            _customer = Customer.fromJson(retData);
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
        title: Text('${_customer.name}'),
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
                    Expanded(child:  Text('${_customer.name}'), flex:6,)
                 ]),
                  Row(children: [
                    const Expanded(child:  Text('编码:'), flex: 2,),
                    Expanded(child:  Text('${_customer.code}'), flex:6,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('类型:'), flex: 2,),
                    Expanded(child: _customer.isCustomer! ? const Text('客户'): const Text(''), flex:2,),
                    Expanded(child:  _customer.isSupply ! ? const Text('供应商'): const Text(''), flex:2,)
                  ]),
                  Row(children: [
                    const Expanded(child:  Text('描述:'), flex: 2,),
                    Expanded(child:  Text('${_customer.description}'), flex:6,)
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
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body:  TabBarView(
              controller: _tabController,
              children: [
                  null != _customer.name ? CustomerTraceScreen(customerId: _customer.id!, customerName: _customer.name!,) : const Center(),
                  null != _customer.name ? CustomerContractScreen(customerId: _customer.id!, customerName: _customer.name!,) : const Center(),

                  null != _customer.name ? CustomerLinkScreen(customerId: _customer.id!): const Center(),

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