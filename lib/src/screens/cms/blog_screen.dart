import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/model/cms/CmsCategory.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/page_model.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/cms/cms_blog_html_video_screen.dart';
import 'package:agri_manager/src/screens/cms/cms_blog_html_view_screen.dart';
import 'package:agri_manager/src/screens/cms/cms_category_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_edit_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_info_card.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_view_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import '../../shared_components/responsive_builder.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen>
    with SingleTickerProviderStateMixin {
  List<CmsBlogInfo> listCmsBlog = [];

  List<CmsCategory> listCategory = [];

  TabController? _tabController;

  CmsBlogInfo selectCmsBlog = CmsBlogInfo();

  PageModel pageModel = PageModel();

  Corp? curCorp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    loadCategory();
  }

  Future loadCategory() async {
    var params = {'corpId': 1};

    try {
      DioUtils().request(
          HttpApi.cms_category_findAll, "GET", queryParameters: params).then((
          res) {
        if (mounted) {
          setState(() {
            listCategory =
                (res as List).map((e) => CmsCategory.fromJson(e)).toList();

            _tabController =
                TabController(length: listCategory.length, vsync: this);

            loadData(listCategory[0].id as int?);
          });
        }
      });
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  Future loadData(int? categoryId) async {
    var params = {
      'categoryId': categoryId,
      'title': '',
      'page': pageModel.page, 'size': pageModel.size
    };

    try {
      var retData = await DioUtils()
          .request(HttpApi.cms_blog_query, "GET", queryParameters: params);
      if (retData != null && null != retData['content']) {
        setState(() {
          listCmsBlog =
              (retData['content'] as List)
                  .map((e) => CmsBlogInfo.fromJson(e))
                  .toList();
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
        body: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return _buildQuery(constraints);
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return   _buildQuery(constraints);
          },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return _buildQuery(constraints);
          }
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
      MaterialPageRoute(
          builder: (context) => ManageCmsBlogViewScreen(data: cmsBlog)),
    );
  }

  toSelect(CmsBlogInfo cmsBlog) {
    setState(() {
      selectCmsBlog = cmsBlog;
    });
  }

  Widget _buildQuery(BoxConstraints viewportConstraints) {
    return listCategory.length > 0 ? NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 200.0,
                      width: double.infinity,
                      color: Colors.grey,
                      child: Image.asset('assets/images/banner_news.png', fit: BoxFit.cover,),
                    )
                  ],
                ),
              ),
              expandedHeight: 260.0,
              bottom: TabBar(
                indicatorColor: Colors.black,
                labelColor: Colors.black,
                tabs: listCategory.map((e) => Tab(text: '${e.name!}')).toList(),
                controller: _tabController,
                onTap: (int index) {
                   loadData(listCategory[index].id as int?);
                },
              ),
            )
          ];
        },
        body: ListView.builder(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: listCmsBlog.length,
          itemBuilder: (context, index) {
            final item = listCmsBlog[index];
            return
              SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.2,
                  child: Row(
                      children: [
                        Expanded(child:
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kSpacing * 2.0,
                    vertical: kSpacing,
                  ),
                  child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          verticalDirection: VerticalDirection.down,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Text(
                                    '${item.title}',
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                            const SizedBox(height: kSpacing,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                details(title: item.publishAt!,
                                    icon: Icons.access_time),
                                details(
                                    title: '${item.countView}',
                                    icon: Icons.visibility_outlined),
                              ],
                            )
                          ],
                        )), flex: 6),
                        Expanded(child:
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kSpacing * 2.0,
                            vertical: kSpacing,
                          ),
                          child: InkWell(
                            onTap: () =>
                            null != item.videoUrl
                                ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CmsBlogHtmlVideoScreen(
                                        title: item.title,
                                        id: item.id,
                                        videoUrl: item.videoUrl
                                    ),
                              ),
                            )
                                : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CmsBlogHtmlViewScreen(
                                      imageUrl: item.imageUrl,
                                      id: item.id,
                                      title: item.title,
                                    ),
                              ),
                            ),
                            child: Hero(
                              tag: listCmsBlog[index],
                              child: Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        '${HttpApi.host_image}${item
                                            .imageUrl}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ), flex: 3)
                      ]));}
                  )): Center();

  }

  details({ required String title, required IconData icon}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
          color: Colors.grey,
        ),
        const SizedBox(width: 3),
        Text(
          title,
        ),
      ],
    );
  }
}
