import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/model/product/Product.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/product/product_edit_screen.dart';
import 'package:agri_manager/src/screens/product/product_info_card.dart';
import 'package:agri_manager/src/screens/product/product_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../shared_components/responsive_builder.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> listProduct = [];

  Product? selectProduct;

  PageModel pageModel = PageModel();

  Corp? curCorp;

  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    Map? mapCorpSelect = SpUtil.getObject(Constant.currentCorp);

    debugPrint(json.encode(mapCorpSelect));
    if (null != mapCorpSelect && mapCorpSelect.isNotEmpty) {
      setState(() {
        curCorp = Corp.fromJson(mapCorpSelect);
      });
    }

  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'userId': '',
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.product_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listProduct =
              (retData['content'] as List).map((e) => Product.fromJson(e)).toList();
          selectProduct = listProduct[0];
        });
        debugPrint(json.encode(listProduct));
        debugPrint(json.encode(retData));
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
          title: const Text('产品管理'),
        ),
        body: ResponsiveBuilder(
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
                  child: null != selectProduct? ProductViewScreen(
                    data: selectProduct!,
                  ): const Center()),
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
                  child: null != selectProduct? ProductViewScreen(
                    data: selectProduct!,
                  ): const Center()),
            ]);
          },
        ));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductEditScreen()),
    );
  }

  toSelectView(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductViewScreen(data: product)),
    );
  }

  toSelect(Product product) {
    setState(() {
      selectProduct = product;
    });
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
                      itemCount: listProduct.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (ResponsiveBuilder.isMobile(context)) {
                          return ProductInfoCard(
                              data: listProduct[index],
                              onSelected: () =>
                                  toSelectView(listProduct[index]));
                        } else {
                          return ProductInfoCard(
                              data: listProduct[index],
                              onSelected: () => toSelect(listProduct[index]));
                        }
                      })),
            ])));
  }
}
