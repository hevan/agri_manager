import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/cms/cms_category_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_edit_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_info_card.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import '../../shared_components/responsive_builder.dart';

class ManageBlogScreen extends StatefulWidget {
  const ManageBlogScreen({Key? key}) : super(key: key);

  @override
  State<ManageBlogScreen> createState() => _ManageBlogScreenState();
}

class _ManageBlogScreenState extends State<ManageBlogScreen> {
  List<CmsBlogInfo> listCmsBlog = [];

  CmsBlogInfo selectCmsBlog =  CmsBlogInfo();

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

   setState(() {
     curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
   });

  }

  Future loadData() async {
    var params = {
      'corpId': curCorp?.id,
      'title': '',
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.cms_blog_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listCmsBlog =
              (retData['content'] as List).map((e) => CmsBlogInfo.fromJson(e)).toList();
          selectCmsBlog = listCmsBlog[0];
        });
        debugPrint(json.encode(listCmsBlog));
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
          title: const Text('资讯管理'),
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
                  child: ManageCmsBlogViewScreen(
                    data: selectCmsBlog,
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
                  child: ManageCmsBlogViewScreen(
                    data: selectCmsBlog,
                  )),
            ]);
          },
        ));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageCmsBlogEditScreen()),
    );
  }

  toSelectView(CmsBlogInfo cmsBlog) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ManageCmsBlogViewScreen(data: cmsBlog)),
    );
  }

  toSelect(CmsBlogInfo cmsBlog) {
    setState(() {
      selectCmsBlog = cmsBlog;
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
                      style: primaryButtonStyle,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CmsCategoryScreen()),
                        );
                      },
                      child: const Text('分类管理'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
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
                      itemCount: listCmsBlog.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        if (ResponsiveBuilder.isMobile(context)) {
                          return ManageCmsBlogInfoCard(
                              data: listCmsBlog[index],
                              onSelected: () =>
                                  toSelectView(listCmsBlog[index]));
                        } else {
                          return ManageCmsBlogInfoCard(
                              data: listCmsBlog[index],
                              onSelected: () => toSelect(listCmsBlog[index]));
                        }
                      })),
            ])));
  }
}
