import 'package:flutter/material.dart';
import 'package:znny_manager/src/utils/constants.dart';

class CustomListTitle extends StatelessWidget {
  const CustomListTitle({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final ImageProvider leading;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: kSpacing),
        child: InkWell(
          onTap: onPressed,
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(right: kSpacing),
              child: CircleAvatar(
                backgroundImage: leading,
                radius: 24,
              ),
            ),
            Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                )),
            Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(
                        trailing,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_forward_ios, size: 24),
                    ),
                  ],
                )),
          ]),
        ));
  }
}
