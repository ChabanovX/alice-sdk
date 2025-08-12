import 'package:flutter/material.dart';
import '../presentation.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.userName,
    required this.avatarUrl,
  });

  final String userName;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 7.5, 16, 7.5),
          child: SizedBox(
            height: 71,
            child: Row(
              children: [
                UserAvatar(avatarUrl: avatarUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
