import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String email;
  final String profileImageUrl;
  final int followers;
  final int following;
  final String bio;

  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.profileImageUrl,
    required this.followers,
    required this.following,
    required this.bio,
  });

  static const empty = User(
    id: '',
    username: '',
    email: '',
    profileImageUrl: '',
    followers: 0,
    following: 0,
    bio: '',
  );

  User copyWith({
    String? id,
    String? username,
    String? email,
    String? profileImageUrl,
    int? followers,
    int? following,
    String? bio,
  }) {
    if ((id == null || identical(id, this.id)) && (username == null || identical(username, this.username)) && (email == null || identical(email, this.email)) && (profileImageUrl == null || identical(profileImageUrl, this.profileImageUrl)) && (followers == null || identical(followers, this.followers)) && (following == null || identical(following, this.following)) && (bio == null || identical(bio, this.bio))) {
      return this;
    }

    return new User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      bio: bio ?? this.bio,
    );
  }

  @override
  List<Object?> get props => [id, username, email, profileImageUrl, followers, following, bio];

  Map<String, dynamic> toMap() {
    return {
      'username': this.username,
      'email': this.email,
      'profileImageUrl': this.profileImageUrl,
      'followers': this.followers,
      'following': this.following,
      'bio': this.bio,
    };
  }

  factory User.fromMap(DocumentSnapshot? doc) {
    if (doc == null || doc.data() == null) return empty;
    final data = doc.data()!;

    return new User(
      id: doc.id,
      username: data['username'] as String ?? '',
      email: data['email'] as String ?? '',
      profileImageUrl: data['profileImageUrl'] as String ?? '',
      followers: data['followers'] as int ?? 0,
      following: data['following'] as int ?? 0,
      bio: data['bio'] as String ?? '',
    );
  }
}
