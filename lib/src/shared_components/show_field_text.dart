import 'package:flutter/material.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class ShowFieldText extends StatelessWidget {

  final String title;
  final String data;
  final int  dataLine;

  const ShowFieldText({Key? key, required this.title, required this.data, this.dataLine = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 3,child: Text(title, style:TextStyle( color: isDark ? Colors.white54 : Colors.black54)),),
          const SizedBox(width: kSpacing * 2,),
         Flexible(flex: 8,child: Text(data, overflow: TextOverflow.ellipsis,maxLines: dataLine,),),
        ],
      ),
    );
  }
}
