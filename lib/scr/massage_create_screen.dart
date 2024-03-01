import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class MessageCreateScrren extends StatefulWidget {
  const MessageCreateScrren({super.key});

  @override
  State<MessageCreateScrren> createState() => _MessageCreateScrrenState();
}

class _MessageCreateScrrenState extends State<MessageCreateScrren> {
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final _formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController sendUserController = TextEditingController();
  TextEditingController _search = TextEditingController();
  String receiverUid = ''; // 수신자의 UID를 저장하는 변수
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
                      decoration: const InputDecoration(
                        hintText: '회원검색',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.black, // 배경색 변경
                        border: UnderlineInputBorder(
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
                    '검색 결과',
                    style: TextStyle(color: colors.textColor),
                  ),
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
                  SizedBox(
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
                  SizedBox(
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