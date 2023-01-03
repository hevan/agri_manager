import 'package:flutter/material.dart';
import 'package:znny_manager/src/shared_components/chart_percent_indicator.dart';
import 'package:znny_manager/src/utils/constants.dart';

class BlogData {
  final int viewCount;
  final String title;
  final String category;
  final String imageUrl;
  final String publishAt;

  const BlogData({
    required this.viewCount,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.publishAt,
  });
}

class BlogCard extends StatelessWidget {
  const BlogCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final BlogData data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kSpacing),
                    child: Image.asset("assets/images/flutter_logo.png"),
                  ),
                  const SizedBox(height: kSpacing,),
                  Text(
                    '${data.title}',
                    style: const TextStyle( overflow: TextOverflow.ellipsis,),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${data.category}', style: const TextStyle(fontSize: miniTextStyleSize),),
                      Text('${data.viewCount}', style: const TextStyle(fontSize: miniTextStyleSize),),
                      Text('${data.publishAt}', style: const TextStyle(fontSize: miniTextStyleSize),)
                    ],
                  )
                ],
              ),);
  }
}
