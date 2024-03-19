import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/ConstType.dart';
import 'package:agri_manager/src/shared_components/list_profile_image.dart';
import 'package:agri_manager/src/utils/constants.dart';

class TaskCardData {
  final String title;
  final int dueDay;
  final List<ImageProvider> profilContributors;
  final TaskType type;
  final int totalComments;
  final int totalContributors;

  const TaskCardData({
    required this.title,
    required this.dueDay,
    required this.totalComments,
    required this.totalContributors,
    required this.type,
    required this.profilContributors,
  });
}

class TaskCard extends StatelessWidget {
  const TaskCard({
    required this.data,
    required this.onPressedMore,
    required this.onPressedTask,
    required this.onPressedContributors,
    required this.onPressedComments,
    Key? key,
  }) : super(key: key);

  final TaskCardData data;

  final Function() onPressedMore;
  final Function() onPressedTask;
  final Function() onPressedContributors;
  final Function() onPressedComments;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: data.type.getColor(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data.title,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text((data.dueDay < 0)
                    ? "Late in ${data.dueDay * -1} days"
                    : "Due in " +
                        ((data.dueDay > 1) ? "${data.dueDay} days" : "today"))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: data.type.getColor(),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: onPressedTask,
                    child: Text(
                      data.type.toStringValue(),
                    ),
                  ),
                  ListProfileImage(
                    images: data.profilContributors,
                    onPressed: onPressedContributors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: kSpacing / 2),
          ],
        ),
      ),
    );
  }
}

