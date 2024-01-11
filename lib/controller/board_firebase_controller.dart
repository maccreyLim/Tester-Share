import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';

class BoardFirebaseController {
  // Create (추가)
  Future<void> addBoard(BoardFirebaseModel board) async {
    try {
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(board.docid)
          .set(board.toMap());
    } catch (e) {
      print('Error adding board: $e');
    }
  }

  // Read (조회)
  Future<BoardFirebaseModel?> getBoard(String boardId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('boards')
          .doc(boardId)
          .get();
      if (doc.exists) {
        return BoardFirebaseModel.fromFirestore(doc);
      } else {
        print('No such board!');
        return null;
      }
    } catch (e) {
      print('Error getting board: $e');
      return null;
    }
  }

  // Update (수정)
  Future<void> updateBoard(BoardFirebaseModel board) async {
    try {
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(board.docid)
          .update(board.toMap());
    } catch (e) {
      print('Error updating board: $e');
    }
  }

  // Delete (삭제)
  Future<void> deleteBoard(String boardId) async {
    try {
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(boardId)
          .delete();
    } catch (e) {
      print('Error deleting board: $e');
    }
  }

  // Stream (스트림)
  Stream<List<BoardFirebaseModel>> boardStream() {
    try {
      return FirebaseFirestore.instance
          .collection('boards')
          .orderBy('createAt', descending: true) // createAt을 기준으로 내림차순 정렬
          .snapshots()
          .map((QuerySnapshot querySnapshot) {
        List<BoardFirebaseModel> boards = [];
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          if (doc.exists) {
            boards.add(BoardFirebaseModel.fromFirestore(doc));
          }
        }
        return boards;
      });
    } catch (e) {
      print('Error streaming boards: $e');
      return Stream.empty();
    }
  }
}
