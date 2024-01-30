import 'package:cloud_firestore/cloud_firestore.dart';

class BoardFirebaseModel {
  String docid; // 문서 Doc 명
  String createUid; // 작성자 uid
  String developer; // 개발자 프로필
  DateTime createAt; // 작성일자
  DateTime? updateAt; // 수정일자 (nullable로 변경)
  String title; // App 이름
  String introductionText; // App 소개글
  int testerRequest; // 테스터에 필요한 요청수
  int testerParticipation; // 테스터 참여자 수
  List<String> imageUrl; // App 이미지
  String iconImageUrl; // AppIcon 이미지
  String githubUrl; // github 주소
  String appSetupUrl; //app설치 주소
  Map<String, dynamic> testerRequestProfile; // 테스터 참여자 이름
  List<dynamic>? language; // 사용 가능 언어 (nullable로 변경)

  // 생성자 추가
  BoardFirebaseModel({
    required this.docid,
    required this.createUid,
    required this.developer,
    required this.createAt,
    this.updateAt,
    required this.title,
    required this.introductionText,
    required this.testerRequest,
    required this.testerParticipation,
    required this.imageUrl,
    required this.iconImageUrl,
    required this.githubUrl,
    required this.appSetupUrl,
    required this.testerRequestProfile,
    this.language,
  });

  // fromFirestore 메서드 수정
  factory BoardFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return BoardFirebaseModel(
      docid: doc.id,
      createUid: data['createUid'] ?? '',
      developer: data['developer'] ?? '',
      createAt: (data['createAt'] as Timestamp).toDate(),
      updateAt: (data['updateAt'] as Timestamp?)?.toDate(), // nullable로 변경
      title: data['title'] ?? '',
      introductionText: data['introductionText'] ?? '',
      testerRequest: data['testerRequest'] ?? 0,
      testerParticipation: data['testerParticipation'] ?? 0,
      imageUrl: List<String>.from(data['imageUrl'] ?? []),
      iconImageUrl: data['iconImageUrl'] ?? '',
      githubUrl: data['githubUrl'] ?? '',
      appSetupUrl: data['appSetupUrl'] ?? '',
      testerRequestProfile:
          Map<String, dynamic>.from(data['testerRequestProfile'] ?? {}),
      language: List<dynamic>.from(data['language'] ?? []),
    );
  }

  // toMap 메서드 수정
  Map<String, dynamic> toMap() {
    return {
      'docUid': docid,
      'createUid': createUid,
      'developer': developer,
      'createAt': createAt,
      'updateAt': updateAt,
      'title': title,
      'introductionText': introductionText,
      'testerRequest': testerRequest,
      'testerParticipation': testerParticipation,
      'imageUrl': imageUrl,
      'iconImageUrl': iconImageUrl,
      'githubUrl': githubUrl,
      'appSetupUrl': appSetupUrl,
      'testerRequestProfile': testerRequestProfile,
      'language': language,
    };
  }
}
