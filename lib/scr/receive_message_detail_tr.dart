import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/replay_message_create_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

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
  final ColorsCollection _colors = ColorsCollection();

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
                    // Row(
                    //   children: [
                    //     const Text(
                    //       "Sender",
                    //       style:
                    //           const TextStyle(fontSize: 24, color: Colors.grey),
                    //       // textAlign: TextAlign.start,
                    //     ).tr(),
                    //     Text(
                    //       ': ${widget.message.senderNickname}',
                    //       style:
                    //           const TextStyle(fontSize: 24, color: Colors.grey),
                    //       // textAlign: TextAlign.start,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Text(
                          "Sender",
                          style: TextStyle(fontSize: 24, color: Colors.grey),
                          // textAlign: TextAlign.start,
                        ).tr(),
                        Text(
                          ' : ${widget.message.receiverNickname}',
                          style:
                              const TextStyle(fontSize: 24, color: Colors.grey),
                          // textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    color: _colors.background,
                    width: MediaQuery.of(context).size.height * 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.message.contents,
                        style:
                            TextStyle(fontSize: 20, color: _colors.textColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
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
                              "To send a reply",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ).tr()
                          : const Text(
                              "To send a reply",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ).tr()),
                  icon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: isLongPressed
                          ? Icon(
                              Icons.send,
                              color: _colors.iconColor,
                            )
                          : const Icon(
                              Icons.send,
                              color: Colors.grey,
                            )),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _colors.buttonColor,
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 1, 48))),
              const SizedBox(height: 10),
              SizedBox(width: double.infinity, child: BannerAD()),
            ],
          ),
        ),
      ),
    );
  }
}
