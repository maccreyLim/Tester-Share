import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class DeveloperMessageCreateScreen extends StatefulWidget {
  const DeveloperMessageCreateScreen(
      {super.key,
      required this.receiverUid,
      required this.developer,
      required this.boards,
      this.message});
  final String receiverUid; // 수신자의 UID를 저장하는 변수
  final String developer; // 수신자 이름
  final String? message;
  final BoardFirebaseModel
      boards; // List<BoardFirebaseModel> 대신 BoardFirebaseModel을 사용

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
  final BoardFirebaseController _board = BoardFirebaseController();

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
                  const SizedBox(
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

                        //UserDate에서 testerParticipation +1증가
                        String _uid = _authController.userData!['uid'];
                        int value = ++_authController
                            .userData!['testerParticipation']; // 전위 증가 연산자 사용
                        // 현재 사용자의 프로필 이름 가져오기
                        String _profileName =
                            _authController.userData!['profileName'];

                        // 업데이트할 데이터
                        Map<String, dynamic> _userNewData = {
                          "testerParticipation": value,
                        };
                        // 사용자 데이터 업데이트
                        _authController.updateUserData(_uid, _userNewData);

                        //board에서 testerParticipation +증가
                        String _docUid = widget.boards.docid;
                        int _value = ++widget.boards.testerParticipation;
                        List<dynamic> existingProfileNames =
                            _authController.userData!['testerRequestProfile'] ??
                                [];
                        existingProfileNames.add(_profileName);
                        // 업데이트할 데이터
                        Map<String, dynamic> _boardNewData = {
                          "testerParticipation": _value,
                          // 기존 프로필 이름을 포함한 리스트를 사용하여 새로운 리스트 생성
                          "testerRequestProfile": existingProfileNames,
                        };
                        // 사용자 데이터 업데이트
                        _board.updateBoardData(_docUid, _boardNewData);
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
