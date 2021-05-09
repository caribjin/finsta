import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/models/models.dart';
import 'package:flutter/material.dart';

class Post extends Equatable {
  final String? id;
  final User user;
  final String imageUrl;
  final String caption;
  final int likes;
  final DateTime date;

  const Post({
    this.id,
    required this.user,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.date,
  });

  static const empty = Post(
    id: '',
    user: User.empty,
    imageUrl: '',
    caption: '',
    likes: 0,
    date: DateTime.now(),
  );

  @override
  List<Object?> get props => [id, user, imageUrl, caption, likes, date];

  Post copyWith({
    String? id,
    User? user,
    String? imageUrl,
    String? caption,
    int? likes,
    DateTime? date,
  }) {
    if ((id == null || identical(id, this.id)) && (user == null || identical(user, this.user)) && (imageUrl == null || identical(imageUrl, this.imageUrl)) && (caption == null || identical(caption, this.caption)) && (likes == null || identical(likes, this.likes)) && (date == null || identical(date, this.date))) {
      return this;
    }

    return new Post(
      id: id ?? this.id,
      user: user ?? this.user,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'user': this.user,
      'imageUrl': this.imageUrl,
      'caption': this.caption,
      'likes': this.likes,
      'date': this.date,
    };
  }

  factory Post.fromMap(DocumentSnapshot? doc) {
    if (doc == null || doc.data() == null) return empty;
    final data = doc.data() as Map;

    return new Post(
      id: doc.id,
      user: data['user'] ?? '',
      imageUrl: data['imageUrl'],
      caption: data['caption'],
      likes: data['likes'],
      date: data['date'],
    );
  }
}
