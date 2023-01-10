import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:znny_manager/src/model/manage/CorpRole.dart';
import 'package:znny_manager/src/screens/manage/depart/corp_depart_edit_screen.dart';
import 'package:znny_manager/src/screens/manage/manager/manager_edit_screen.dart';
import 'package:znny_manager/src/screens/manage/role/corp_role_edit_screen.dart';
import 'package:znny_manager/src/shared_components/show_field_text.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CorpRoleViewScreen extends StatefulWidget {
  final CorpRole data;

  const CorpRoleViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<CorpRoleViewScreen> createState() => _CorpRoleViewScreenState();
}

class _CorpRoleViewScreenState extends State<CorpRoleViewScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  toEdit(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>   CorpRoleEditScreen(id: widget.data.id )),
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
                ShowFieldText(title: '名称', data: widget.data.name ?? '' ),
                const SizedBox(
                  height: kSpacing,
                ),

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
