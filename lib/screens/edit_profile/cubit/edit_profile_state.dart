part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error }

class EditProfileState extends Equatable {
  final File? profileImage;
  final String username;
  final String bio;
  final EditProfileStatus status;
  final Failure failure;

  const EditProfileState({
    required this.profileImage,
    required this.username,
    required this.bio,
    required this.status,
    required this.failure,
  });

  factory EditProfileState.initial() {
    return EditProfileState(
      profileImage: null,
      username: '',
      bio: '',
      status: EditProfileStatus.initial,
      failure: Failure(),
    );
  }

  EditProfileState copyWith({
    File? profileImage,
    String? username,
    String? bio,
    EditProfileStatus? status,
    Failure? failure,
  }) {
    if ((profileImage == null || identical(profileImage, this.profileImage)) && (username == null || identical(username, this.username)) && (bio == null || identical(bio, this.bio)) && (status == null || identical(status, this.status)) && (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return new EditProfileState(
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [profileImage ?? '', username, bio, status, failure];
}
