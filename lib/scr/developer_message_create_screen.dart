import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class DeveloperMessageCreateScreen extends StatefulWidget {
  const DeveloperMessageCreateScreen(
      {super.key,
      required this.receiverUid,
      required this.developer,
      this.message});
  final String receiverUid; // 수신자의 UID를 저장하는 변수
  final String developer; // 수신자 이름
  final String? message;

  @override
  State<DeveloperMessageCreateScreen> createState() =>
      _DeveloperMessageCreateScreenState();
}

class _DeveloperMessageCreateScreenState
    extends State<DeveloperMessageCreateScreen> {
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final _formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController sendUserController = TextEditingController();

  final _seach = SearchController();
  final MassageFirebaseController _mfirebase =
      MassageFirebaseController(); // MessageFirebase 클래스의 인스턴스 생성
  Map<String, dynamic> searchResults = {}; // 검색 결과를 저장할 변수
  final AuthController _authController = AuthController.instance;

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    sendUserController.dispose();
    _seach.dispose();
  }

  @override
  void initState() {
    sendUserController.text = widget.developer;
    messageController.text = widget.message ?? ''; // 옵셔널한 메시지에 대한 처리
    super.initState();
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
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: colors.textColor),
                    cursorHeight: 20,
                    maxLines: 1,
                    controller: sendUserController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: "보낼사람",
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "보낼사람을 입력해주세요";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: colors.textColor),
                    cursorHeight: 20,
                    maxLines: 10,
                    controller: messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: "메시지",
                    ),
                    maxLength: 100,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "메시지를 입력해주세요";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //  Todo: MessageFirebase에서 메시지 등록
                        if (_formkey.currentState!.validate()) {
                          MessageModel message = MessageModel(
                              senderUid: _authController.userData!['uid'],
                              receiverUid: widget.receiverUid,
                              contents: messageController.text,
                              timestamp: DateTime.now());
                          _mfirebase.createMessage(
                              message, sendUserController.text);
                          Get.off(const MessageStateScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.buttonColor,
                      ),
                      child: Text(
                        '보내기',
                        style: TextStyle(
                            color: colors.iconColor,
                            fontSize: _fontSizeCollection.buttonFontSize),
                      ),
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
        ));
  }
}
