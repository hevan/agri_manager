import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/screens/cms/cms_blog_html_view_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_edit_content_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_edit_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../net/dio_utils.dart';
import '../../net/exception/custom_http_exception.dart';
import '../../net/http_api.dart';

class ManageCmsBlogViewScreen extends StatefulWidget {
  final CmsBlogInfo data;

  const ManageCmsBlogViewScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<ManageCmsBlogViewScreen> createState() => _ManageCmsBlogViewScreenState();
}

class _ManageCmsBlogViewScreenState extends State<ManageCmsBlogViewScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }


  toEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ManageCmsBlogEditScreen(id: widget.data.id!.toInt())),
    );
  }

  toEditContent() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ManageCmsBlogContentEditScreen(id: widget.data.id!.toInt())),
    );
  }

  toViewHtml() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CmsBlogHtmlViewScreen(id: widget.data.id!.toInt(), title: widget.data.title!,)),
    );
  }

  Future deleteCategory(num id) async {
    try {
      await DioUtils().request('${HttpApi.cms_blog_delete}${id}', "DELETE");
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(
          msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  ResponsiveBuilder.isMobile(context) ? AppBar(
         title: const Text('资讯查看'),
       ) : null,
        body: FittedBox(
      fit: BoxFit.fill,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '标题', data: widget.data.title ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(title: '作者', data: widget.data.author ?? ''),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
            title: '描述',
            data: widget.data.description ?? '',
            dataLine: 4,
          ),
          const SizedBox(
            height: kSpacing,
          ),
          ShowFieldText(
              title: '分类', data: '${widget.data.categoryName ?? ''}'),
          const SizedBox(
            height: kSpacing,
          ),

          Container(
            height: 300,
            child: null != widget.data.imageUrl ? Image.network('${HttpApi.host_image}${widget.data.imageUrl}') : Image.asset('images/product_upload.png'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  toEdit();
                },
                child: const Text('编辑'),
              ),
              SizedBox(
                width: kSpacing,
              ),
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  toEditContent();
                },
                child: const Text('编辑内容'),
              ),
              SizedBox(
                width: kSpacing,
              ),
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  toViewHtml();
                },
                child: const Text('预览'),
              ),
              SizedBox(
                width: kSpacing,
              ),
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  confirmDeleteDialog(context, widget.data.id!.toInt());
                },
                child: const Text('删除'),
              )
            ],
          ),

        ],
      ),
    ));
  }

  confirmDeleteDialog(BuildContext context, num id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("确定删除"),
          content: const Text("确定要删除该记录吗?，若存在关联数据将无法删除"),
          actions: [
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            ElevatedButton(
              style: elevateButtonStyle,
              onPressed: () async {
                await deleteCategory(id);
              },
              child: const Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
