import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/blocs/blocs.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/post/post_repository.dart';
import 'package:finsta/repositories/repositories.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    required PostRepository postRepository,
    required StorageRepository storageRepository,
    required AuthBloc authBloc,
  })   : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File image) {
    emit(state.copyWith(postImage: image, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));

    try {
      final User author = User.empty.copyWith(id: _authBloc.state.user!.uid);
      final postImageUrl = await _storageRepository.uploadPostImage(image: state.postImage!);
      final newPost =
          Post(author: author, imageUrl: postImageUrl, caption: state.caption, likes: 0, date: DateTime.now());

      await _postRepository.createPost(post: newPost);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (error) {
      emit(
        state.copyWith(
          status: CreatePostStatus.error,
          error: const Failure(message: 'We were unable to create your post.'),
        ),
      );
    }
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
