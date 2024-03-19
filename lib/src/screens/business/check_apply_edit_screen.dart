import 'dart:convert';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/business/CheckApply.dart';
import 'package:agri_manager/src/model/business/CheckManager.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_select_screen.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/agri_util.dart';
import 'package:dio/dio.dart';
import 'package:agri_manager/src/utils/constants.dart';

class CheckApplyEditScreen extends StatefulWidget {
  final int entityId;
  final String entityName;
  final String title;
  final int userId;

  const CheckApplyEditScreen(
      {Key? key,
      required this.entityId,
        required this.userId,
      required this.entityName,
      required this.title})
      : super(key: key);

  @override
  State<CheckApplyEditScreen> createState() => _CheckApplyEditScreenState();
}

class _CheckApplyEditScreenState extends State<CheckApplyEditScreen> {
  List<CheckManager> listManager = [];

  Corp? currentCorp;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });
  }

  Future toSaveApply() async{

    if(listManager.length == 0){
      Fluttertoast.showToast(
          msg: "请选择审核的人员",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 16);
      return;
    }
    CheckApply  checkApply = CheckApply();
    checkApply.status = 1;
    checkApply.entityId = widget.entityId;
    checkApply.entityName = widget.entityName;
    checkApply.title = widget.title;
    checkApply.corpId = currentCorp?.id;
    checkApply.userId = widget.userId;

    checkApply.listCheckManager = listManager;
    checkApply.checkUsers = json.encode(listManager);
    
    try {
      var retData = await DioUtils().request(
          HttpApi.check_apply_add, "POST", data: json.encode(checkApply), isJson: true);
      if(retData != null) {
        Fluttertoast.showToast(
            msg: '提交成功',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 16);
          Navigator.of(context).pop();
      }
    } on DioError catch(error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('单据审核')),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ShowFieldText(title: '单据名称:', data: widget.title ?? ''),
              const SizedBox(
                height: kSpacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: elevateButtonStyle,
                    onPressed: () async {
                      String retData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ManagerSelectScreen(),
                              fullscreenDialog: true));
                      if (retData != null) {
                        // ignore: curly_braces_in_flow_control_structures
                        setState(() {
                          var retDataMap = json.decode(retData);
                          CheckManager curCheck = CheckManager.fromJson(retDataMap);
                          curCheck.status = 0;
                          listManager.add(curCheck);
                        });
                      }
                    },
                    child: const Text('添加审核人员'),
                  ),
                  SizedBox(
                    width: kSpacing,
                  ),
                  ElevatedButton(
                    style: elevateButtonStyle,
                    onPressed: () {
                      toSaveApply();
                    },
                    child: const Text('确定提交审核'),
                  ),
                ],
              ),
              GridView.count(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 8.0,
                  children: List.generate(listManager.length, (index) {
                    return ShowManagerCard(
                        manager: listManager[index],
                        onUnselect: () {
                          setState(() {
                            listManager.removeAt(index);
                          });
                        },
                      );
                  })),
            ],
          ),
        ));
  }
}

class ShowManagerCard extends StatelessWidget {
  const ShowManagerCard(
      {Key? key, required this.manager, required this.onUnselect})
      : super(key: key);
  final CheckManager manager;
  final Function() onUnselect;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                  leading: null != manager.headerUrl
                      ? CircleAvatar(
                          radius: 24.0,
                          backgroundImage: NetworkImage(
                              '${HttpApi.host_image}${manager.headerUrl}'),
                          backgroundColor: Colors.transparent,
                        )
                      : const CircleAvatar(
                          radius: 24.0,
                          backgroundImage:
                              AssetImage('images/product_upload.png'),
                          backgroundColor: Colors.transparent,
                        ),
                  title: Text('${manager.nickName}')),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  child: Icon(Icons.close, size: 30.0, color: Colors.redAccent),
                  onTap: onUnselect,
                ),
              ),
            ]));
  }
}
