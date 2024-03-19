library dashboard;


import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/controller/menu_controller.dart';
import 'package:agri_manager/src/model/ConstType.dart';
import 'package:agri_manager/src/model/business/CheckApply.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/project/BatchCycle.dart';
import 'package:agri_manager/src/model/project/BatchProduct.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/cms/cms_blog_html_view_screen.dart';
import 'package:agri_manager/src/screens/dashboard/components/blog_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/corp_show_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/progress_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/progress_report_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/project_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/project_total_card.dart';
import 'package:agri_manager/src/screens/dashboard/components/task_card.dart';
import 'package:agri_manager/src/shared_components/chatting_card.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

import 'components/header.dart';
import 'components/side_menu.dart';

part './components/active_project_card.dart';
part './components/overview_header.dart';
part './components/recent_messages.dart';
part './components/team_member.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  LoginInfoToken userInfo = new LoginInfoToken();

  List<CmsBlogInfo> listBlogInfo = [];

  List<Corp> listCorp = [];

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('zh_CN');
    setState(() {
      userInfo =
          LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });

    loadData();
  }

  loadData(){
     loadCorp();
     loadBlog();
  }

  Future loadCorp() async{
    var params = {'userId': userInfo?.userId};

    try {
      var retData = await DioUtils().request(
          HttpApi.corp_find_by_user, "GET", queryParameters: params);
      if(retData != null ) {
        setState(() {
          listCorp = (retData as List).map((e) => Corp.fromJson(e)).toList();
        });
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

      Future loadBlog() async{
        var params = {'status': 1, 'page': 0, 'size':10};

        try {
          var retData = await DioUtils().request(
              HttpApi.cms_blog_query, "GET", queryParameters: params);
          if(retData != null && null != retData['content']) {
            setState(() {
              listBlogInfo = (retData['content'] as List).map((e) => CmsBlogInfo.fromJson(e)).toList();
            });
          }
        } on DioError catch(error) {
          CustomAppException customAppException = CustomAppException.create(error);
          debugPrint(customAppException.getMessage());
        }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<CustomMenuController>().scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : const Drawer(
              child: SideMenu(),
            ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return SafeArea(child:Column(children: [
              Header(
                data: userInfo
              ),
              const SizedBox(height: kSpacing / 2),
              _showCorpCard(data: listCorp, crossAxisCount: 1),
              _buildBlogs(data: listBlogInfo),
            ]));
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              Header(
                data: userInfo
              ),
              const SizedBox(height: kSpacing / 2),
              _showCorpCard(data: listCorp, crossAxisCount: 2),
              const SizedBox(height: kSpacing / 2),
              _buildBlogs(data: listBlogInfo)
            ]);
          },
          desktopBuilder: (context, constraints) {
            return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Flexible(
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(kBorderRadius),
                        bottomRight: Radius.circular(kBorderRadius),
                      ),
                      child: SideMenu()),
                  flex: (constraints.maxWidth < 1360) ? 4 : 3),
              Flexible(
                  child: Column(children: [
                    Header(
                      data: userInfo,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(child: Column(children: [
                          const SizedBox(height: kSpacing / 2),
                          _showCorpCard(data: listCorp, crossAxisCount: 2),
                        ],), flex: 10,),
                        Flexible(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          const SizedBox(height: kSpacing / 2),
                           _buildBlogs(data: listBlogInfo),
                        ],), flex: 4,),
                      ],
                    )
                  ]),
                  flex: 14)

            ]);
          },
        ),
      ));
  }




  Widget _showCorpCard({
    required List<Corp> data,
    int crossAxisCount = 2,
  }) {
    return   MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return CorpShowCard(data: data[index], onPressedCheck: (){
              SpUtil.putObject(Constant.currentCorp, data[index].toJson());

              Navigator.of(context).pushNamed('/managerDashboard');
              });
          }
    );
  }

  Widget _buildBlogs({required List<CmsBlogInfo> data}) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing),
            child:Row(
              children: [
                Icon(EvaIcons.paperPlaneOutline, color: isDark ? Colors.white70 : Theme.of(context).primaryColor),
                const SizedBox(width: 10),
                Text(
                    "最新动态"
                ),
                const Spacer(),
                IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(EvaIcons.moreVertical),
                  tooltip: "more",
                )
              ],
            ),
          ),
          const SizedBox(height: kSpacing / 2),
          ...data
              .map(
                (e) => BlogCard(data: e,  onPressedCheck: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CmsBlogHtmlViewScreen(id: e.id!, title: e.title!,)),
                  );
                },),
          )
              .toList(),
        ]);
  }
}
