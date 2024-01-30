import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/model/user_firebase_model.dart';

class UserFirebaseController {
  String uid; // uid 변수 추가

  // 생성자에서 uid를 받도록 추가
  UserFirebaseController({required this.uid});

  // Create (추가)
  Future<void> addUser(UserFirebaseModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(user.toMap());
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  // Read (조회)
  Future<UserFirebaseModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        return UserFirebaseModel.fromFirestore(doc);
      } else {
        print('No such user!');
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // Update (수정)
  Future<void> updateUser(UserFirebaseModel user) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update(user.toMap());
    } catch (e) {
      print('Error updating user: $e');
    }
  }

  // Delete (삭제)
  Future<void> deleteUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();
    } catch (e) {
      print('Error deleting user: $e');
    }
  }

  // Stream (스트림)
  Stream<UserFirebaseModel?> userStream() {
    try {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .snapshots()
          .map(
            (DocumentSnapshot doc) =>
                doc.exists ? UserFirebaseModel.fromFirestore(doc) : null,
          );
    } catch (e) {
      print('Error streaming user: $e');
      return const Stream.empty();
    }
  }
}
