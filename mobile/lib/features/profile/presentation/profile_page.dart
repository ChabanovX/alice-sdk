part of 'presentation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.user,
  });

  final ProfileUserEntity user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F2),
      body: CustomScrollView(
        slivers: [
          ProfileHeader(
            userName: user.name,
            avatarUrl: user.urlAvatar,
          ),
          const ProfileBody(),
          const SliverPadding(
            padding: EdgeInsets.only(top: 7),
            sliver: DriverOptions(),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 7),
            sliver: AppSettings(),
          ),
          const SliverToBoxAdapter(
            child: AboutApp(),
          ),
        ],
      ),
    );
  }
}
