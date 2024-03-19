import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/customer/Customer.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';


class CustomerInfoCard extends StatelessWidget {
  const CustomerInfoCard({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final Customer data;
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
                  title:  Text('${data.name}'),
                  subtitle:  Text('${data.managerName} ${data.managerMobile}'),
                ),
              ],
            ),
          ),
        ));
  }
}
