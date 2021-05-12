import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:finsta/config/paths.dart';
import 'package:finsta/models/models.dart';

class Comment extends Equatable {
  final String? id;
  final String postId;
  final User author;
  final String content;
  final DateTime date;

  const Comment({
    this.id,
    required this.postId,
    required this.author,
    required this.content,
    required this.date,
  });

  @override
  List<Object?> get props => [id, postId, author, content, date];

  Comment copyWith({
    String? id,
    String? postId,
    User? author,
    String? content,
    DateTime? date,
  }) {
    if ((id == null || identical(id, this.id)) && (postId == null || identical(postId, this.postId)) && (author == null || identical(author, this.author)) && (content == null || identical(content, this.content)) && (date == null || identical(date, this.date))) {
      return this;
    }

    return new Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'postId': this.postId,
      'author': FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': this.content,
      'date': Timestamp.fromDate(this.date),
    };
  }

  static Future<Comment?> fromMap(DocumentSnapshot? doc) async {
    if (doc == null || doc.data() == null) return null;
    final data = doc.data() as Map;
    final authorRef = data['author'] as DocumentReference?;

    if (authorRef != null) {
      final authorDoc = await authorRef.get();

      if (authorDoc.exists) {
        return new Comment(
          id: doc.id,
          postId: doc['postId'] ?? '',
          author: User.fromMap(doc['author']),
          content: doc['content'] ?? '',
          date: (doc['date'] ?? Timestamp)?.toDate(),
        );
      }
    }

    return null;
  }
}
