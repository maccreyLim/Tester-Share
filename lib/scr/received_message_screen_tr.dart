import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/receive_message_detail_tr.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class ReceivedMessageScreen extends StatefulWidget {
  const ReceivedMessageScreen({super.key});

  @override
  State<ReceivedMessageScreen> createState() => _ReceivedMessageScreen();
}

class _ReceivedMessageScreen extends State<ReceivedMessageScreen> {
  // Property
  final AuthController _authController = AuthController.instance;
  final ColorsCollection _color = ColorsCollection();
  final InterstitialAdController adController = InterstitialAdController();

//파이어베이스 읽음 변경
  Future<void> updateisReadMessage(MessageModel message) async {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      await messagesCollection.doc(message.id).update({'isRead': true});
    } catch (e) {
      rethrow; // 예외를 호출자에게 다시 던집니다.
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
      rethrow;
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
      return 'Unknown';
    }
  }

//파이어베이스에서 받은메시지 검색
  Stream<List<MessageModel>> getMessagesStream(String receiverUid) {
    CollectionReference messagesCollection =
        FirebaseFirestore.instance.collection('messages');
    try {
      // receiverUid가 null이 아닌 경우에만 처리
      return messagesCollection
          .where('receiverUid', isEqualTo: receiverUid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .asyncMap((querySnapshot) async {
        List<MessageModel> unreadMessages = [];
        List<MessageModel> readMessages = [];

        for (var doc in querySnapshot.docs) {
          MessageModel message =
              MessageModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);

          // nickname 수정
          String senderNickname = await getSenderNickname(message.senderUid);
          message.senderNickname = senderNickname;
          String receiverNickname =
              await getReceiverNickname(message.senderUid);
          message.receiverNickname = receiverNickname;

          if (message.isRead == false) {
            unreadMessages.add(message);
          } else {
            readMessages.add(message);
          }
        }

        // isRead가 false인 메시지를 먼저 표시하고, 그 다음에 isRead가 true인 메시지를 표시
        unreadMessages.addAll(readMessages);

        return unreadMessages;
      });
    } catch (e) {
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Todo: 받은 쪽지함 화면 구현
    return Column(
      children: [
        SizedBox(
          height: 594,
          child: StreamBuilder<List<MessageModel>>(
            stream: getMessagesStream(_authController.userData!['uid']),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('메시지 가져오기 오류: ${snapshot.error}');
                return Text('메시지 가져오기 오류: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text(
                  "No messages available",
                  style: TextStyle(color: _color.iconColor),
                ).tr();
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
                    String minutes = tr("minutes ago");
                    String hours = tr("hours ago");
                    String days = tr("days ago");

                    if (difference.inDays > 0) {
                      // Display the number of days elapsed
                      formattedDate = '${difference.inDays} $days';
                    } else if (difference.inHours > 0) {
                      formattedDate = '${difference.inHours} $hours';
                    } else if (difference.inMinutes >= 20) {
                      formattedDate = '${difference.inMinutes} $minutes';
                    } else {
                      formattedDate = tr('Just now');
                    }
                    return ListTile(
                      title: message.isRead
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      'Sender',
                                      style: TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ).tr(),
                                    Text(
                                      ' : ${message.senderNickname}   ($formattedDate)',
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const Text(
                                  "This is a read message",
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ).tr(),
                              ],
                            )
                          : Text(
                              'From: ${message.senderNickname}   ($formattedDate)',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                      subtitle: Text(
                        message.contents,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white),
                      ), // 최대 줄 수를 3로 설정),
                      trailing: IconButton(
                        onPressed: () async {
                          adController.loadAndShowAd();
                          await _deleteMessage(message.id);
                          showToast(tr("The message has been deleted"), 1);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                      onTap: () {
                        Get.to(ReceiveMessageDetail(
                            message: message, isSend: false));
                        updateisReadMessage(message);
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
