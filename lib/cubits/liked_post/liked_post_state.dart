part of 'liked_post_cubit.dart';

class LikedPostState extends Equatable {
  final Set<String> likedPostIds;
  final Set<String> recentlyLikedPostIds;

  const LikedPostState({
    required this.likedPostIds,
    required this.recentlyLikedPostIds,
  });

  factory LikedPostState.initial() {
    return LikedPostState(
      likedPostIds: {},
      recentlyLikedPostIds: {},
    );
  }

  @override
  List<Object?> get props => [likedPostIds, recentlyLikedPostIds];

  LikedPostState copyWith({
    Set<String>? likedPostIds,
    Set<String>? recentlyLikedPostIds,
  }) {
    if ((likedPostIds == null || identical(likedPostIds, this.likedPostIds)) &&
        (recentlyLikedPostIds == null ||
            identical(recentlyLikedPostIds, this.recentlyLikedPostIds))) {
      return this;
    }

    return new LikedPostState(
      likedPostIds: likedPostIds ?? this.likedPostIds,
      recentlyLikedPostIds: recentlyLikedPostIds ?? this.recentlyLikedPostIds,
    );
  }
}
