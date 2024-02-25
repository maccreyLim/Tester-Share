import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/getx.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/receive_messager_detail.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class ReceivedMessageScreen extends StatefulWidget {
  const ReceivedMessageScreen({super.key});

  @override
  State<ReceivedMessageScreen> createState() => _ReceivedMessageScreen();
}

class _ReceivedMessageScreen extends State<ReceivedMessageScreen> {
  // Property
  final controller = Get.put(ControllerGetX());
  final ColorsCollection _color = ColorsCollection();

//파이어베이스 읽음 변경
  Future<void> updateisReadMessage(MessageModel message) async {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(message.id).update({'isRead': true});
    } catch (e) {
      print('메시지 업데이트 오류: $e');
      throw e; // 예외를 호출자에게 다시 던집니다.
    }
  }

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

  // 보낸사람 UID로 닉네임을 검색
  Future<String> getSenderNickname(String senderUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(senderUid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['profileName'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching sender nickName: $e');
      return 'Unknown';
    }
  }

  // 받은사람 UID로 닉네임을 검색
  Future<String> getReceiverNickname(String receiverUid) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(receiverUid)
          .get();

      if (userSnapshot.exists) {
        return userSnapshot['profileName'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching sender profileName: $e');
      return 'Unknown';
    }
  }

//파이어베이스에서 받은메시지 검색
  Stream<List<MessageModel>> getMessagesStream(String receiverUid) {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      return messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
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
    // Todo: 받은 쪽지함 화면 구현
    return StreamBuilder<List<MessageModel>>(
      stream: getMessagesStream(controller.userUid),
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
              color: _color.iconColor,
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
                // FlutterLocalNotification.showNotification(
                //     "${message.senderNickname}로 부터 쪽지가 왔습니다.",
                //     '1분이상 지났습니다.확인해주세요');
              } else {
                formattedDate = '방금 전';
                // FlutterLocalNotification.showNotification(
                //     "${message.senderNickname}로 부터 쪽지가 왔습니다.", '확인해주세요');
              }
              return ListTile(
                title: message.isRead
                    ? Text(
                        'From: ${message.senderNickname}   ($formattedDate)\n Read : 읽음',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      )
                    : Text(
                        'From: ${message.senderNickname}   ($formattedDate)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                subtitle: Text(
                  message.contents,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ), // 최대 줄 수를 3로 설정),
                trailing: IconButton(
                  onPressed: () async {
                    await _deleteMessage(message.id);
                    showToast('메시지가 삭제되었습니다.', 1);
                  },
                  icon: Icon(Icons.delete),
                ),
                onTap: () {
                  Get.to(ReceiveMessageDetail(message: message, isSend: false));
                  updateisReadMessage(message);
                },
              );
            },
          ),
        );
      },
    );
  }
}
