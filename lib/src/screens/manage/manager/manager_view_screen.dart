import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:znny_manager/src/model/manage/CorpManagerInfo.dart';
import 'package:znny_manager/src/screens/manage/manager/manager_edit_screen.dart';
import 'package:znny_manager/src/shared_components/show_field_text.dart';
import 'package:znny_manager/src/utils/constants.dart';

class ManagerViewScreen extends StatefulWidget {
  final CorpManagerInfo data;

  const ManagerViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ManagerViewScreen> createState() => _ManagerViewScreenState();
}

class _ManagerViewScreenState extends State<ManagerViewScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  /*
  Future loadData() async {
    var params = {'corpId': HttpApi.corpId};

    try {
      var retData =
          await DioUtils().request('${HttpApi.corp_find}${widget.id}', "GET");

      if (retData != null) {
        setState(() {
          _corp = Manager.fromJson(retData);
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

   */

  toEdit(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>   ManagerEditScreen(id: widget.data.id )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FittedBox(
        fit: BoxFit.fill,child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '名称', data: widget.data.nickName ?? '' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '手机号码', data: widget.data.mobile ?? '' ),
                const SizedBox(
                  height: kSpacing,
                ),
                ShowFieldText(title: '描述', data: widget.data.description ?? '' , dataLine: 4,),

                ElevatedButton(
                  style: elevateButtonStyle,
                  onPressed: () {
                    toEdit();
                  },
                  child: const Text('编辑'),
                )
              ],
            ),
          ));
  }
}
