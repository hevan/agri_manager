import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

import '../../model/product/Product.dart';

class ProductInfoCard extends StatelessWidget {
  const ProductInfoCard({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Product data;
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
                  leading: null != data.imageUrl? Image.network('${HttpApi.host_image}${data.imageUrl}', width: 50, height: 50,) : Image.asset('images/product_upload.png', width: 50, height: 50,),
                  title:  Text('${data.name}'),
                  subtitle:  Text('代码：${data.code} 分类：${data.category!.pathName}'),
                ),
              ],
            ),
          ),
        ));
  }
}
