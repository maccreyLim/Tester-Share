import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeFirebaseModel {
  final String? id;
  final String uid; // 작성자 UID
  final String profileName; // 작성자 닉네임
  final DateTime createdAt; // 생성일
  final DateTime? updatedAt; // 수정일 (make it optional)
  final String title; //제목
  final String content; // 내용
  final bool isLiked; // 좋아요 여부
  final int likeCount; // 좋아요 갯수

  NoticeFirebaseModel({
    this.id,
    required this.uid,
    required this.profileName,
    required this.createdAt,
    this.updatedAt,
    required this.title,
    required this.content,
    required this.isLiked,
    required this.likeCount,
  });

  factory NoticeFirebaseModel.fromMap(Map<String, dynamic> data) {
    return NoticeFirebaseModel(
      id: data['id'] as String? ?? '',
      uid: data['uid'] as String? ?? '',
      profileName: data['profilename'] as String? ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      title: data['title'],
      content: data['content'],
      isLiked: data['isLiked'],
      likeCount: data['likeCount'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'profileName': profileName,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'title': title,
      'content': content,
      'isLiked': isLiked,
      'likeCount': likeCount,
    };
  }
}
