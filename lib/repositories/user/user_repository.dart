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
}