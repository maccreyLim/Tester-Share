import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class MassageFirebaseController {
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  final AuthController _authController = AuthController.instance;

//Create
  Future<String> createMessage(MessageModel message, String nickname) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      final docRef = await messagesCollection.add(message.toMap()); // 수정된 부분
      print(docRef);

      String id = docRef.id;

      // Firestore 문서 내에 ID 필드를 업데이트
      await docRef.update({'id': id});
      showToast('${nickname}에게 메시지를 보냈습니다.', 1);

      return id;
    } catch (e) {
      print('메시지 생성 중 오류: $e');
      throw e;
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

  //Read
  Future<List<MessageModel>> getMessages(String receiverUid) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    try {
      final querySnapshot = await messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

// Stream Read(실시간)
  Stream<List<MessageModel>> getMessagesStream(String receiverUid) {
    try {
      CollectionReference messagesCollection =
          FirebaseFirestore.instance.collection('messages');
      return messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      });
    } catch (e) {
      // 오류가 발생한 경우 오류를 출력하고 빈 Stream을 반환
      print('메시지 가져오기 오류: $e');
      return Stream.value([]);
    }
  }

//Update
  Future<void> updateMessage(MessageModel message) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(message.id).update(message.toMap());
    } catch (e) {
      print('메시지 업데이트 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

//Delete
  Future<void> deleteMessage(String messageId) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
    );
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(messageId).delete();
    } catch (e) {
      print('메시지 삭제 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    } finally {
      // 데이터 추가가 완료된 후에 로딩 인디케이터를 숨깁니다.
      Get.back();
    }
  }

//상대방을 닉네임로 검색
  Future<Map<String, Map<String, dynamic>>> getUserByNickname(
      String partialNickname) async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    try {
      final querySnapshot = await usersCollection
          .where('profileName', isGreaterThanOrEqualTo: partialNickname)
          .where('profileName', isLessThan: partialNickname + 'z')
          .get();

      final userData = <String, Map<String, dynamic>>{};

      for (final document in querySnapshot.docs) {
        final userDataFromDoc = document.data() as Map<String, dynamic>;
        final uid = userDataFromDoc['uid'];
        final profileName = userDataFromDoc['profileName'];
        final occupation = userDataFromDoc['occupation'];
        final workspace = userDataFromDoc['workspace'];
        final photoUrl = userDataFromDoc['photoUrl'];
        final parters = userDataFromDoc['parters'];

        if (uid != null && profileName != null) {
          userData[uid] = {
            'profileName': profileName,
            'photoUrl': photoUrl,
            'uid': uid,
            'occupation': occupation,
            'workspace': workspace,
            'parters': parters,
          };
        }
      }
      return userData;
    } catch (e) {
      print('사용자 검색 중 오류 발생: $e');
      return {}; // 예외 발생 시 빈 맵 반환
    }
  }

  //메시지 갯수를 스트림으로 확인
  Stream<int> getUnreadMessageCountStream() {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    try {
      Stream<QuerySnapshot> snapshots = _firestore
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .where('receiverUid', isEqualTo: _authController.userData!['uid'])
          .snapshots();

      return snapshots.map((QuerySnapshot querySnapshot) {
        return querySnapshot.size;
      });
    } catch (e) {
      print('오류 발생: $e');
      // 오류 처리 코드를 추가하거나 throw로 예외를 다시 던질 수 있습니다.
      throw e;
    }
  }
}
