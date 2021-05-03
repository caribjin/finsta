part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error }

class ProfileState extends Equatable {
  final User user;
  // final List<Post> posts;
  final bool isCurrentUser;
  final bool isGridView;
  final bool isFollowing;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    required this.user,
    required this.isCurrentUser,
    required this.isGridView,
    required this.isFollowing,
    required this.status,
    required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      isCurrentUser: false,
      isGridView: true,
      isFollowing: false,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  ProfileState copyWith({
    User? user,
    bool? isCurrentUser,
    bool? isGridView,
    bool? isFollowing,
    ProfileStatus? status,
    Failure? failure,
  }) {
    if ((user == null || identical(user, this.user)) && (isCurrentUser == null || identical(isCurrentUser, this.isCurrentUser)) && (isGridView == null || identical(isGridView, this.isGridView)) && (isFollowing == null || identical(isFollowing, this.isFollowing)) && (status == null || identical(status, this.status)) && (failure == null || identical(failure, this.failure))) {
      return this;
    }

    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      isGridView: isGridView ?? this.isGridView,
      isFollowing: isFollowing ?? this.isFollowing,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object> get props => [
        user,
        isCurrentUser,
        isGridView,
        isFollowing,
        status,
        failure,
      ];
}
