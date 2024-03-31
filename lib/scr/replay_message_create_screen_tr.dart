import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class ReplayMessageCreateScreen extends StatefulWidget {
  final MessageModel message;

  const ReplayMessageCreateScreen({Key? key, required this.message})
      : super(key: key);

  @override
  _ReplayMessageCreateScreenState createState() =>
      _ReplayMessageCreateScreenState();
}

class _ReplayMessageCreateScreenState extends State<ReplayMessageCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  MassageFirebaseController messageService = MassageFirebaseController();
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fonts = FontSizeCollection();
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Recipient",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ).tr(),
                    Text(
                      ' : ${widget.message.receiverNickname}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "The original message",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ).tr(),
                Divider(),
                const SizedBox(height: 6),
                Text(
                  widget.message.contents,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const Divider(),
                const SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(fontSize: 16, color: _colors.textColor),
                  cursorHeight: 20,
                  maxLines: 10,
                  maxLength: 100,
                  controller: messageController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: tr("The reply content"),
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return tr("Please enter the reply content");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      MessageModel replyMessage = MessageModel(
                        senderUid: widget.message.receiverUid,
                        receiverUid: widget.message.senderUid,
                        contents: messageController.text,
                        timestamp: DateTime.now(),
                      );
                      // MessageFirebase에서 답장 메시지 등록
                      MassageFirebaseController().createMessage(
                          replyMessage, widget.message.receiverNickname);
                      Get.off(const MessageStateScreen());
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colors.buttonColor,
                    minimumSize: Size(
                      double.infinity,
                      _fonts.buttonSize,
                    ),
                  ),
                  child: Text(
                    'To send a reply',
                    style: TextStyle(
                        fontSize: _fonts.buttonFontSize,
                        color: _colors.iconColor),
                  ).tr(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
