import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';

class BugTodoFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'bug_todos';

  //Create
  Future<void> createBugTodo(BugTodoFirebaseModel bugTodo) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore.collection(_collectionPath).add(bugTodo.toMap());
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 생성 실패: $e');
    }
  }

  //Read
  Stream<List<BugTodoFirebaseModel>> getBugTosos() {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      return _firestore.collection(_collectionPath).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => BugTodoFirebaseModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 생성 실패: $e');
    }
  }

  //Update
  Future<void> updateBugTodo(String docid, Map<String, dynamic> date) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore.collection(_collectionPath).doc(docid).update(date);
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 생성 실패: $e');
    }
  }

  //Delete
  Future<void> deleteBugTodo(String docid) async {
    try {
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await _firestore.collection(_collectionPath).doc(docid).delete();
    } catch (e) {
      Get.back();
      throw Exception('Bug Todo 생성 실패: $e');
    }
  }
}
