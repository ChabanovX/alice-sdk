part of 'presentation.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F2),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              final user = state is ProfileUserState ? state.user : null;
              return ProfileHeader(
                userName: user?.name ?? '',
                avatarUrl: user?.urlAvatar ?? '',
              );
            },
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
