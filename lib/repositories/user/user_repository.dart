import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/user_model.dart';
import 'package:finsta/repositories/user/base_user_repository.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({required String userId}) async {
    final doc = await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromMap(doc) : User.empty;
  }

  @override
  Future<void> updateUser({required User user}) async {
    await _firebaseFirestore.collection(Paths.users).doc(user.id).update(user.toMap());
  }

  @override
  Future<List<User>> searchUsers({required String query}) async {
    final userSnap =
        await _firebaseFirestore.collection(Paths.users).where('username', isGreaterThanOrEqualTo: query).get();
    return userSnap.docs.map((doc) => User.fromMap(doc)).toList();
  }

  @override
  void followUser({required String userId, required String followUserId}) {
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(followUserId)
        .set({});

    _firebaseFirestore
        .collection(Paths.followers)
        .doc(followUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .set({});
  }

  @override
  void unfollowUser({required String userId, required String unfollowUserId}) {
    _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowing)
        .doc(unfollowUserId)
        .delete();

    _firebaseFirestore
        .collection(Paths.followers)
        .doc(unfollowUserId)
        .collection(Paths.userFollowers)
        .doc(userId)
        .delete();
  }

  @override
  Future<bool> isFollowing({required String userId, required String otherUserId}) async {
    final otherUserDoc = await _firebaseFirestore
        .collection(Paths.following)
        .doc(userId)
        .collection(Paths.userFollowers)
        .doc(otherUserId)
        .get();

    return otherUserDoc.exists;
  }
}
