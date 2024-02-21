import 'package:cloud_firestore/cloud_firestore.dart';

class ApplyModel {
  String docID; // 문서 ID
  String postID; // 게시물 ID
  String requestUid; // 신청자 UID
  String requestEmail; // 신청자 이메일

  // 생성자
  ApplyModel({
    required this.docID,
    required this.postID,
    required this.requestUid,
    required this.requestEmail,
  });

  // Firestore에서 DocumentSnapshot을 기반으로 ApplyModel 인스턴스를 생성하는 팩토리 메서드
  factory ApplyModel.fromFirestore(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return ApplyModel(
      docID: snapshot.id,
      postID: data['postID'] ?? '',
      requestUid: data['requestUid'] ?? '',
      requestEmail: data['requestEmail'] ?? '',
    );
  }

  // Firestore에 저장하기 위해 ApplyModel을 Map으로 변환하는 메서드
  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'requestUid': requestUid,
      'requestEmail': requestEmail,
    };
  }
}
