part of '../../../presentation.dart';

class ProfileOptionSlot extends StatelessWidget {
  const ProfileOptionSlot({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final String icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4F2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          SvgPicture.asset(
            AppIcons.chevronRight,
          ),
        ],
      ),
    );
  }
}
