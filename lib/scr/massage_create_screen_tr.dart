import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/scr/my_tester_request_post_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class MessageCreateScreen extends StatefulWidget {
  const MessageCreateScreen({super.key});

  @override
  State<MessageCreateScreen> createState() => _MessageCreateScreenState();
}

class _MessageCreateScreenState extends State<MessageCreateScreen> {
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController sendUserController = TextEditingController();
  final TextEditingController _search = TextEditingController();
  String receiverUid = ''; // 수신자의 UID를 저장하는 변수
  final _seach = SearchController();
  final MassageFirebaseController _mfirebase =
      MassageFirebaseController(); // MessageFirebase 클래스의 인스턴스 생성
  Map<String, dynamic> searchResults = {}; // 검색 결과를 저장할 변수
  final AuthController _authController = AuthController.instance;
  final InterstitialAdManager adController = InterstitialAdManager();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    sendUserController.dispose();
    _seach.dispose();
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TextField(
                      controller: _search,
                      decoration: InputDecoration(
                        hintText: tr("Member Search"),
                        hintStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.black, // 배경색 변경
                        border: const UnderlineInputBorder(
                            // 경계선 스타일 변경
                            // borderRadius:
                            //     BorderRadius.circular(25), // 텍스트 필드의 각도를 설정
                            borderSide: BorderSide(color: Colors.white)),
                      ),
                      style: TextStyle(color: colors.textColor),
                      onChanged: (v) async {
                        Map<String, dynamic> results =
                            await _mfirebase.getUserByNickname(v);
                        setState(() {
                          searchResults = results;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text(
                    "Search Results",
                    style: TextStyle(color: colors.textColor),
                  ).tr(),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final user = searchResults.keys.elementAt(index);
                      final userData = searchResults[user];

                      final nickname = userData['profileName'] as String;

                      return ListTile(
                          title: Text(nickname,
                              style: TextStyle(color: colors.textColor)),
                          onTap: () {
                            setState(() {
                              sendUserController.text = nickname;
                              //UID 저장
                              receiverUid = user;
                            });
                          },
                          leading: Icon(Icons.person_add));
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: colors.textColor),
                    cursorHeight: 20,
                    maxLines: 1,
                    controller: sendUserController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: tr("Recipient"),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return tr("Please enter the recipient");
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: TextStyle(fontSize: 16, color: colors.textColor),
                    cursorHeight: 20,
                    maxLines: 10,
                    controller: messageController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: tr("Message"),
                    ),
                    maxLength: 100,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return tr("Please enter a message");
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        adController.loadAndShowAd();
                        //  Todo: MessageFirebase에서 메시지 등록
                        if (_formkey.currentState!.validate()) {
                          MessageModel message = MessageModel(
                              senderUid: _authController.userData!['uid'],
                              receiverUid: receiverUid,
                              contents: messageController.text,
                              timestamp: DateTime.now());
                          _mfirebase.createMessage(
                              message, sendUserController.text);
                          Get.off(MessageStateScreen());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.buttonColor,
                      ),
                      child: Text(
                        'Send',
                        style: TextStyle(
                            color: colors.iconColor,
                            fontSize: _fontSizeCollection.buttonFontSize),
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
        ));
  }
}
