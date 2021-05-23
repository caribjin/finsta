import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/comment_model.dart';
import 'package:finsta/models/post_model.dart';
import 'package:finsta/repositories/repositories.dart';

const int paginationLimit = 5;

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
  void createLike({required Post post, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(post.id)
        .update({'likes': FieldValue.increment(1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(post.id)
        .collection(Paths.postLikes)
        .doc(userId)
        .set({});
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
  Future<List<Post?>> getUserFeed({required String userId, String? lastPostId}) async {
    final QuerySnapshot postsSnapshot;

    if (lastPostId == null) {
      postsSnapshot = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .limit(paginationLimit)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnapshot = await _firebaseFirestore
          .collection(Paths.feeds)
          .doc(userId)
          .collection(Paths.userFeed)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(paginationLimit)
          .get();
    }

    final posts = Future.wait(postsSnapshot.docs.map((doc) => Post.fromMap(doc)).toList());

    return posts;
  }

  @override
  Future<Set<String>> getLikedPostIds({required String userId, required List<Post> posts}) async {
    final postIds = <String>{};

    for (final post in posts) {
      final likeDoc = await _firebaseFirestore
          .collection(Paths.likes)
          .doc(post.id)
          .collection(Paths.postLikes)
          .doc(userId)
          .get();

      if (likeDoc.exists) {
        postIds.add(post.id!);
      }
    }

    return postIds;
  }

  @override
  void deleteLike({required String postId, required String userId}) {
    _firebaseFirestore
        .collection(Paths.posts)
        .doc(postId)
        .update({'likes': FieldValue.increment(-1)});

    _firebaseFirestore
        .collection(Paths.likes)
        .doc(postId)
        .collection(Paths.postLikes)
        .doc(userId)
        .delete();
  }
}
