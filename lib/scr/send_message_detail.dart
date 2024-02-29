import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
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
  ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  // bool isLongPressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.close,
              color: _colors.iconColor,
            ),
          )
        ],
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
              SizedBox(height: 20),
              SingleChildScrollView(
                child: Container(
                    color: _colors.background,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.height * 1,
                    child: Text(
                      widget.message.contents,
                      style: TextStyle(fontSize: 20, color: _colors.textColor),
                    )),
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 40,
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
                        ? const Text(
                            'Delete',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          )
                        : const Text(
                            '아직 읽지않은 메시지',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                  ),
                  icon: const Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.redAccent),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _colors.buttonColor,
                      minimumSize: Size(MediaQuery.of(context).size.width * 1,
                          _fontSizeCollection.buttonSize))),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: BannerAD()),
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
