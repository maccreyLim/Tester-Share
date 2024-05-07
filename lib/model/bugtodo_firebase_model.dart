import 'package:cloud_firestore/cloud_firestore.dart'; // Timestamp 클래스 import

class BugTodoFirebaseModel {
  String? docid;
  String createUid;
  String projectName;
  DateTime createAt;
  DateTime? updateAt;
  String title;
  String contents;
  bool isDone;
  int level;
  String? reportprofileName;

  BugTodoFirebaseModel({
    this.docid,
    required this.createUid,
    required this.projectName,
    required this.createAt,
    this.updateAt,
    required this.title,
    required this.contents,
    required this.isDone,
    required this.level,
    this.reportprofileName,
  });

  factory BugTodoFirebaseModel.fromMap(Map<String, dynamic> map) {
    return BugTodoFirebaseModel(
      docid: map['docid'],
      createUid: map['createUid'],
      projectName: map['projectName'],
      reportprofileName: map['reportprofileName'],
      createAt:
          (map['createAt'] as Timestamp).toDate(), // Timestamp -> DateTime 변환
      updateAt: map['updateAt'] != null
          ? (map['updateAt'] as Timestamp).toDate()
          : null, // Timestamp -> DateTime 변환
      title: map['title'],
      contents: map['contents'],
      isDone: map['isDone'],
      level: map['level'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docid': docid,
      'createUid': createUid,
      'projectName': projectName,
      'reportprofileName': reportprofileName,
      'createAt': createAt,
      'updateAt': updateAt,
      'title': title,
      'contents': contents,
      'isDone': isDone,
      'level': level,
    };
  }
}
