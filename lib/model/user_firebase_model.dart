import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseModel {
  String? uid; //uid
  String email; //email
  bool isAdmin; //관리자 여부
  String profileName; //프로필 이름
  String? profileImageUrl; //프로필 사진 주소
  int deployed; // APP출시 횟수
  int? testerParticipation; //테스트 신청 수
  int? testerRequest; // 테스터 요청 생성 수
  DateTime createAt; // 생성날짜
  DateTime? updateAt; // 업데이트 날짜
  int? point; //포인트

  UserFirebaseModel(
      {this.uid,
      required this.email,
      required this.isAdmin,
      required this.profileName,
      this.profileImageUrl,
      required this.deployed,
      this.testerParticipation,
      this.testerRequest,
      required this.createAt,
      this.updateAt,
      this.point});

  factory UserFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserFirebaseModel(
      uid: doc.id,
      email: data['email'] ?? '',
      isAdmin: data['isApproval'] ?? false,
      profileName: data['profileName'] ?? '',
      deployed: data['deployed'] ?? 0,
      testerParticipation: data['testerParticipation'] ?? 0,
      testerRequest: data['testerRequest'] ?? 0,
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
      point: data['point'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'isAdmin': isAdmin,
      'profileName': profileName,
      'deployed': deployed,
      'testerParticipation': testerParticipation,
      'testerRequest': testerRequest,
      'createAt': createAt,
      'updateAt': updateAt,
      'point': point,
    };
  }
}
