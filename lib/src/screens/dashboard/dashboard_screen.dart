library dashboard;


import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/controller/menu_controller.dart';
import 'package:znny_manager/src/model/ConstType.dart';
import 'package:znny_manager/src/model/sys/LoginInfoToken.dart';
import 'package:znny_manager/src/screens/dashboard/components/blog_card.dart';
import 'package:znny_manager/src/screens/dashboard/components/progress_card.dart';
import 'package:znny_manager/src/screens/dashboard/components/progress_report_card.dart';
import 'package:znny_manager/src/screens/dashboard/components/project_card.dart';
import 'package:znny_manager/src/screens/dashboard/components/project_total_card.dart';
import 'package:znny_manager/src/screens/dashboard/components/task_card.dart';
import 'package:znny_manager/src/shared_components/chatting_card.dart';
import 'package:znny_manager/src/shared_components/responsive_builder.dart';
import 'package:znny_manager/src/utils/constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('zh_CN');
    setState(() {
      userInfo =
          LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: (ResponsiveBuilder.isDesktop(context))
          ? null
          : const Drawer(
              child: SideMenu(),
            ),
      body: SingleChildScrollView(
        child: ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return Column(children: [
              Header(
                data: userInfo,
              ),
              const SizedBox(height: kSpacing / 2),
              _buildProgress(axis: Axis.vertical),
              _buildActiveProject(
                data: getActiveProject(),
                crossAxisCount: 3,
                crossAxisCellCount: 3,
              ),
              const SizedBox(height: kSpacing / 2),
              _buildRecentMessages(data: messageData),
              _buildBlogs(data: listBlog),
            ]);
          },
          tabletBuilder: (context, constraints) {
            return Column(children: [
              Header(
                data: userInfo,
              ),
              const SizedBox(height: kSpacing / 2),
              _buildProgress(axis: Axis.vertical),
              _buildActiveProject(
                data: getActiveProject(),
                crossAxisCount: 3,
                crossAxisCellCount: (constraints.maxWidth < 950)
                    ? 3
                    : (constraints.maxWidth < 1100)
                    ? 3
                    : 2,
              ),
              const SizedBox(height: kSpacing / 2),
              _buildRecentMessages(data: messageData),
              _buildBlogs(data: listBlog)
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
                          _buildProgress(axis: Axis.horizontal),
                          _buildActiveProject(
                            data: getActiveProject(),
                            crossAxisCount: 3,
                            crossAxisCellCount: (constraints.maxWidth < 1360) ? 3 : 2,
                          ),
                          _OverviewHeader(onSelected: (TaskType? taskType) {}),
                          _buildTaskOverview(data:getAllTask(), crossAxisCount: 2),
                        ],), flex: 10,),
                        Flexible(child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          const SizedBox(height: kSpacing / 2),
                          _buildRecentMessages(data: messageData),
                            _buildBlogs(data: listBlog),
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

  Widget _buildProgress({Axis axis = Axis.horizontal}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing / 2),
        child: (axis == Axis.horizontal)
            ? Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: ProgressCard(
                      data: const ProgressCardData(
                        totalUndone: 10,
                        totalTaskInProress: 2,
                      ),
                      onPressedCheck: () {},
                    ),
                  ),
                  const SizedBox(width: kSpacing / 2),
                  const Flexible(
                    flex: 5,
                    child: ProgressReportCard(
                      data: ProgressReportCardData(
                        title: "任务统计",
                        doneTask: 5,
                        percent: .3,
                        task: 3,
                        undoneTask: 2,
                      ),
                    ),
                  ),
                  const SizedBox(width: kSpacing / 2),
                   Flexible(
                    flex: 5,
                    child:  ProjectTotalCard(
                      data: ProjectTotalData(
                        totalUndone: 3,
                        percent: .3,
                        totalDone: 5,
                        totalInProgress: 2,
                      ),
                        onPressedCheck: () {},
                    ),
                  ),
                  const SizedBox(width: kSpacing / 2),
                  const Flexible(
                    flex: 5,
                    child: ProgressReportCard(
                      data: ProgressReportCardData(
                        title: "审核统计",
                        doneTask: 5,
                        percent: .3,
                        task: 3,
                        undoneTask: 2,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Row(children: [
                    Flexible(
                      flex: 5,
                      child: ProgressCard(
                        data: const ProgressCardData(
                          totalUndone: 10,
                          totalTaskInProress: 2,
                        ),
                        onPressedCheck: () {},
                      ),
                    ),
                    const SizedBox(width: kSpacing / 2),
                    const Flexible(
                      flex: 5,
                      child: ProgressReportCard(
                        data: ProgressReportCardData(
                          title: "任务统计",
                          doneTask: 5,
                          percent: .3,
                          task: 3,
                          undoneTask: 2,
                        ),
                      ),
                    )
                  ]),
                  Row(children: [
                    Flexible(
                      flex: 5,
                      child:  ProjectTotalCard(
                        data: const ProjectTotalData(
                          totalUndone: 3,
                          percent: .3,
                          totalDone: 5,
                          totalInProgress: 2,
                        ),
                        onPressedCheck: () {},
                      ),
                    ),
                    const SizedBox(width: kSpacing / 2),
                    const Flexible(
                      flex: 5,
                      child: ProgressReportCard(
                        data: ProgressReportCardData(
                          title: "审核单据",
                          doneTask: 5,
                          percent: .3,
                          task: 3,
                          undoneTask: 2,
                        ),
                      ),
                    )
                  ])
                ],
              ));
  }

  List<TaskCardData> getAllTask() {
    return [
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 2,
        totalComments: 50,
        type: TaskType.todo,
        totalContributors: 30,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar1),
          AssetImage(ImageRasterPath.avatar2),
          AssetImage(ImageRasterPath.avatar3),
          AssetImage(ImageRasterPath.avatar4),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: -1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.inProgress,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar5),
          AssetImage(ImageRasterPath.avatar6),
          AssetImage(ImageRasterPath.avatar7),
          AssetImage(ImageRasterPath.avatar8),
        ],
      ),
      const TaskCardData(
        title: "Landing page UI Design",
        dueDay: 1,
        totalComments: 50,
        totalContributors: 34,
        type: TaskType.done,
        profilContributors: [
          AssetImage(ImageRasterPath.avatar5),
          AssetImage(ImageRasterPath.avatar3),
          AssetImage(ImageRasterPath.avatar4),
          AssetImage(ImageRasterPath.avatar2),
        ],
      ),
    ];
  }

  Widget _buildTaskOverview({
    required List<TaskCardData> data,
    int crossAxisCount = 3,
    Axis headerAxis = Axis.horizontal,
  }) {
    return MasonryGridView.count(
      crossAxisCount: crossAxisCount,
      itemCount: data.length,
      addAutomaticKeepAlives: false,
      padding: const EdgeInsets.symmetric(horizontal: kSpacing),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return TaskCard(
          data: data[index],
          onPressedMore: () {},
          onPressedTask: () {},
          onPressedContributors: () {},
          onPressedComments: () {},
        );
      }
    );
  }

  List<ProjectCardData> getActiveProject() {
    return [
      ProjectCardData(
        percent: .3,
        projectImage: const AssetImage(ImageRasterPath.logo2),
        projectName: "Taxi Online",
        releaseTime: DateTime.now().add(const Duration(days: 130)),
      ),
      ProjectCardData(
        percent: .5,
        projectImage: const AssetImage(ImageRasterPath.logo3),
        projectName: "E-Movies Mobile",
        releaseTime: DateTime.now().add(const Duration(days: 140)),
      ),
      ProjectCardData(
        percent: .8,
        projectImage: const AssetImage(ImageRasterPath.logo4),
        projectName: "Video Converter App",
        releaseTime: DateTime.now().add(const Duration(days: 100)),
      ),
    ];
  }


  Widget _buildActiveProject({
    required List<ProjectCardData> data,
    int crossAxisCount = 3,
    int crossAxisCellCount = 2,
  }) {
    return  _ActiveProjectCard(
        onPressedSeeAll: () {},
        child: MasonryGridView.count(
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          itemCount: data.length,
          addAutomaticKeepAlives: false,
          mainAxisSpacing: kSpacing,
          crossAxisSpacing: kSpacing,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return ProjectCard(data: data[index]);
          }
        ),
    );
  }

  final List<ChattingCardData> messageData =
    [
       const ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar6),
        isOnline: true,
        name: "Samantha",
        lastMessage: "i added my new tasks",
        isRead: false,
        totalUnread: 100,
      ),
      const ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar3),
        isOnline: false,
        name: "John",
        lastMessage: "well done john",
        isRead: true,
        totalUnread: 0,
      ),
      const ChattingCardData(
        image: AssetImage(ImageRasterPath.avatar4),
        isOnline: true,
        name: "Alexander Purwoto",
        lastMessage: "we'll have a meeting at 9AM",
        isRead: false,
        totalUnread: 1,
      ),
    ];

  final List<BlogData> listBlog =[
    const BlogData(viewCount: 50, title: '农业一号文件解读', category: '农业', imageUrl: 'sss', publishAt: '2022-12-11'),
    const BlogData(viewCount: 30, title: '养殖水处理标准', category: '农业', imageUrl: 'sss', publishAt: '2022-12-11'),
    const BlogData(viewCount: 30, title: '机械种植', category: '农业', imageUrl: 'sss', publishAt: '2022-12-11'),
  ];

  Widget _buildRecentMessages({required List<ChattingCardData> data}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacing),
        child: _RecentMessages(onPressedMore: () {}),
      ),
      const SizedBox(height: kSpacing / 2),
      ...data
          .map(
            (e) => ChattingCard(data: e, onPressed: () {}),
      )
          .toList(),
    ]);
  }

  Widget _buildBlogs({required List<BlogData> data}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kSpacing),
            child: _RecentMessages(onPressedMore: () {}),
          ),
          const SizedBox(height: kSpacing / 2),
          ...data
              .map(
                (e) => BlogCard(data: e,  onPressedCheck: () {  },),
          )
              .toList(),
        ]);
  }
}
