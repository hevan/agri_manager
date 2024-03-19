import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/cms/CmsBlogInfo.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/utils/constants.dart';

class BlogCard extends StatelessWidget {
  const BlogCard({
    required this.data,
    required this.onPressedCheck,
    Key? key,
  }) : super(key: key);

  final CmsBlogInfo data;
  final Function() onPressedCheck;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(kSpacing),
      child: Padding(
          padding: const EdgeInsets.all(kSpacing / 2),
          child: InkWell(
            onTap: onPressedCheck,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: kSpacing,
              ),
              Row(children: [
                Expanded(
                    child: Text(
                      '${data.title}',
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    flex: 6),
                Expanded(
                  child: Container(
                    child: Image.network(
                      '${HttpApi.host_image}${data.imageUrl}',
                      fit: BoxFit.cover,
                      height: 80,
                      width: 120,
                    ),
                  ),
                  flex: 4,
                )
              ]),
              const SizedBox(
                height: kSpacing,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data.categoryName}',
                    style: const TextStyle(fontSize: miniTextStyleSize),
                  ),
                  Text(
                    '${data.countView}',
                    style: const TextStyle(fontSize: miniTextStyleSize),
                  ),
                  Text(
                    '${data.publishAt}',
                    style: const TextStyle(fontSize: miniTextStyleSize),
                  )
                ],
              )
            ]),
          )),
    );
  }
}
