
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/controller/menu_controller.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/shared_components/today_text.dart';
import 'package:agri_manager/src/utils/constants.dart';


class Header extends StatefulWidget {
  final LoginInfoToken data;
  const Header({
    Key? key,
    required this.data,
  }) : super(key: key);


@override
State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!ResponsiveBuilder.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: context.read<CustomMenuController>().controlMenu,
          ),
        if (!ResponsiveBuilder.isMobile(context))
          const TodayText(),
        if (!ResponsiveBuilder.isMobile(context))
          Spacer(flex: ResponsiveBuilder.isDesktop(context) ? 2 : 1),
        const Expanded(child: SearchField()),
         ProfileCard(data:widget.data)
      ],
    );
  }
}


class ProfileCard extends StatefulWidget {
  final LoginInfoToken data;
  const ProfileCard({
    Key? key,
    required this.data,
  }) : super(key: key);


  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  toSetting(){
    Navigator.pushNamed(
      context,
      '/setting',
    );
  }
  toLogout(){
    SpUtil.clear();
    Navigator.pushNamedAndRemoveUntil(
        context,
        '/login',
        ModalRoute.withName('/home')
    );
  }

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
          widget.data.headerUrl != null ? CircleAvatar(
              radius: 24.0,
              backgroundImage:  NetworkImage('${HttpApi.host_image}${widget.data.headerUrl}') ,
            backgroundColor: Colors.transparent,
          ): Image.asset(
        "assets/images/profile_pic.png"),
          if (!ResponsiveBuilder.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: widget.data.nickName != null ? Text('${widget.data.nickName!}') :  Text('未设置'),
            ),
          PopupMenuButton(onSelected: (result) {
            if (result == 1) {
              toSetting();
            }else {
              toLogout();
            }
          },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Row(children: [
                  const Icon(Icons.settings),
                  Text("设置"),
                ],),
                value: 1,
              ),
              PopupMenuItem(
                child: Row(children: [
                  const Icon(Icons.outbox),
                  Text("退出"),
                ],),
                value: 2,
              )
            ],
            child: const Icon(Icons.keyboard_arrow_down),
          ),

        ],
      ),
    );
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
