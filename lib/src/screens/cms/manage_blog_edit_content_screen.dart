import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/cms/CmsBlog.dart';
import 'package:agri_manager/src/model/cms/CmsCategory.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:html_editor_enhanced/html_editor.dart';


class ManageCmsBlogContentEditScreen extends StatefulWidget {
  final int? id;

  const ManageCmsBlogContentEditScreen({Key? key, this.id}) : super(key: key);

  @override
  State<ManageCmsBlogContentEditScreen> createState() => _ManageCmsBlogContentEditScreenState();
}

class _ManageCmsBlogContentEditScreenState extends State<ManageCmsBlogContentEditScreen> {

  String result = '';
  final HtmlEditorController controller = HtmlEditorController();


  CmsBlog _cmsBlog = CmsBlog();
  LoginInfoToken? userInfo;
  Corp? curCorp;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    
    setState(() {
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
      curCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
    });

    loadData();

  }

  Future loadData() async {


    if (widget.id != null) {
      try {
        var retData = await DioUtils()
            .request(HttpApi.cms_blog_find + widget.id!.toString(), "GET");

        if (retData != null) {
          setState(() {
            _cmsBlog = CmsBlog.fromJson(retData);
            if(null != _cmsBlog.content) {
              controller.setText(_cmsBlog.content!);
            }
          });
        }
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
        Fluttertoast.showToast(
            msg: customAppException.getMessage(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 6);
      }
    }
  }

  Future save() async {

    try {

       _cmsBlog.content = await controller.getText();
        var retData = await DioUtils().request('${HttpApi.cms_blog_update}${widget.id}', "PUT",
            data: json.encode(_cmsBlog), isJson: true);
        if (retData != null) {
          Navigator.of(context).pop();
        }

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
      appBar: AppBar(
        title: const Text('资讯内容编辑'),
      ),
      body: SingleChildScrollView(
        child:  Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                HtmlEditor(
                  controller: controller,
                  htmlEditorOptions: HtmlEditorOptions(
                    hint: 'Your text here...',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed:
                        (ButtonType type, bool? status, Function? updateStatus) {

                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      print(
                          "dropdown  changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      print(url);
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      print(file.name); //filename
                      print(file.size); //size in bytes
                      print(file.extension); //file extension (eg jpeg or mp4)
                      return true;
                    },
                  ),
                  otherOptions: OtherOptions(height: 550),
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    print('html before change is $currentHtml');
                  }, onChangeContent: (String? changed) {
                    print('content changed to $changed');
                  }, onChangeCodeview: (String? changed) {
                    print('code changed to $changed');
                  }, onChangeSelection: (EditorSettings settings) {
                    print('parent element is ${settings.parentElement}');
                    print('font name is ${settings.fontName}');
                  }, onDialogShown: () {
                    print('dialog shown');
                  }, onEnter: () {
                    print('enter/return pressed');
                  }, onFocus: () {
                    print('editor focused');
                  }, onBlur: () {
                    print('editor unfocused');
                  }, onBlurCodeview: () {
                    print('codeview either focused or unfocused');
                  }, onInit: () {
                    print('init');
                  },
                      //this is commented because it overrides the default Summernote handlers
                      /*onImageLinkInsert: (String? url) {
                    print(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    print(file.name);
                    print(file.size);
                    print(file.type);
                    print(file.base64);
                  },*/
                      onImageUploadError: (FileUpload? file, String? base64Str,
                          UploadError error) {
                        print(base64Str ?? '');
                        if (file != null) {
                          print(file.name);
                          print(file.size);
                          print(file.type);
                        }
                      }, onKeyDown: (int? keyCode) {
                        print('$keyCode key downed');
                        print(
                            'current character count: ${controller.characterCount}');
                      }, onKeyUp: (int? keyCode) {
                        print('$keyCode key released');
                      }, onMouseDown: () {
                        print('mouse downed');
                      }, onMouseUp: () {
                        print('mouse released');
                      }, onNavigationRequestMobile: (String url) {
                        print(url);
                        return NavigationActionPolicy.ALLOW;
                      }, onPaste: () {
                        print('pasted into editor');
                      }, onScroll: () {
                        print('editor scrolled');
                      }),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          print(value);
                        }),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          controller.undo();
                        },
                        child:
                        Text('取消操作', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey),
                        onPressed: () {
                          controller.clear();
                        },
                        child:
                        Text('清空', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                        onPressed: () async {
                          var txt = await controller.getText();
                          if (txt.contains('src=\"data:')) {
                            txt =
                            '<text removed due to base-64 data, displaying the text could cause the app to crash>';
                            Fluttertoast.showToast(
                                msg: '请取消源代码的展示',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 6);
                            return;
                          }

                          save();

                        },
                        child: Text(
                          '提交',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                            Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          controller.redo();
                        },
                        child: Text(
                          '还原操作',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: kSpacing,
                )
              ],
            ),

      ),
    );
  }

  Future uploadImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withReadStream: true);
    if (result != null) {
      //log(result.files.first.name);
      //File file = File(result.files.first.name);
      log('start to load ');
      try {
        //print('start to upload');r
        PlatformFile pFile = result.files.single;
        var formData = FormData.fromMap({
          'userId': userInfo?.userId,
          'corpId': curCorp?.id,
          'file': MultipartFile(
              pFile.readStream as Stream<List<int>>, pFile.size,
              filename: pFile.name)
        });

        var ret = await DioUtils()
            .requestUpload(HttpApi.open_gridfs_upload, data: formData);
        // print(json.encode(ret));
        setState(() {
          _cmsBlog.imageUrl = ret['id'];
        });
      } on DioError catch (error) {
        CustomAppException customAppException =
            CustomAppException.create(error);
        debugPrint(customAppException.getMessage());
      }
    } else {
      // User canceled the picker
    }
  }

  String basename(String path) {
    return path.substring(path.lastIndexOf('/') + 1);
  }
}
