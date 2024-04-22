import 'package:cloud_firestore/cloud_firestore.dart';

class BoardFirebaseModel {
  String docid; // 문서 Doc 명
  bool isApproval; // 승인 여부
  bool isDeploy; // 배포(출시)여부
  String createUid; // 작성자 uid
  String developer; // 개발자 프로필
  DateTime createAt; // 작성일자
  DateTime? updateAt; // 수정일자 (nullable로 변경)
  DateTime? deployAt; //배포날짜
  String title; // App 이름
  String introductionText; // App 소개글
  int testerRequest; // 테스터에 필요한 요청수
  int testerParticipation; // 테스터 참여자 수
  List<String> appImagesUrl; // App 이미지
  String iconImageUrl; // AppIcon 이미지
  String? githubUrl; // github 주소
  String appSetupUrl; // app 설치 주소
  List<dynamic>? language; // 사용 가능 언어 (nullable로 변경)
  List<String> rquestProfileName; // App 이미지

  // 생성자 추가
  BoardFirebaseModel(
      {required this.docid,
      required this.isApproval,
      required this.isDeploy,
      required this.createUid,
      required this.developer,
      required this.createAt,
      this.updateAt,
      this.deployAt,
      required this.title,
      required this.introductionText,
      required this.testerRequest,
      required this.testerParticipation,
      required this.appImagesUrl,
      required this.iconImageUrl,
      this.githubUrl,
      required this.appSetupUrl,
      this.language,
      required this.rquestProfileName});

  // fromFirestore 메서드 수정
  factory BoardFirebaseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

    return BoardFirebaseModel(
      docid: doc.id,
      isApproval: data?['isApproval'] ?? false,
      isDeploy: data?['isDeploy'] ?? false,
      createUid: data?['createUid'] ?? '',
      developer: data?['developer'] ?? '',
      createAt: (data?['createAt'] as Timestamp).toDate(),
      updateAt: (data?['updateAt'] as Timestamp?)?.toDate(), // nullable로 변경
      deployAt:
          (data?['deployAt'] as Timestamp?)?.toDate(), //배포완료일 nullable로 변경
      title: data?['title'] ?? '',
      introductionText: data?['introductionText'] ?? '',
      testerRequest: data?['testerRequest'] ?? 0,
      testerParticipation: data?['testerParticipation'] ?? 0,
      appImagesUrl: List<String>.from(data?['appImagesUrl'] ?? []),
      iconImageUrl: data?['iconImageUrl'] ?? '',
      githubUrl: data?['githubUrl'] ?? '',
      appSetupUrl: data?['appSetupUrl'] ?? '',
      language: List<dynamic>.from(data?['language'] ?? []),
      rquestProfileName: List<String>.from(data?['rquestProfileName'] ?? []),
    );
  }

  // toMap 메서드 수정
  Map<String, dynamic> toMap() {
    return {
      'docid': docid,
      'isApproval': isApproval,
      'isDeploy': isDeploy,
      'createUid': createUid,
      'developer': developer,
      'createAt': createAt,
      'updateAt': updateAt,
      'deployAt': deployAt,
      'title': title,
      'introductionText': introductionText,
      'testerRequest': testerRequest,
      'testerParticipation': testerParticipation,
      'appImagesUrl': appImagesUrl,
      'iconImageUrl': iconImageUrl,
      'githubUrl': githubUrl,
      'appSetupUrl': appSetupUrl,
      'language': language,
      'rquestProfileName': rquestProfileName,
    };
  }
}
