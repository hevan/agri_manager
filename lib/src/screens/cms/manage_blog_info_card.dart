import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';


class ManageCmsBlogInfoCard extends StatelessWidget {
  const ManageCmsBlogInfoCard({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final CmsBlogInfo data;
  final Function() onSelected;

  @override
  Widget build(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: InkWell(
          onTap: onSelected,
          child: Padding(
            padding: const EdgeInsets.all(kSpacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: null != data.imageUrl? Image.network('${HttpApi.host_image}${data.imageUrl}') : Image.asset('images/product_upload.png'),
                  title:  Text('${data.title}'),
                  subtitle:  Text('分类：${data.categoryName}'),
                ),
              ],
            ),
          ),
        ));
  }
}
