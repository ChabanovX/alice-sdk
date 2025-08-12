import '../entities/profile_user.dart';

class ProfileRepository {
  Future<ProfileUserEntity> getUser() async {
    return const ProfileUserEntity(
      id: '1',
      name: 'Александр',
      urlAvatar: 'https://i.yapx.ru/aNd7y.jpg',
    );
  }
}
