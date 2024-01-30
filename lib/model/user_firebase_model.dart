import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseModel {
  String? uid; //uid
  String email; //email
  String password; //password
  String profileName; //프로필 이름
  String? profileImageUrl; //프로필 사진 주소
  int deployed; // APP출시 횟수
  int? testerParticipation; //테스트 신청 수
  int? testerRequest; // 테스터 요청 생성 수
  DateTime createAt; // 생성날짜
  DateTime? updateAt; // 업데이트 날짜

  UserFirebaseModel({
    this.uid,
    required this.email,
    required this.password,
    required this.profileName,
    this.profileImageUrl,
    required this.deployed,
    this.testerParticipation,
    this.testerRequest,
    required this.createAt,
    this.updateAt,
  });

  factory UserFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserFirebaseModel(
      uid: doc.id,
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      profileName: data['profileName'] ?? '',
      deployed: data['deployed'] ?? 0,
      testerParticipation: data['testerParticipation'] ?? 0,
      testerRequest: data['testerRequest'] ?? 0,
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'profileName': profileName,
      'deployed': deployed,
      'testerParticipation': testerParticipation,
      'testerRequest': testerRequest,
      'createAt': createAt,
      'updateAt': updateAt,
    };
  }
}
