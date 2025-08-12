part of '../../presentation.dart';

class ProfileTopElements extends StatelessWidget {
  const ProfileTopElements({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.lead,
            width: 56,
            height: 56,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Водитель Такси',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Самозанятый • Fast & Furious',
                maxLines: 1,
                style: TextStyle(
                  color: Colors.black.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                width: 0.5,
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 9,
              ),
              child: Text(
                'Мои сервисы',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
