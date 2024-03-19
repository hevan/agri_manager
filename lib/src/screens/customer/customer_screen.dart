import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/customer/Customer.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/customer/customer_info_card.dart';
import 'package:agri_manager/src/screens/customer/customer_view_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

import 'customer_edit_screen.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  List<Customer> listData = [];

  PageModel pageModel = PageModel();

  Customer selectCustomer =  Customer();

  Corp? curCorp;
  LoginInfoToken? userInfo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    setState(() {
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    loadData();
  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'name': '',
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils().request(
          HttpApi.customer_query, "GET",
          queryParameters: params);
      if (retData != null) {
        print(retData);
        setState(() {
          listData =
              (retData['content'] as List).map((e) => Customer.fromJson(e)).toList();

          if(listData.length > 0) {
            selectCustomer = listData[0];
          }
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
        appBar: AppBar(
          title: const Text('客户管理'),
        ),
        body:  ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return _buildQuery(constraints);
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return Row(children: [
              Flexible(flex: 4, child: _buildQuery(constraints)),
              SizedBox(
                width: 15,
                height: constraints.maxHeight,
              ),
              Flexible(
                  flex: 4,
                  child: CustomerViewScreen(
                    data: selectCustomer,
                  )),
            ]);
          },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return Row(children: [
              Flexible(flex: 4, child: _buildQuery(constraints)),
              SizedBox(
                width: 15,
                height: constraints.maxHeight,
              ),
              Flexible(
                  flex: 6,
                  child: CustomerViewScreen(
                    data: selectCustomer,
                  )),
            ]);
          },
        ));
  }

  Widget _buildQuery(BoxConstraints viewportConstraints) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // A fixed-height child.
                    height: 80.0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: kSpacing, right: kSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: secondButtonStyle,
                          onPressed: () {
                            loadData();
                          },
                          child: const Text('查询'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: primaryButtonStyle,
                          onPressed: toAdd,
                          child: const Text('增加'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: listData.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (ResponsiveBuilder.isMobile(context)) {
                              return CustomerInfoCard(
                                  data: listData[index],
                                  onSelected: () =>
                                      toSelectView(listData[index]));
                            } else {
                              return CustomerInfoCard(
                                  data: listData[index],
                                  onSelected: () => toSelect(listData[index]));
                            }
                          })),
                ])));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerEditScreen()),
    );
  }

  toSelectView(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CustomerViewScreen(data: customer)),
    );
  }

  toSelect(Customer customer) {
    setState(() {
      selectCustomer = customer;
    });
  }

}
