import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';

class BugTodoFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create
  Future<void> createBugTodo(
      String uid, String projectName, BugTodoFirebaseModel bugTodo) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore
          .collection('bug_todos')
          .doc(uid)
          .collection(projectName)
          .add(bugTodo.toMap());
      Get.back();
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 생성 실패: $e');
    }
  }

  //Todo Read
  Stream<List<BugTodoFirebaseModel>> getBugTodos(
      String uid, String projectName) {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      return _firestore
          .collection('bug_todos')
          .doc(uid)
          .collection(projectName)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => BugTodoFirebaseModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 읽기 실패: $e');
    }
  }

// ProjectCollectionsRead
  Stream<List<String>> getProjectCollections(String uid) {
    try {
      return _firestore
          .collection('bug_todos')
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        final data = snapshot.data();
        if (data != null && data.isNotEmpty) {
          // 문서의 데이터가 존재하고 비어 있지 않은 경우
          return data.keys.toList();
        } else {
          // 데이터가 없거나 비어 있는 경우 빈 리스트 반환
          return [];
        }
      });
    } catch (e) {
      throw Exception('프로젝트 컬렉션 목록 읽기 실패: $e');
    }
  }

  // Update
  Future<void> updateBugTodo(String uid, String projectName, String docId,
      Map<String, dynamic> data) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore
          .collection('bug_todos')
          .doc(uid)
          .collection(projectName)
          .doc(docId)
          .update(data);
      Get.back();
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 업데이트 실패: $e');
    }
  }

// Delete
  Future<void> deleteBugTodo(
      String uid, String projectName, String docId) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore
          .collection('bug_todos')
          .doc(uid)
          .collection(projectName)
          .doc(docId)
          .delete();
      Get.back();
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 삭제 실패: $e');
    }
  }
}
