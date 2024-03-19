import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/market/MarkProduct.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/market/mark_product_edit_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_info_card.dart';
import 'package:agri_manager/src/screens/market/mark_product_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../shared_components/responsive_builder.dart';

class MarkProductShowScreen extends StatefulWidget {
  const MarkProductShowScreen({Key? key}) : super(key: key);

  @override
  State<MarkProductShowScreen> createState() => _MarkProductShowScreenState();
}

class _MarkProductShowScreenState extends State<MarkProductShowScreen> {
  List<MarkProduct> listProduct = [];

  MarkProduct? selectProduct;

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
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.mark_product_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listProduct =
              (retData['content'] as List).map((e) => MarkProduct.fromJson(e)).toList();
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
                  child: null != selectProduct? MarkProductViewScreen(
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
                  child: null != selectProduct? MarkProductViewScreen(
                    data: selectProduct!,
                  ): const Center()),
            ]);
          },
        ));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MarkProductEditScreen()),
    );
  }

  toSelectView(MarkProduct markProduct) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MarkProductViewScreen(data: markProduct)),
    );
  }

  toSelect(MarkProduct markProduct) {
    setState(() {
      selectProduct = markProduct;
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
                          return MarkProductInfoCard(
                              data: listProduct[index],
                              onSelected: () =>
                                  toSelectView(listProduct[index]));
                        } else {
                          return MarkProductInfoCard(
                              data: listProduct[index],
                              onSelected: () => toSelect(listProduct[index]));
                        }
                      })),
            ])));
  }
}
