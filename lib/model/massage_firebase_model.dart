import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'massage_firebase_model.g.dart'; // build_runner로 생성될 파일

@HiveType(typeId: 1)
class MessageModel {
  @HiveField(0)
  String id; // File명

  @HiveField(1)
  String senderUid; // 발신자 UID

  @HiveField(2)
  String receiverUid; // 수신자 UID

  @HiveField(3)
  String contents; // 쪽지 내용

  @HiveField(4)
  DateTime timestamp; // 쪽지 작성 시간

  @HiveField(5)
  bool isRead; // 읽음 여부

  @HiveField(6)
  String senderNickname;

  @HiveField(7)
  String receiverNickname;

  @HiveField(8)
  String? appUrl;

  MessageModel({
    this.id = '',
    required this.senderUid,
    required this.receiverUid,
    required this.contents,
    required this.timestamp,
    this.isRead = false,
    this.senderNickname = '',
    this.receiverNickname = '',
    this.appUrl,
  });

  // Firestore로 데이터를 저장하기 위한 메서드
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'contents': contents,
      'timestamp': timestamp,
      'isRead': isRead,
      'senderNickname': senderNickname,
      'receiverNickname': receiverNickname,
      'appUrl': appUrl,
    };
  }

  // Firestore에서 가져온 데이터를 기반으로 객체 생성
  factory MessageModel.fromMap(Map<String, dynamic> data, String id) {
    return MessageModel(
      id: id,
      senderUid: data['senderUid'],
      receiverUid: data['receiverUid'],
      contents: data['contents'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'],
      senderNickname: data['senderNickname'],
      receiverNickname: data['receiverNickname'],
      appUrl: data['appUrl'],
    );
  }
}
