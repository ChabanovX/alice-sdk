part of 'components.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Center(
              child: SvgPicture.asset(
                AppIcons.arrowLeft,
                width: 24,
                height: 24,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            width: 56,
          ),
        ],
      ),
    );
  }
}
