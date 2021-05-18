import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/comment_model.dart';
import 'package:finsta/models/post_model.dart';
import 'package:finsta/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toMap());
  }

  @override
  Future<void> createComment({required Comment comment}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .doc(comment.postId)
        .collection(Paths.postComments)
        .add(comment.toMap());
  }

  @override
  Stream<List<Future<Post?>>> getUserPosts({required String userId}) {
    final authorRef = _firebaseFirestore.collection(Paths.users).doc(userId);
    return _firebaseFirestore
        .collection(Paths.posts)
        .where('author', isEqualTo: authorRef)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Post.fromMap(doc)).toList(),
        );
  }

  @override
  Stream<List<Future<Comment?>>> getPostComments({required String postId}) {
    return _firebaseFirestore
        .collection(Paths.comments)
        .doc(postId)
        .collection(Paths.postComments)
        .orderBy('date', descending: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Comment.fromMap(doc)).toList(),
        );
  }

  @override
  Future<List<Post?>> getUserFeed({required String userId}) async {
    final postsSnapshot = await _firebaseFirestore
        .collection(Paths.feeds)
        .doc(userId)
        .collection(Paths.userFeed)
        .orderBy('data', descending: true)
        .get();

    final posts = Future.wait(postsSnapshot.docs.map((doc) => Post.fromMap(doc)).toList());

    return posts;
  }
}
