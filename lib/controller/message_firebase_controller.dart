import 'package:hive/hive.dart';
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

  // Hive 박스를 위한 변수 선언
  late Box<MessageModel> _messageBox;

  // Hive 초기화 및 박스 열기
  Future<void> initHive() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageModelAdapter()); // MessageModel Adapter 등록
    }
    _messageBox = await Hive.openBox<MessageModel>('messagesBox');
  }

  // Create
  Future<String> createMessage(MessageModel message, String nickname) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      final docRef = await messagesCollection.add(message.toMap());
      print(docRef);

      String id = docRef.id;

      // Firestore 문서 내에 ID 필드를 업데이트
      await docRef.update({'id': id});

      // Hive에도 메시지 저장
      message.id = id;
      await _messageBox.add(message);

      showToast('${nickname}에게 메시지를 보냈습니다.', 1);

      return id;
    } catch (e) {
      print('메시지 생성 중 오류: $e');
      throw e;
    } finally {
      Get.back();
    }
  }

  // Read (Firebase에서 가져온 메시지를 Hive에 저장)
  Future<List<MessageModel>> getMessages(String receiverUid) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      final querySnapshot = await messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .get();

      List<MessageModel> messages = querySnapshot.docs
          .map((doc) =>
              MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      // 가져온 메시지를 Hive에 저장
      for (var message in messages) {
        await _messageBox.put(message.id, message); // id를 key로 사용
      }

      return messages;
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      throw e;
    } finally {
      Get.back();
    }
  }

  // Read from Hive (로컬에서 메시지 읽기)
  List<MessageModel> getMessagesFromHive() {
    return _messageBox.values.toList(); // Hive에서 모든 메시지를 가져옵니다.
  }

  // Stream Read (실시간)
  Stream<List<MessageModel>> getMessagesStream(String receiverUid) {
    try {
      return messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((querySnapshot) {
        List<MessageModel> messages = querySnapshot.docs
            .map((doc) => MessageModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();

        // 실시간으로 Firebase에서 업데이트된 메시지를 Hive에도 저장
        for (var message in messages) {
          _messageBox.put(message.id, message);
        }

        return messages;
      });
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      return Stream.value([]);
    }
  }

  // Update (메시지 업데이트)
  Future<void> updateMessage(MessageModel message) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      await messagesCollection.doc(message.id).update(message.toMap());

      // Hive에도 메시지 업데이트
      await _messageBox.put(message.id, message);
    } catch (e) {
      print('메시지 업데이트 오류: $e');
      throw e;
    } finally {
      Get.back();
    }
  }

  // Delete (메시지 삭제)
  Future<void> deleteMessage(String messageId) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false,
    );
    try {
      await messagesCollection.doc(messageId).delete();

      // Hive에서 메시지 삭제
      await _messageBox.delete(messageId);
    } catch (e) {
      print('메시지 삭제 오류: $e');
      throw e;
    } finally {
      Get.back();
    }
  }

  // 메시지 읽음 처리
  Future<void> markMessageAsRead(MessageModel message) async {
    try {
      // Firestore에서 업데이트
      await messagesCollection.doc(message.id).update({'isRead': true});

      // Hive에서 업데이트
      message.isRead = true;
      await _messageBox.put(message.id, message);
    } catch (e) {
      print('메시지 읽음 처리 오류: $e');
    }
  }
}
