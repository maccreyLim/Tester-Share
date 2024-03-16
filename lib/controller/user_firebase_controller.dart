import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/user_firebase_model.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class UserFirebaseController {
  String uid; // uid 변수 추가
  AuthController _authController = AuthController.instance;

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

// 사용자 정보 업데이트 Update (수정)
  Future<void> updateUserInfo(
      String updateuid, String key, dynamic value) async {
    try {
      // Firestore에 데이터를 업데이트합니다.
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updateuid)
          .update({key: value});

      // 업데이트된 데이터를 가져와서 _userData에 반영합니다.
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      Map<String, dynamic>? updatedUserData =
          userSnapshot.data() as Map<String, dynamic>?;

      // AuthController의 메서드를 사용하여 업데이트된 데이터를 반영합니다.
      _authController.updateUserData(updatedUserData!);

      // 업데이트가 완료되었음을 알리는 메시지를 표시할 수 있습니다.
      showToast("데이터가 업데이트되었습니다.", 1);
    } catch (e) {
      print('Error updating user: $e');
      // 오류가 발생한 경우 사용자에게 알림을 표시할 수 있습니다.
      showToast("사용자 데이터를 업데이트하는 중 오류가 발생했습니다.", 2);
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
