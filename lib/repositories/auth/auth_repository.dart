import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/models.dart';
import 'package:finsta/repositories/auth/base_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({
    FirebaseFirestore? firebaseFirestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<auth.User?> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;

      _firebaseFirestore.collection(Paths.users).doc(user!.uid).set({
        'username': username,
        'email': email,
        'followers': 0,
        'following': 0,
      });

      return user;
    } on auth.FirebaseAuthException catch (error) {
      throw Failure(message: error.message, code: error.code);
    } on PlatformException catch (error) {
      throw Failure(message: error.message, code: error.code);
    }
  }

  @override
  Future<auth.User?> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);

      return credential.user;
    } on auth.FirebaseAuthException catch (error) {
      throw Failure(message: error.message, code: error.code);
    } on PlatformException catch (error) {
      throw Failure(message: error.message, code: error.code);
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
