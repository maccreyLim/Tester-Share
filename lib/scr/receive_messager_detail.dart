import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/scr/replay_message_create_screen.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class ReceiveMessageDetail extends StatefulWidget {
  const ReceiveMessageDetail({Key? key, required this.message, required isSend})
      : super(key: key);
  final MessageModel message;

  @override
  State<ReceiveMessageDetail> createState() => _ReceiveMessageDetailState();
}

class _ReceiveMessageDetailState extends State<ReceiveMessageDetail> {
  final bool isSend = false;
  bool isLongPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Message Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '받는 사람 : ${widget.message.senderNickname}',
                      style: const TextStyle(fontSize: 24, color: Colors.grey),
                      // textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '보낸 사람 : ${widget.message.receiverNickname}',
                      style: const TextStyle(fontSize: 24, color: Colors.black),
                      // textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                child: Container(
                    color: Colors.grey[100],
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.height * 1,
                    child: Text(
                      widget.message.contents,
                      style: const TextStyle(fontSize: 20),
                    )),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                  onPressed: () {
                    //firebase에서 답장
                    Get.to(
                      ReplayMessageCreateScreen(message: widget.message),
                    );
                  },
                  label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isLongPressed
                          ? const Text(
                              'Replay',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            )
                          : const Text(
                              'Replay',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            )),
                  icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isLongPressed
                          ? const Icon(
                              Icons.send,
                              color: Colors.blueAccent,
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.grey,
                            )),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 1, 48))),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isLongPressed = !isLongPressed;
                      print(isLongPressed);
                    });
                  },
                  onLongPress: () async {
                    //firebase에서 삭제

                    await _deleteMessage(widget.message.id);
                    showToast('메시지가 삭제되었습니다.', 1);
                    Get.to(const MessageStateScreen());
                  },
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: isLongPressed
                        ? const Text(
                            'Delete',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          )
                        : const Text(
                            '길게 누르세요',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete,
                        color: isLongPressed ? Colors.grey : Colors.redAccent),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 1, 48)))
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _deleteMessage(String messageId) async {
  try {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(messageId)
        .delete();
  } catch (e) {
    print('메시지 삭제 오류: $e');
    rethrow;
  }
}
