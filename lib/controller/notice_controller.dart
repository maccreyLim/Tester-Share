import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';

class NoticeController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _noticeCollection;

  NoticeController() {
    _noticeCollection = _firestore.collection('notice');
  }

//Create
  Future<void> createNotice(NoticeFirebaseModel noticeModel) async {
    Map<String, dynamic> noticeModelMap =
        noticeModel.toMap(); // NoticeModelMap을 Map으로 변환
    DocumentReference docRef = _noticeCollection.doc(); // 랜덤한 ID 생성
    String id = docRef.id;

    // set 메서드를 사용하여 데이터 저장
    await docRef.set(
      {
        ...noticeModelMap,
        'id': id,
      },
    );
  }

  //Read
  Stream<QuerySnapshot<Map<String, dynamic>>> readNoticeQuery() {
    final collection = FirebaseFirestore.instance.collection('notice');

    // 'createdAt' 필드를 기준으로 내림차순으로 정렬하여 최근 게시물이 위에 오도록 합니다.
    return collection
        .orderBy('createdAt', descending: true)
        .limit(3) // 최근 5개 항목만 가져옵니다.
        .snapshots();
  }

  //Update
  Future<void> updateNotice(NoticeFirebaseModel noticeModel) async {
    await _noticeCollection.doc(noticeModel.id).update(noticeModel.toMap());
  }

  //Delete
  Future<void> deleteNotice(String? id) async {
    if (id != null && id.isNotEmpty) {
      try {
        await _noticeCollection.doc(id).delete();
        print("문서 $id가 삭제되었습니다.");
      } catch (e) {
        print("게시글 삭제 중 오류 발생: $e");
        throw e; // 예외 다시 던지기
      }
    } else {
      print("Invalid documentFileID: $id");
    }
  }
}
