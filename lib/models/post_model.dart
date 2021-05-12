import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/models.dart';
import 'package:flutter/material.dart';

class Post extends Equatable {
  final String? id;
  final User author;
  final String imageUrl;
  final String caption;
  final int likes;
  final DateTime date;

  const Post({
    this.id,
    required this.author,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.date,
  });

  static final empty = Post(
    id: '',
    author: User.empty,
    imageUrl: '',
    caption: '',
    likes: 0,
    date: DateTime.now(),
  );

  @override
  List<Object?> get props => [id, author, imageUrl, caption, likes, date];

  Post copyWith({
    String? id,
    User? user,
    String? imageUrl,
    String? caption,
    int? likes,
    DateTime? date,
  }) {
    if ((id == null || identical(id, this.id)) && (user == null || identical(user, this.author)) && (imageUrl == null || identical(imageUrl, this.imageUrl)) && (caption == null || identical(caption, this.caption)) && (likes == null || identical(likes, this.likes)) && (date == null || identical(date, this.date))) {
      return this;
    }

    return new Post(
      id: id ?? this.id,
      author: user ?? this.author,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'author': FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'imageUrl': this.imageUrl,
      'caption': this.caption,
      'likes': this.likes,
      'date': Timestamp.fromDate(this.date),
    };
  }

  static Future<Post?> fromMap(DocumentSnapshot? doc) async {
    if (doc == null || doc.data() == null) return empty;
    final data = doc.data() as Map;
    final authorRef = data['author'] as DocumentReference?;

    if (authorRef != null) {
      final authorDoc = await authorRef.get();

      if (authorDoc.exists) {
        return new Post(
          id: doc.id,
          author: User.fromMap(authorDoc),
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          likes: (data['likes'] ?? 0).toInt(),
          date: (data['date'] ?? Timestamp)?.toDate(),
        );
      }
    }

    return null;
  }
}
