import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/user_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen_tr.dart';
import 'package:tester_share_app/scr/login_screen_tr.dart';
import 'package:tester_share_app/scr/re_wellcome_message_screen.dart';
import 'package:tester_share_app/scr/wellcome_join_message_screen.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class AuthController extends GetxController {
  final FirebaseAuth authentication = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // GetX 전역 함수로 사용하기 위한 인스턴스
  static AuthController instance = Get.find();

  RxInt messageCount = 0.obs;
  bool isLogin = false; // 로그인 상태 확인
  bool isInput = false; // E-Mail 검증 완료 여부

  late Rx<User?> _user;
  late Rx<Map<String, dynamic>?> _userData = Rx<Map<String, dynamic>?>(null);

  User? get currentUser => _user.value;
  Map<String, dynamic>? get userData => _userData.value;

  RxBool isReleaseFirebase = false.obs;

  // StreamController for user data updates
  final StreamController<Map<String, dynamic>?> _userDataStreamController =
      StreamController<Map<String, dynamic>?>.broadcast();

  // Stream for listening to user data updates
  Stream<Map<String, dynamic>?> get userDataStream =>
      _userDataStreamController.stream;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(authentication.currentUser);
    _userData = Rx<Map<String, dynamic>?>(null); // 초기화

    ever(_user, _initialScreen);

    _user.bindStream(authentication.authStateChanges());

    // 주기적으로 토큰 갱신
    Timer.periodic(Duration(minutes: 55), (_) => refreshToken());
  }

  @override
  void onClose() {
    _userDataStreamController.close();
    super.onClose();
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      await refreshToken(); // 앱 시작 시 토큰 갱신
      if (user.emailVerified) {
        _updateUserData(user);
        Get.offAll(() => HomeScreen());
      } else {
        Get.offAll(() => WellcomeJoinMessageScreen());
      }
    }
  }

  Future<void> _updateUserData(User? user) async {
    if (user != null) {
      try {
        _firestore
            .collection('users')
            .doc(user.uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            Map<String, dynamic>? userData =
                snapshot.data() as Map<String, dynamic>?;
            if (userData != null) {
              _userData.value = userData;
              _userDataStreamController.add(userData);
              update();
            } else {
              print("사용자 정보가 없습니다.");
            }
          } else {
            print("사용자 문서가 존재하지 않습니다.");
            signOut(); // 사용자 문서가 없으면 로그아웃
          }
        });
      } catch (e) {
        print('사용자 데이터 업데이트 중 오류 발생: $e');
        signOut(); // 오류 발생 시 로그아웃
      }
    }
  }

  //토큰 갱신 메서드
  Future<void> refreshToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult(true);
      String? newToken = tokenResult.token;
      print("Token refreshed: $newToken");
    }
  }

  // 사용자 데이터 가져오기
  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (userSnapshot.exists && userSnapshot.data() != null) {
        return userSnapshot.data() as Map<String, dynamic>?;
      } else {
        print('사용자 데이터가 없습니다.');
        return null;
      }
    } catch (e) {
      print('사용자 데이터를 가져오는 중 오류 발생: $e');
      return null;
    }
  }

  // 회원가입
  Future<void> signUp(
    String email,
    String password,
    String profileName,
    int deployed,
  ) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      UserCredential userCredential =
          await authentication.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 인증 이메일 보내기
      await userCredential.user?.sendEmailVerification();

      // Firestore에 사용자 정보 저장
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user?.uid,
        'email': email,
        'isAdmin': false,
        'profileName': profileName,
        'ProfileImageUrl': null,
        'deployed': deployed,
        'testerParticipation': 0,
        'testerRequest': 0,
        'createAt': DateTime.now(),
        'point': 10,
      });
    } on FirebaseAuthException catch (e) {
      // FirebaseAuthException에서 발생한 특정 오류 처리
      handleAuthException(e);
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
      // 회원가입 성공 시, 여기에서 다른 동작을 추가할 수 있습니다.
      Get.to(() => const WellcomeJoinMessageScreen());
    }
  }

  // 로그인
  Future<void> signIn(String email, String password) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );

    try {
      UserCredential userCredential =
          await authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        Get.back();
        print("로그인 중 사용자 정보가 null입니다.");
        showToast("로그인 중 사용자 정보가 null입니다.", 2);
        return;
      }

      print("로그인이 되어 user정보를 받음 $user");

      if (!user.emailVerified) {
        await user.sendEmailVerification();
        Get.to(() => ReWellcomeMessageScreen());
      } else {
        Map<String, dynamic>? userData = await _getUserData(user.uid);

        if (userData != null) {
          loginChange();
          _userData.value = userData;
          Get.off(() => HomeScreen());
        } else {
          Get.back();
          print("사용자 정보가 없습니다.");
          showToast("사용자 정보가 없습니다.", 2);
        }
      }
    } on FirebaseAuthException catch (e) {
      handleAuthException(e);
    } catch (e) {
      Get.back();
      print("로그인 중 오류 발생: $e");
      showToast("로그인 중 오류 발생: $e", 2);
    }
  }

  // FirebaseAuthException에서 발생한 특정 오류 처리
  void handleAuthException(FirebaseAuthException e) {
    String errorMessage = '';

    switch (e.code) {
      case 'email-already-in-use':
        errorMessage = 'The email address is already in use.';
        break;
      case 'network-request-failed':
        errorMessage = 'A network error occurred.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is invalid.';
        break;
      case 'user-not-found':
        errorMessage = 'User not found.';
        break;
      case 'email-not-verified':
        errorMessage =
            'The email address is not verified. Resending the verification email.';
        // Additional functionality to prompt user to resend verification email
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password.';
        break;
      case 'user-not-found':
        errorMessage = 'The email address is not registered.';
        break;
      case 'network-request-failed':
        errorMessage =
            'A network error occurred. Please check your internet connection.';
        break;
      default:
        errorMessage = 'An unknown error occurred: ${e.code}';
    }
    Get.back();
    // 오류 메시지를 보여주는 토스트 또는 다른 방식의 알림을 사용할 수 있습니다.
    showToast(errorMessage, 2);
  }

  // 로그아웃
  Future<void> signOut() async {
    try {
      // Firebase Authentication을 사용하여 로그아웃
      await authentication.signOut();

      // 로그아웃 성공 시 _user 및 _userData 값을 갱신
      _user.value = null;
      _userData.value = null;

      // 로그아웃 성공 시 추가적인 작업이 필요하다면 여기에 추가
      loginChange();
    } catch (e) {
      // 로그아웃 중 에러 발생 시
      print('로그아웃 중 오류 발생: $e');
      // 에러를 사용자에게 알리거나 추가적인 조치를 취할 수 있음
      // 예를 들어, 에러 메시지를 사용자에게 보여주는 토스트 메시지 표시 등
    }
  }

  // 사용자 계정 삭제 및 관련 데이터 삭제
  Future<void> deleteAccount() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      // 현재 사용자 정보를 가져옴
      User? user = authentication.currentUser;

      // Firestore에서 참조를 만듭니다.
      final userRef = _firestore.collection('users').doc(user?.uid);

      // 최근에 로그인한 상태인지 확인
      if (user != null && user.metadata.lastSignInTime != null) {
        // Firestore에서 사용자 데이터 가져오기
        Map<String, dynamic>? userData = await _getUserData(user.uid);

        // 사용자 데이터가 있는 경우
        if (userData != null) {
          // 사용자 정보를 Rx 변수에 저장
          _userData.value = userData;
        }

        // Firestore에서 사용자 데이터 삭제 (필요한 경우)
        await userRef.delete();
        // Firestore의 하위 컬렉션 삭제
        await _deleteCollection(userRef.collection('diaries'));
        await _deleteCollection(userRef.collection('release'));
        // Firebase Storage에서 관련 데이터 삭제
        await deleteUserDataFromStorage(user.uid);

        // 사용자 계정 삭제
        await user.delete();

        // 계정 삭제 후 로그인 화면으로 이동
        Get.off(() => const LoginScreen());

        // 계정 삭제 이후 추가 작업이 필요한 경우 여기에 수행
      } else {
        // 최근에 로그인하지 않은 경우에 대한 처리
        // 예를 들어, 사용자에게 로그인을 유도하는 메시지를 표시하거나, 다시 로그인 페이지로 이동
        showToast("다시 로그인한 후에 시도해주세요.", 2);
        Get.off(() => const LoginScreen());
      }
    } catch (e) {
      // 오류 처리
      print('계정 삭제 중 오류 발생: $e');
      // 사용자에게 오류 메시지 표시 또는 필요한 추가 작업 수행
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

  // Firebase Storage에서 사용자 데이터 삭제
  Future<void> deleteUserDataFromStorage(String userId) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      // Firebase Storage에서 데이터에 대한 참조를 만듭니다.
      final ref = _storage.ref().child('images/$userId');

      // 디렉터리 내의 모든 파일에 대한 참조 목록을 가져옵니다.
      final ListResult result = await ref.listAll();

      // 모든 파일을 삭제합니다.
      await Future.forEach(result.items, (Reference item) async {
        await item.delete();
      });

      // 데이터를 삭제합니다.
      await ref.delete();
      print("회원탈퇴 이미지가 삭제되었습니다.");
    } catch (e) {
      // 오류를 처리합니다. 예를 들어 오류 메시지를 출력할 수 있습니다.
      print('Firebase Storage에서 데이터를 삭제하는 중 오류 발생: $e');
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

  // Firestore의 컬렉션 삭제
  Future<void> _deleteCollection(
      CollectionReference collectionReference) async {
    // 컬렉션에 대한 모든 문서를 가져옵니다.
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await collectionReference.get() as QuerySnapshot<Map<String, dynamic>>;

    // 만약 문서가 하나도 없으면 함수를 종료합니다.
    if (snapshot.docs.isEmpty) {
      print('컬렉션에 문서가 없습니다.');
      return;
    }

    // 각 문서에 대해 삭제 작업을 수행합니다.
    for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // 비밀번호 재설정 이메일 보내기
  Future<void> forgotPassword(String email) async {
    // 사용자 인증
    final auth = FirebaseAuth.instance;
    // 비밀번호 재설정 메일 전송
    await auth.sendPasswordResetEmail(email: email);
  }

  // 비밀번호 변경
  Future<void> changePassword(
      String email, String currentPassword, String newPassword) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      // 현재 로그인한 사용자 가져오기
      User? user = FirebaseAuth.instance.currentUser;

      // 현재 사용자가 null이 아니면서 이메일이 일치할 경우에만 비밀번호 변경 수행
      if (user != null && user.email == email) {
        // 사용자의 현재 비밀번호를 사용하여 로그인
        AuthCredential credential = EmailAuthProvider.credential(
            email: email, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        // 새 비밀번호로 변경
        await user.updatePassword(newPassword);

        print('비밀번호가 성공적으로 변경되었습니다.');
      } else {
        print('사용자 정보가 일치하지 않습니다.');
      }
    } catch (e) {
      print('비밀번호 변경 중 오류 발생: $e');
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

  //message Count
  void setMessageCount(int count) {
    messageCount.value = count;
  }

  // //Login 및 로그아웃 변경을 위한 스위칭
  void loginChange() {
    isLogin = !isLogin;

    update();
  }

  //프로필이름 중복확인
  Future<bool> isProfileNameAvailable(String profileName) async {
    try {
      // Firestore에서 해당 프로필 이름이 있는지 확인
      final querySnapshot = await _firestore
          .collection('users')
          .where('profileName', isEqualTo: profileName)
          .get();

      // 해당 프로필 이름이 사용 가능한지 여부를 반환
      return querySnapshot.docs.isEmpty;
    } catch (e) {
      // 오류 처리
      print('Error checking profile name availability: $e');
      return false; // 오류가 발생하면 일단 중복이 아닌 것으로 간주
    }
  }

  // 사용자 데이터를 업데이트하는 메서드
  Future<void> updateUserData(String uid, Map<String, dynamic> newData) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      // 사용자가 로그인되어 있는지 확인
      User? user = authentication.currentUser;
      if (user != null) {
        // Firestore의 "users" 컬렉션에서 사용자 문서 참조 가져오기
        DocumentReference userDocRef = _firestore.collection('users').doc(uid);

        // 사용자 데이터 업데이트
        await userDocRef.set(newData, SetOptions(merge: true));
        print("사용자 데이터가 업데이트되었습니다.");
      } else {
        print("사용자가 로그인되어 있지 않습니다.");
      }
    } catch (e) {
      print("사용자 데이터 업데이트 중 오류가 발생했습니다: $e");
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

  //uid를 통해 userData를 가지고 오는 메소드
  Future<UserFirebaseModel?> getUserData(String uid) async {
    try {
      // 로딩 인디케이터 표시
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Firebase에서 사용자 데이터 가져오기
      DocumentSnapshot userDataSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      // 사용자 데이터가 있는지 확인
      if (userDataSnapshot.exists) {
        // 사용자 데이터를 UserFirebaseModel 객체로 변환하여 반환
        Get.back(); // 로딩 인디케이터 닫기
        return UserFirebaseModel(
          uid: uid,
          email: userDataSnapshot['email'], // email 가져오기
          isAdmin: userDataSnapshot['isAdmin'], // isAdmin 가져오기
          profileName: userDataSnapshot['profileName'], // profileName 가져오기
          // profileImageUrl:
          //     userDataSnapshot['profileImageUrl'] ?? "", // profileImageUrl 가져오기
          deployed: userDataSnapshot['deployed'], // deployed 가져오기
          testerParticipation: userDataSnapshot[
              'testerParticipation'], // testerParticipation 가져오기 (nullable)
          testerRequest: userDataSnapshot[
              'testerRequest'], // testerRequest 가져오기 (nullable)
          createAt: userDataSnapshot['createAt'].toDate(), // createAt 가져오기
          // updateAt: userDataSnapshot['updateAt'] != null
          //     ? userDataSnapshot['updateAt'].toDate()
          //     : null, // updateAt 가져오기 (nullable)
          point: userDataSnapshot['point'], // point 가져오기 (nullable)
        );
      } else {
        // 사용자 데이터가 없으면 null 반환
        Get.back(); // 로딩 인디케이터 닫기
        return null;
      }
    } catch (e) {
      // 오류 발생 시 예외 처리
      Get.back(); // 로딩 인디케이터 닫기
      print("사용자 데이터를 가져오는 중 오류 발생 : $e");
      return null;
    }
  }

//프로필이름으로 uid가지고 오기
  Future<String?> getUidFromProfileName(String profileName) async {
    try {
      // 로딩 인디케이터 표시
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Firebase에서 사용자 데이터 가져오기
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('profileName', isEqualTo: profileName)
          .get();

      // 쿼리 결과 확인
      if (querySnapshot.docs.isNotEmpty) {
        // 사용자 데이터가 있는 경우 첫 번째 문서의 UID 반환
        Get.back(); // 로딩 인디케이터 닫기
        return querySnapshot.docs.first.id;
      } else {
        // 사용자 데이터가 없으면 null 반환
        Get.back(); // 로딩 인디케이터 닫기
        return null;
      }
    } catch (e) {
      // 오류 발생 시 예외 처리
      Get.back(); // 로딩 인디케이터 닫기
      print("사용자 UID를 가져오는 중 오류 발생 : $e");
      return null;
    }
  }
}
