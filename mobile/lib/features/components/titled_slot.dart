part of 'components.dart';

class TitledSlot extends StatelessWidget {
  const TitledSlot({
    super.key,
    required this.title,
    this.prefix,
  });

  final String title;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    final prefix = this.prefix;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 16,
      ),
      child: Row(
        children: [
          if (prefix != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: prefix,
            ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
