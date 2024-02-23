import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class SendMessageDetail extends StatefulWidget {
  const SendMessageDetail({Key? key, required this.message, required isSend})
      : super(key: key);
  final MessageModel message;

  @override
  State<SendMessageDetail> createState() => _SendMessageDetailState();
}

class _SendMessageDetailState extends State<SendMessageDetail> {
  final bool isSend = false;
  // bool isLongPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sended Message Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '받는 사람 : ${widget.message.senderNickname}',
                      style: const TextStyle(fontSize: 20, color: Colors.grey),
                      // textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '보낸 사람 : ${widget.message.receiverNickname}',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      // textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              SingleChildScrollView(
                child: Container(
                    color: Colors.grey[100],
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.height * 1,
                    child: Text(
                      widget.message.contents,
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              SizedBox(height: 50),
              // ElevatedButton.icon(
              //     onPressed: () {
              //       //firebase에서 답장
              //     },
              //     label: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 20),
              //         child: Text(
              //           'Replay',
              //           style: TextStyle(
              //               fontSize: 20,
              //               fontWeight: FontWeight.bold,
              //               color: Colors.blueAccent),
              //         )),
              //     icon: Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 20),
              //         child: Icon(
              //           Icons.send,
              //           color: Colors.blueAccent,
              //         )),
              //     style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.white,
              //         minimumSize:
              //             Size(MediaQuery.of(context).size.width * 1, 48))),
              SizedBox(
                height: 16,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    await _deleteMessage(widget.message.id);
                    showToast('메시지가 삭제되었습니다.', 1);

                    Get.to(MessageStateScreen());
                  },
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: widget.message.isRead
                        ? Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          )
                        : Text(
                            '아직 읽지않은 메시지',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                  ),
                  icon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.redAccent),
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
    throw e;
  }
}
