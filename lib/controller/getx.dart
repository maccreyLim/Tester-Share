import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ControllerGetX extends GetxController {
  //Property
  RxInt messageCount = 0.obs;
  bool darkModeSwitch = false; //Dark테마를 위한 스위치 설정
  RxBool adminModeSwich = false.obs; //관리자모드를 위한 스위치 설정
  bool isLogin = false; //로그인 상태 확인
  bool isInput = false; // E-Mail 검증 완료여부
  String userUid = ''; //Login한 Use의 Uid저장
  RxMap<String, dynamic> userData =
      RxMap<String, dynamic>(); // Login한 Use의 데이터를 user data에 저장
// //Dark테마변경을 위한 스위칭
//   void DarkModeSwitching() {
//     darkModeSwitch = !darkModeSwitch;
//     update();
//   }

// //Admin모드변경을 위한 스위칭
//   void adimModeSwiching() {
//     darkModeSwitch = !darkModeSwitch;
//     update();
//   }
//message Count
  void setMessageCount(int count) {
    messageCount.value = count;
  }

  // 사용자 데이터를 Firestore에서 업데이트
  Future<void> userGetX(String userUid) async {
    // Firestore collection reference
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');

    try {
      DocumentSnapshot document = await usersCollection.doc(userUid).get();
      if (document.exists) {
        Map<String, dynamic>? userDataMap =
            document.data() as Map<String, dynamic>?;
        userData.value = userDataMap ?? {}; // Update RxMap with Firestore data

        print('User data retrieved from Firestore: $userData');
      } else {
        print('User data not found in Firestore.');
      }
    } catch (e) {
      print('Error retrieving user data from Firestore: $e');
    }
  }

// 사용자 uid 업데이트 메서드
  void uidGetX(String uid) {
    userUid = uid;
  }

//Login 및 로그아웃 변경을 위한 스위칭
  void loginChange() {
    isLogin = !isLogin;

    update();
  }

  void inputChange() {
    isInput = !isInput;
    update();
  }
}
