import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';

class BoardFirebaseController {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('boards');

// Create (추가)
  Future<void> addBoard(BoardFirebaseModel newPost) async {
    try {
      DocumentReference documentRef = await collectionRef.add(newPost.toMap());

      // 문서 ID를 얻어옴
      String docId = documentRef.id;

      // 얻어온 ID를 해당 문서에 업데이트
      await documentRef.update({'docUid': docId});

      print('Board added with ID: $docId');
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

  // Stream - isApproval이 true인 게시물만 감시(HomeScreen사용)
  Stream<List<BoardFirebaseModel>> streamApprovedBoards() {
    try {
      return FirebaseFirestore.instance
          .collection('boards')
          .where('isApproval', isEqualTo: true)
          .snapshots()
          .map((querySnapshot) {
        List<BoardFirebaseModel> boards = querySnapshot.docs
            .map((doc) => BoardFirebaseModel.fromFirestore(doc))
            .toList();

        return boards;
      });
    } catch (e) {
      print('Error streaming approved boards: $e');
      return Stream.value([]);
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
  Future<void> deleteBoard(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('boards').doc(docId).delete();
    } catch (e) {
      print('Error deleting board: $e');
    }
  }

  Stream<List<BoardFirebaseModel>> boardStream({String? currentUserUid}) {
    print("스트할 ID : $currentUserUid");
    try {
      CollectionReference boardsCollection =
          FirebaseFirestore.instance.collection('boards');

      Query query = boardsCollection.orderBy('createAt', descending: true);

      // currentUserUid가 제공되면 해당 사용자의 게시물만 필터링
      if (currentUserUid != null) {
        query = query.where('createUid', isEqualTo: currentUserUid);
      }

      return query.snapshots().map((QuerySnapshot querySnapshot) {
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
      return const Stream.empty();
    }
  }
}
