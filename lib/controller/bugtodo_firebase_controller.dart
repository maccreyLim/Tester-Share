import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';

class BugTodoFirebaseController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Create
  Future<void> createBugTodo(
      String uid, String projectName, BugTodoFirebaseModel bugTodo) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bug_todos')
          .add(bugTodo.toMap());

      // 반환된 문서의 ID를 bugTodo의 docid 필드에 할당
      bugTodo.docid = docRef.id;

      // 업데이트할 문서의 참조를 만들고 해당 문서를 업데이트
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bug_todos')
          .doc(bugTodo.docid)
          .update({'docid': bugTodo.docid});
      print("Todo 생성완료 : $bugTodo.docid");
    } catch (e) {
      throw Exception('Bug Todo 생성 및 업데이트 실패: $e');
    }
  }

  //Todo Read
  Stream<List<BugTodoFirebaseModel>> getAllBugTodos(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bug_todos')
        .orderBy('isDone') // 먼저 isDone으로 정렬
        .orderBy('level') // 그 다음 level로 정렬
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => BugTodoFirebaseModel.fromMap(
                doc.data() as Map<String, dynamic>))
            .toList()
          // 클라이언트 측에서 isDone이 false인 항목을 먼저, true인 항목을 나중에 오도록 재정렬
          ..sort((a, b) {
            if (a.isDone == b.isDone) {
              return a.level.compareTo(b.level); // isDone 상태가 같다면 level로 정렬
            }
            return a.isDone ? 1 : -1; // isDone이 false인 항목을 먼저 위치시킴
          }))
        .handleError((error) {
      throw Exception('Bug Todos 읽기 실패: $error');
    });
  }

  // Update
  Future<void> updateBugTodo(String uid, String projectName, String docId,
      BugTodoFirebaseModel data) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bug_todos')
          .doc(docId)
          .update(data.toMap());
    } catch (e) {
      throw Exception('Bug Todo 업데이트 실패: $e');
    }
  }

  //Update isDone
  Future<void> updateBugTodoIsDone(
      String uid, String docId, bool isDone) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bug_todos')
          .doc(docId)
          .update({'isDone': isDone});
    } catch (e) {
      throw Exception('Bug Todo isDone 업데이트 실패: $e');
    }
  }

  // Delete
  Future<void> deleteBugTodo(
      String uid, String projectName, String docId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('bug_todos')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('Bug Todo 삭제 실패: $e');
    }
  }
}
