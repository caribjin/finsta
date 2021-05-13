part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File? postImage;
  final String caption;
  final CreatePostStatus status;
  final Failure error;

  const CreatePostState({
    required this.postImage,
    required this.caption,
    required this.status,
    required this.error,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      caption: '',
      status: CreatePostStatus.initial,
      error: Failure(),
    );
  }

  @override
  List<Object> get props => [postImage ?? Object(), caption, status, error];

  CreatePostState copyWith({
    File? postImage,
    String? caption,
    CreatePostStatus? status,
    Failure? error,
  }) {
    if ((postImage == null || identical(postImage, this.postImage)) &&
        (caption == null || identical(caption, this.caption)) &&
        (status == null || identical(status, this.status)) &&
        (error == null || identical(error, this.error))) {
      return this;
    }

    return new CreatePostState(
      postImage: postImage ?? this.postImage,
      caption: caption ?? this.caption,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
