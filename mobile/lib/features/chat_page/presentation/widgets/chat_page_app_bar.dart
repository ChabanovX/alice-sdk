part of '../presentation.dart';

class ChatPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatPageAppBar({
    super.key,
    required this.title,
    this.onTap,
  });

  final String title;
  final VoidCallback? onTap;

  @override
  Size get preferredSize => const Size.fromHeight(110);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.controlMain,
        ),
        height: preferredSize.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16),
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
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
            ),
            Positioned(
              right: 10,
              child: SvgPicture.asset(
                AppIcons.chevronRightBubble,
                height: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
