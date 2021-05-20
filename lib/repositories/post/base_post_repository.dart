import 'package:finsta/models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({required Post post});
  Future<void> createComment({required Comment comment});
  Stream<List<Future<Post?>>> getUserPosts({required String userId});
  Stream<List<Future<Comment?>>> getPostComments({required String postId});

  Future<List<Post?>> getUserFeed({required String userId, String? lastPostId});
}
