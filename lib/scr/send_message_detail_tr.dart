import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/scr/my_tester_request_post_tr.dart';
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
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final InterstitialAdManager adController = InterstitialAdManager();
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
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          'Sender',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                          // textAlign: TextAlign.start,
                        ).tr(),
                        Text(
                          ' : ${widget.message.receiverNickname}',
                          style:
                              const TextStyle(fontSize: 20, color: Colors.grey),
                          // textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
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
              const SizedBox(height: 50),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton.icon(
                  onPressed: () async {
                    adController.loadAndShowAd();
                    await _deleteMessage(widget.message.id);
                    showToast(tr("The message has been deleted"), 1);

                    Get.to(const MessageStateScreen());
                  },
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: widget.message.isRead
                        ? const Text(
                            "Delete",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ).tr()
                        : const Text(
                            "The unread messages",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ).tr(),
                  ),
                  icon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
}
