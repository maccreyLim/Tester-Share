import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class BugtodoReplyMessageScreen extends StatefulWidget {
  final String senderUid;
  final String receiverUid;
  final String reportProfile; // 신고 프로필 정보

  const BugtodoReplyMessageScreen({
    Key? key,
    required this.senderUid,
    required this.receiverUid,
    required this.reportProfile,
  }) : super(key: key);

  @override
  State<BugtodoReplyMessageScreen> createState() =>
      _BugtodoReplyMessageScreenState();
}

class _BugtodoReplyMessageScreenState extends State<BugtodoReplyMessageScreen> {
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController receiverUserController = TextEditingController();
  final InterstitialAdController adController = InterstitialAdController();
  final MassageFirebaseController _mfirebase = MassageFirebaseController();

  @override
  void dispose() {
    messageController.dispose();
    receiverUserController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  void _initializeForm() {
    receiverUserController.text = widget.reportProfile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.close,
              color: colors.iconColor,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(fontSize: 16, color: colors.textColor),
                  cursorHeight: 20,
                  maxLines: 1,
                  controller: receiverUserController,
                  readOnly: true, // 읽기 전용 설정
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: tr("Recipient"),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  style: TextStyle(fontSize: 16, color: colors.textColor),
                  cursorHeight: 20,
                  maxLines: 10,
                  controller: messageController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: tr("Message"),
                  ),
                  maxLength: 250,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return tr("Please enter a message");
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      adController.loadAndShowAd();
                      if (_formKey.currentState!.validate()) {
                        MessageModel message = MessageModel(
                          senderUid: widget.senderUid,
                          receiverUid: widget.receiverUid,
                          contents: messageController.text,
                          timestamp: DateTime.now(),
                        );
                        _mfirebase.createMessage(
                            message, receiverUserController.text);
                        Get.off(const MessageStateScreen());
                      }
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.buttonColor,
                    ),
                    child: Text(
                      'Send',
                      style: TextStyle(
                        color: colors.iconColor,
                        fontSize: _fontSizeCollection.buttonFontSize,
                      ),
                    ).tr(),
                  ),
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
