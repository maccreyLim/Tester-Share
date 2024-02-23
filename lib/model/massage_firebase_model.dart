import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String id; // File명
  String senderUid; // 발신자 UID
  String receiverUid; // 수신자 UID
  String contents; // 쪽지 내용
  DateTime timestamp; // 쪽지 작성 시간
  bool isRead; //읽음여부
  String senderNickname;
  String receiverNickname;

  MessageModel({
    this.id = '',
    required this.senderUid,
    required this.receiverUid,
    required this.contents,
    required this.timestamp,
    this.isRead = false,
    this.senderNickname = '',
    this.receiverNickname = '',
  });

  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderUid: data['senderUid'],
      receiverUid: data['receiverUid'],
      contents: data['contents'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'contents': contents,
      'timestamp': timestamp,
      'isRead': false,
    };
  }

  // fromJson 메서드: JSON을 객체로 역직렬화
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      contents: json['contents'],
      timestamp: DateTime.parse(json['timestamp']), // 문자열을 DateTime으로 역직렬화
      isRead: json['isRead'],
    );
  }

  // toJson 메서드: 객체를 JSON으로 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'contents': contents,
      'timestamp': timestamp.toIso8601String(), // DateTime을 문자열로 직렬화
      'isRead': isRead,
    };
  }
}
