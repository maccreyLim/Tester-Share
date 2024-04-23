import 'package:cloud_firestore/cloud_firestore.dart';

class BugTodoFirebaseModel {
  String docid; // 문서 Doc 명
  String createUid; // 생성한 유저 uid
  String projectName; // 프로젝트 이름
  DateTime createAt; // 생성일
  DateTime? updateAt; // 수정일
  String contents; // 내용
  bool isDone; // 완료 체크

  BugTodoFirebaseModel({
    required this.docid,
    required this.createUid,
    required this.projectName,
    required this.createAt,
    this.updateAt,
    required this.contents,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'docid': docid,
      'createUid': createUid,
      'projectName': projectName,
      'createAt': createAt,
      'updateAt': updateAt,
      'contents': contents,
      'isDone': isDone,
    };
  }

  factory BugTodoFirebaseModel.fromMap(Map<String, dynamic> map) {
    return BugTodoFirebaseModel(
      docid: map['docid'],
      createUid: map['createUid'],
      projectName: map['projectName'],
      createAt: (map['createAt'] as Timestamp).toDate(),
      updateAt: map['updateAt'] != null
          ? (map['updateAt'] as Timestamp).toDate()
          : null,
      contents: map['contents'],
      isDone: map['isDone'],
    );
  }
}
