import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/utils/constants.dart';

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
                Text('${data.name}',
                    style: Theme.of(context).textTheme.bodyLarge),
                Text('${data.code}',
                    style: TextStyle(
                        fontSize: markTextStyleSize,
                        color: isDark ? Colors.white54 : Colors.black54)),
                Text('${data.category!.name}',
                    style: TextStyle(
                        fontSize: markTextStyleSize,
                        overflow: TextOverflow.ellipsis,
                        color: isDark ? Colors.white54 : Colors.black54)),
              ],
            ),
          ),
        ));
  }
}
