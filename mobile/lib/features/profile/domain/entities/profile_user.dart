import 'package:equatable/equatable.dart';

class ProfileUserEntity extends Equatable {
  const ProfileUserEntity({
    required this.id,
    required this.name,
    required this.urlAvatar,
  });

  final String id;
  final String name;
  final String urlAvatar;

  ProfileUserEntity copyWith({
    String? id,
    String? name,
    String? urlAvatar,
  }) {
    return ProfileUserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      urlAvatar: urlAvatar ?? this.urlAvatar,
    );
  }

  @override
  List<Object?> get props => [id, name, urlAvatar];
}
