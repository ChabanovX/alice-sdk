part of '../presentation.dart';

class ChatPageItem extends StatelessWidget {
  const ChatPageItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.iconColor = const Color(0xFF000000),
    this.iconBackgroundColor = const Color(0xFFFCE000),
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          bottom: 12,
          left: 8,
          right: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: iconBackgroundColor,
                  ),
                  padding: const EdgeInsetsGeometry.all(10),
                  child: SvgPicture.asset(
                    icon,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                    height: 38,
                  ),
                ),
                const SizedBox(width: 8,),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SvgPicture.asset(AppIcons.chevronRight, width: 30,),
          ],
        ),
      ),
    );
  }
}
