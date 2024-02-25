import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/getx.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';

class MessageCreateScrren extends StatefulWidget {
  const MessageCreateScrren({super.key});

  @override
  State<MessageCreateScrren> createState() => _MessageCreateScrrenState();
}

class _MessageCreateScrrenState extends State<MessageCreateScrren> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  TextEditingController sendUserController = TextEditingController();
  String receiverUid = ''; // 수신자의 UID를 저장하는 변수
  final _seach = SearchController();
  final MassageFirebaseController _mfirebase =
      MassageFirebaseController(); // MessageFirebase 클래스의 인스턴스 생성
  Map<String, dynamic> searchResults = {}; // 검색 결과를 저장할 변수
  final AuthController _authController = AuthController.instance;
  final controller = Get.put(ControllerGetX());

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    sendUserController.dispose();
    _seach.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('쪽지 보내기'),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SearchBar(
                    controller: _seach,
                    hintText: '회원검색',
                    leading: const Icon(Icons.search),
                    onChanged: (v) async {
                      Map<String, dynamic> results =
                          await _mfirebase.getUserByNickname(v);
                      setState(() {
                        searchResults = results; // 검색 결과를 저장
                      });
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  Text('검색 결과:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final user = searchResults.keys.elementAt(index);
                      final userData = searchResults[user];

                      final nickname = userData['profileName'] as String;

                      return ListTile(
                          title: Text(nickname),
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
                    style: TextStyle(fontSize: 16),
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
                    style: TextStyle(fontSize: 16),
                    cursorHeight: 20,
                    maxLines: 12,
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
                  ElevatedButton(
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
                        backgroundColor: Colors.white,
                        minimumSize:
                            Size(MediaQuery.of(context).size.width * 1, 48)),
                    child: Text('보내기'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
