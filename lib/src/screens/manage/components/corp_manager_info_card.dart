import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:znny_manager/src/model/manage/CorpManagerInfo.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CorpManagerInfoCard extends StatelessWidget {
  const CorpManagerInfoCard({
    required this.data,
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  final CorpManagerInfo data;
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
        child:Padding(
        padding: const EdgeInsets.all(kSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                Text('${data.position ?? ''} ${data.nickName}', style: Theme.of(context).textTheme.bodyLarge),
                Text('${data.mobile}', style: TextStyle(fontSize: markTextStyleSize, color: isDark ? Colors.white54 : Colors.black54)),
                Text('${data.description ?? ''}',
                    style:  TextStyle(fontSize: markTextStyleSize, overflow: TextOverflow.ellipsis, color: isDark ? Colors.white54 : Colors.black54)),
          ],
        ),
      ),
      )
    );
  }

  Widget _title(String value) {
    return Text(
      value,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _seeAllButton({required Function() onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: const Text("See All"),
      style: TextButton.styleFrom(primary: kFontColorPallets[1]),
    );
  }
}