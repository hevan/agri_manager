part of dashboard;

class _RecentMessages extends StatelessWidget {
  const _RecentMessages({
    required this.onPressedMore,
    Key? key,
  }) : super(key: key);

  final Function() onPressedMore;

  @override
  Widget build(BuildContext context) {
   bool isDark = AdaptiveTheme.of(context).mode.isDark;
    return Row(
      children: [
        Icon(EvaIcons.messageCircle, color: isDark ? Colors.white70 : Theme.of(context).primaryColor),
        const SizedBox(width: 10),
        Text(
          "Recent Messages"
        ),
        const Spacer(),
        IconButton(
          onPressed: onPressedMore,
          icon: const Icon(EvaIcons.moreVertical),
          tooltip: "more",
        )
      ],
    );
  }
}
