import 'package:cloud_firestore/cloud_firestore.dart';

class BoardFirebaseModel {
  String docid; // 문서 Doc 명
  String createUid; // 작성자 uid
  DateTime createAt; //작성일자
  DateTime updateAt; //수정일자
  String title; // App 이름
  String introductionText; // App 소개글
  int testerRequest; //테스터에 필요한 요청수
  int testerParticipation; //테스터 참여자 수
  String imageUrl; // App이미지
  String iconImageUrl; // AppIcon이미지
  String githubUrl; //github 주소
  Map<String, dynamic> testerRequestProfile; //테스터 참여자 이름
  List<dynamic> language; // 사용가능 언어

  // 생성자 추가
  BoardFirebaseModel({
    required this.docid,
    required this.createUid,
    required this.createAt,
    required this.updateAt,
    required this.title,
    required this.introductionText,
    required this.testerRequest,
    required this.testerParticipation,
    required this.imageUrl,
    required this.iconImageUrl,
    required this.githubUrl,
    required this.testerRequestProfile,
    required this.language,
  });

  // fromFirestore 메서드 추가
  factory BoardFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BoardFirebaseModel(
      docid: doc.id,
      createUid: data['createUid'] ?? '',
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp).toDate(),
      title: data['title'] ?? '', // 추가
      introductionText: data['introductionText'] ?? '', // 추가
      testerRequest: data['testerRequest'] ?? 0,
      testerParticipation: data['testerParticipation'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      iconImageUrl: data['iconImageUrl'] ?? '',
      githubUrl: data['githubUrl'] ?? '',
      testerRequestProfile:
          Map<String, dynamic>.from(data['testerRequestProfile'] ?? {}),
      language: List<dynamic>.from(data['language'] ?? []),
    );
  }

  // toMap 메서드 추가
  Map<String, dynamic> toMap() {
    return {
      'docUid': docid,
      'createUid': createUid,
      'createAt': createAt,
      'updateAt': updateAt,
      'title': title,
      'introductionText': introductionText,
      'testerRequest': testerRequest,
      'testerParticipation': testerParticipation,
      'imageUrl': imageUrl,
      'iconImageUrl': iconImageUrl,
      'githubUrl': githubUrl,
      'testerRequestProfile': testerRequestProfile,
      'language': language,
    };
  }
}
