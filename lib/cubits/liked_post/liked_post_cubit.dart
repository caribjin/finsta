import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/blocs/blocs.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/post/post_repository.dart';

part 'liked_post_state.dart';

class LikedPostCubit extends Cubit<LikedPostState> {
  final PostRepository _postRepository;
  final AuthBloc _authBloc;

  LikedPostCubit({
    required PostRepository postRepository,
    required AuthBloc authBloc,
  })   : _postRepository = postRepository,
        _authBloc = authBloc,
        super(LikedPostState.initial());

  void updateLikedPosts({required Set<String> postIds}) {
    emit(state.copyWith(likedPostIds: Set<String>.from(state.likedPostIds)..addAll(postIds)));
  }

  void likePost({required Post post}) {
    _postRepository.createLike(post: post, userId: _authBloc.state.user!.uid);
    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..add(post.id!),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)..add(post.id!),
      ),
    );
  }

  void unlikePost({required Post post}) {
    _postRepository.deleteLike(postId: post.id!, userId: _authBloc.state.user!.uid);
    emit(
      state.copyWith(
        likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id!),
        recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)..remove(post.id!),
      ),
    );
  }

  void clearAllLikedPosts() {
    emit(LikedPostState.initial());
  }
}
