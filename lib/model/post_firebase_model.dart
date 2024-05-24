import 'package:cloud_firestore/cloud_firestore.dart';

class PostFirebaseModel {
  late String id; // 게시글 ID
  late String userId; // 작성자 ID
  late String title; // 게시글 제목
  late String content; // 게시글 내용
  List<String>? images; // 이미지 URL 목록
  String? code; // 코드 내용
  late DateTime createdAt; // 작성 시간
  DateTime? updatedAt; // 수정 시간
  late List<Comment> comments; // 댓글 목록

  PostFirebaseModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.images,
    this.code,
    required this.createdAt,
    this.updatedAt,
    required this.comments,
  });

  // Firebase에서 데이터를 가져올 때 사용할 생성자
  PostFirebaseModel.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '',
        userId = map['userId'] as String? ?? '',
        title = map['title'] as String? ?? '',
        content = map['content'] as String? ?? '',
        images = (map['images'] as List<Object?>?)?.cast<String>(),
        code = map['code'] as String?,
        createdAt = (map['createdAt'] as Timestamp).toDate(), // 변경 필요
        updatedAt = (map['updatedAt'] as Timestamp?)?.toDate(),
        comments = (map['comments'] as List<Object?>?)
                ?.map((comment) =>
                    Comment.fromMap(comment as Map<String, dynamic>))
                .toList() ??
            [];

  // Firebase에 데이터를 저장할 때 사용할 메소드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'images': images,
      'code': code,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'comments': comments.map((comment) => comment.toMap()).toList(),
    };
  }
}

class Comment {
  late String id; // 댓글 ID
  late String userId; // 작성자 ID
  late String content; // 댓글 내용
  late DateTime createdAt; // 작성 시간

  Comment({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  // Firebase에서 데이터를 가져올 때 사용할 생성자
  Comment.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userId = map['userId'],
        content = map['content'],
        createdAt = (map['createdAt'] as Timestamp).toDate();

  // Firebase에 데이터를 저장할 때 사용할 메소드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
