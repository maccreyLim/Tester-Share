import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/getx.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/send_message_detail.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  @override
  State<SendScreen> createState() => _SendScreen();
}

class _SendScreen extends State<SendScreen> {
  // Property
  final controller = Get.put(ControllerGetX());

//파이어베이스 삭제
  Future<void> _deleteMessage(String messageId) async {
    try {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .delete();
    } catch (e) {
      print('메시지 삭제 오류: $e');
      throw e;
    }
  }

  // 받는사람 UID로 닉네임을 검색
  Future<String> getSenderNickname(String senderUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(senderUid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['nickName'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('보낸 사람의 닉네임을 찾을 수 없습니다.: $e');
      return 'Unknown';
    }
  }

  // 보낸사람 UID로 닉네임을 검색
  Future<String> getReceiverNickname(String receiverUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(receiverUid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['nickName'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('받는 사람의 닉네임을 찾을 수 없습니다.: $e');
      return 'Unknown';
    }
  }

//파이어베이스에서 받은메시지 검색
//파이어베이스에서 받은메시지 검색
  Stream<List<MessageModel>> getSendMessagesStream(String senderUid) {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      return messagesCollection
          .where('senderUid', isEqualTo: senderUid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap((querySnapshot) async {
        List<MessageModel> messages = [];
        for (var doc in querySnapshot.docs) {
          MessageModel message =
              MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

          // nickname 수정
          String senderNickname = await getSenderNickname(message.senderUid);
          message.senderNickname = senderNickname;
          String receiverNickname =
              await getReceiverNickname(message.senderUid);
          message.receiverNickname = receiverNickname;

          messages.add(message);
        }
        return messages;
      });
    } catch (e) {
      print('메시지 가져오기 오류: $e');
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Todo: 보낸 쪽지함 화면 구현
    return StreamBuilder<List<MessageModel>>(
      stream: getSendMessagesStream(controller.userUid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('메시지 가져오기 오류: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('메시지가 없습니다.');
        }

        List<MessageModel> messages = snapshot.data!;

        // 여기에서 메시지 목록을 사용하여 UI 업데이트 또는 다른 작업 수행
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.separated(
            itemCount: messages.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            itemBuilder: (context, index) {
              MessageModel message = messages[index];
              //작성시간과 얼마나 지났는지 표시를 위한 함수 구현
              final now = DateTime.now();
              final DateTime created = message.timestamp;
              final Duration difference = now.difference(created);

              String formattedDate;

              if (difference.inHours > 0) {
                formattedDate = '${difference.inHours}시간 전';
              } else if (difference.inMinutes > 0) {
                formattedDate = '${difference.inMinutes}분 전';
              } else {
                formattedDate = '방금 전';
              }
              return ListTile(
                title: message.isRead
                    ? Text(
                        'To : ${message.receiverNickname}   ($formattedDate)\n Read : 읽음',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : Text(
                        'To : ${message.receiverNickname}   ($formattedDate)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                subtitle: Text(
                  message.contents,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Get.to(SendMessageDetail(message: message, isSend: false));
                },
              );
            },
          ),
        );
      },
    );
  }
}
