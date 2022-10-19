
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:znny_manager/src/controller/menu_controller.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/responsive.dart';
import 'package:znny_manager/src/shared_components/today_text.dart';
import 'package:znny_manager/src/utils/constants.dart';


class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.data
  }) : super(key: key);

  final UserInfo data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          const TodayText(),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
         ProfileCard(data:data)
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    required this.data,
  }) : super(key: key);
  final UserInfo data;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: defaultPadding),
      padding: const EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          data.headerUrl != null ? CircleAvatar(
              radius: 20.0,
              child: Image.network("${HttpApi.host_image}${data.headerUrl}")) : Image.asset(
            "assets/images/profile_pic.png",
            height: 40,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: data.nickName != null ? Text('${data.nickName!}') :  Text('未设置'),
            ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Row(children: [
                  const Icon(Icons.settings),
                  Text("设置"),
                ],),
                value: 1,
                onTap: _toSetting,
              ),
              PopupMenuItem(
                child: Row(children: [
                  const Icon(Icons.outbox),
                  Text("退出"),
                ],),
                onTap: _logout,
                value: 2,
              )
            ],
            child: const Icon(Icons.keyboard_arrow_down),
          ),

        ],
      ),
    );
  }

  _toSetting(){

  }

  _logout(){

  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: Theme.of(context).canvasColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius:  BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius:  BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/search.svg"),
          ),
        ),
      ),
    );
  }
}
