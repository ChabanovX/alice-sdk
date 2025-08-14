part of '../../presentation.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.avatarUrl,
  });

  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(),
      ),
      child: ClipOval(
        child: avatarUrl.isEmpty
            ? const Icon(Icons.person, size: 32)
            : CachedNetworkImage(
                imageUrl: avatarUrl,
                placeholder: (context, url) =>
                    const Icon(Icons.person, size: 32),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, size: 32),
                fit: BoxFit.contain,
              ),
      ),
    );
  }
}
