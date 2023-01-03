import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:znny_manager/src/model/manage/UserInfo.dart';
import 'package:znny_manager/src/net/http_api.dart';
import 'package:znny_manager/src/screens/login_signup/reset_password.dart';
import 'package:znny_manager/src/screens/login_signup/user_profile_update.dart';
import 'package:znny_manager/src/shared_components/custom_list_title.dart';
import 'package:znny_manager/src/utils/agri_util.dart';
import 'package:znny_manager/src/utils/constants.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  static const routeName = '/settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}
class _SettingsViewState extends State<SettingsView> {

  UserInfo userInfo = UserInfo();

  @override
  void initState() {
    super.initState();


    loadData();

  }

  Future loadData() async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('设置'),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Container(
                    padding: const EdgeInsets.all(defaultPadding),
                    constraints: const BoxConstraints(
                      maxWidth: 600,
                    ),
                    child: Column(children: [
                       CustomListTitle(
                        leading: userInfo.headerUrl != null ? Image.network("${HttpApi.host_image}${userInfo.headerUrl}").image : const AssetImage('images/raster/avatar-3.png'),
                        title: '${userInfo.nickName}',
                        subtitle: AgriUtil.hideMobile(userInfo.mobile),
                        trailing: userInfo.nickName == null || userInfo.headerUrl == null ? '未设置':'',
                         onPressed: (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) =>  UserProfileUpdate(userInfo: userInfo)),
                           );
                         },
                      ),
                      const SizedBox(height: 2),
                      CustomListTitle(
                        leading: const AssetImage('icons/icon_security.png'),
                        title: '密码设置',
                        subtitle: '',
                        trailing: '',
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  ResetPassword(userId: userInfo.id!,)),
                          ).then((value) => loadData());
                        },
                      ),
                      const SizedBox(height: 2),
                      CustomListTitle(
                        leading: const AssetImage('icons/icon_theme.png'),
                        title: '界面样式',
                        subtitle: '',
                        trailing: '',
                        onPressed: (){
                          AdaptiveTheme.of(context).toggleThemeMode();
                        },
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(30.0),
                          onTap: logout,
                          child: Container(
                            height: 50.0,
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.blue[300]!.withOpacity(0.8),
                                  Colors.blue[500]!.withOpacity(0.8),
                                  Colors.blue[800]!.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: const Text(
                              '退出',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])))));
  }

  logout(){
    SpUtil.clear();
    Navigator.of(context).popAndPushNamed("/login");
  }
}
