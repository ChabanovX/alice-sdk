part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  ProfileState copyWith();

  @override
  List<Object?> get props => [];
}

class ProfileInitialState extends ProfileState {
  const ProfileInitialState();

  @override
  ProfileState copyWith() {
    return const ProfileInitialState();
  }
}

class ProfileUserState extends ProfileState {
  const ProfileUserState({
    required this.user,
  });

  final ProfileUserEntity user;

  @override
  ProfileState copyWith({ProfileUserEntity? user}) {
    return ProfileUserState(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}
