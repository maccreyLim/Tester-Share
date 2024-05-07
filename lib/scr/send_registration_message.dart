import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class SendRegistrationMessage extends StatelessWidget {
  final BoardFirebaseModel boards;
  final ColorsCollection colors = ColorsCollection();
  final AuthController authController = AuthController.instance;
  final MassageFirebaseController _massageFirebaseController =
      MassageFirebaseController();

  // Add a named 'key' parameter to the constructor
  SendRegistrationMessage({Key? key, required this.boards}) : super(key: key);

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
      body: SizedBox(
        height: double.infinity, // Use a fixed height or wrap with Expanded
        child: Column(
          children: [
            Expanded(
              // Add Expanded here
              child: ListView.builder(
                itemCount: boards.rquestProfileName.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      boards.rquestProfileName[index],
                      style: TextStyle(color: colors.textColor),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        print("${boards.rquestProfileName[index]}클릭");
                        String? receiverUid =
                            await authController.getUidFromProfileName(
                                boards.rquestProfileName[index]);
                        if (receiverUid != null) {
                          _massageFirebaseController.createMessage(
                              MessageModel(
                                  senderUid: authController.userData!['uid'],
                                  receiverUid: receiverUid,
                                  contents:
                                      "Registration is complete. Please click the link below to proceed.\n\n등록이 완료되었으므로 아래의 주소를 클릭하시고 진행해주세요.\n\n登録が完了しました。以下のリンクをクリックして続行してください。",
                                  timestamp: DateTime.now(),
                                  appUrl: boards.appSetupUrl),
                              "nickname");
                          showToast(
                              '${boards.rquestProfileName[index]}에게 메시지를 보냈습니다.',
                              1);
                        } else {
                          // 사용자의 UID를 찾을 수 없음을 알림
                          // 예: Get.snackbar("Error", "User UID not found for profileName: ${boards.rquestProfileName[index]}");
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
