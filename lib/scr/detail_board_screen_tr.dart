import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/bugtodo_firebase_controller.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/developer_message_create_screen_tr.dart';

import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailBoardScreen extends StatelessWidget {
  final BoardFirebaseModel
      boards; // List<BoardFirebaseModel> 대신 BoardFirebaseModel을 사용
  final ColorsCollection colors = ColorsCollection();
  final AuthController _authController = AuthController.instance;
  final BugTodoFirebaseController _bugTodoFirebaseController =
      BugTodoFirebaseController();
  final MassageFirebaseController _massageFirebaseController =
      MassageFirebaseController();
  late String bugReport = ''; // TextField에서 입력받은 데이터를 저장할 변수

  DetailBoardScreen({Key? key, required this.boards}) : super(key: key);

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Row(
              children: [
                boards.iconImageUrl == ""
                    ? Image.asset(
                        "assets/images/no-image.png",
                        width: 80,
                        height: 80,
                      )
                    : Image.network(
                        boards.iconImageUrl,
                        width: 80,
                        height: 80,
                      ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cardText(boards.title, 20),
                    cardText(
                        '[${boards.testerParticipation}/${boards.testerRequest}]',
                        16),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Creation date',
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ).tr(),
                      Text(
                        ': ${_formattedDate(boards.createAt)}',
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ),
                    ],
                  ),
                  if (boards.updateAt != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Modification date',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ).tr(),
                        Text(
                          ': ${_formattedDate(boards.updateAt!)}',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    "-  Developer  -",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          cardText(boards.developer, 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // 메시지 보내기 기능 추가
                                  Get.to(DeveloperMessageCreateScreen(
                                      receiverUid: boards.createUid,
                                      developer: boards.developer,
                                      boards: boards,
                                      func: false));
                                },
                                child: Row(
                                  children: [
                                    const Icon(Icons.message,
                                        color: Colors.white),
                                    const SizedBox(width: 20),
                                    Text(
                                      "Send a message",
                                      style: TextStyle(
                                          color: colors.importantMessage),
                                    ).tr(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '-  Test App URL  -',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        try {
                          final inputUrl = boards.appSetupUrl;

                          // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                          final hasProtocol = inputUrl.startsWith('http://') ||
                              inputUrl.startsWith('https://');

                          // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                          final urlWithProtocol =
                              hasProtocol ? inputUrl : 'https://$inputUrl';

                          // URL을 Uri 객체로 변환
                          final url0 = Uri.parse(urlWithProtocol);

                          // 생성된 Uri를 사용하여 브라우저 열기
                          launchUrl(url0);
                        } catch (e) {
                          // URL이 유효하지 않거나 열 수 없는 경우 처리
                          print('URL 열기 오류: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.boxColor,

                        elevation:
                            8, // Add some elevation for a raised appearance
                      ),
                      child: cardText(boards.appSetupUrl, 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '-  Supported Languages  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                const SizedBox(height: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: colors.boxColor,
                width: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: boards.language!.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.task_alt,
                          color: colors.iconColor,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        cardText(
                          tr(boards.language![index]),
                          20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '-  Github URL  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: boards.githubUrl != null
                          ? () {
                              try {
                                final inputUrl = boards.githubUrl!;

                                // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                                final hasProtocol =
                                    inputUrl.startsWith('http://') ||
                                        inputUrl.startsWith('https://');

                                // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                                final urlWithProtocol = hasProtocol
                                    ? inputUrl
                                    : 'https://$inputUrl';

                                // URL을 Uri 객체로 변환
                                final url = Uri.parse(urlWithProtocol);

                                // 생성된 Uri를 사용하여 브라우저 열기
                                launchUrl(url);
                              } catch (e) {
                                // URL이 유효하지 않거나 열 수 없는 경우 처리
                                print('URL 열기 오류: $e');
                              }
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor: colors.boxColor,
                        elevation: 8,
                      ),
                      child: cardText(boards.githubUrl ?? '', 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  App Image  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 300,
                width: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: boards.appImagesUrl.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(boards.appImagesUrl[index],
                          width: 150, height: 300, fit: BoxFit.fill),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  Introduction  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  color: colors.boxColor,
                  child: cardText(boards.introductionText, 16)),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 310,
                    child: TextField(
                      style: const TextStyle(
                        color: Colors.white, // 입력된 글자의 색상을 파란색으로 지정
                      ),
                      decoration: InputDecoration(
                        hintText: tr('Please report the bug'), // 입력창에 힌트 텍스트 표시
                        labelText: tr('Please report the bug'), // 입력창 옆에 라벨 표시

                        border: const OutlineInputBorder(), // 입력창에 테두리 추가
                      ),
                      onChanged: (text) {
                        // 입력값이 변경될 때마다 호출되는 콜백 함수
                        print('Entered text: $text');
                        // 입력값을 처리하거나 저장하는 로직을 추가할 수 있습니다.
                        bugReport = text;
                      },
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        String _m = tr("Report has been filed");
                        _bugTodoFirebaseController.createBugTodo(
                            boards.createUid,
                            boards.title,
                            BugTodoFirebaseModel(
                                createUid: _authController.userData!['uid'],
                                projectName: boards.title,
                                reportprofileName:
                                    _authController.userData!['profileName'],
                                createAt: DateTime.now(),
                                title:
                                    "Report : ${_authController.userData!['profileName']}",
                                contents: bugReport,
                                isDone: false,
                                level: 4));

                        _massageFirebaseController.createMessage(
                            MessageModel(
                                senderUid: boards.createUid,
                                receiverUid: _authController.userData!['uid'],
                                contents:
                                    "We have received a bug report from ${_authController.userData!['profileName']}. Please check it on BugTodo.\n\n ${_authController.userData!['profileName']}님으로 부터 버그리포트를 받았습니다.BugTodo에서 확인해주세요.\n\n${_authController.userData!['profileName']}さんからバグレポートを受け取りました。BugTodoで確認してください。",
                                timestamp: DateTime.now()),
                            _authController.userData!['profileName']);
                        showToast(_m, 1);
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                      )),
                ],
              ),
            ),
            const Divider(),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: boards.isDeploy == true
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.yellow),
                      ),
                      onPressed: () => Get.back(),
                      child: Text(
                        'Release completed',
                        style: TextStyle(fontSize: 16, color: colors.iconColor),
                      ).tr(),
                    )
                  : !boards.rquestProfileName
                          .contains(_authController.userData!['profileName'])
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () {
                            String testApplyMessage =
                                "아래의 메일 주소로 테스터를 신청합니다.\n 프로젝트 관리자분은 구글콘솔에서 테스터 등록후 '등록되었습니다.'라고 신청하신 유저에게 답장을 주세요!! \n\nI am applying as a tester to the email address below. \nProject administrators, please reply to the user who applied with 'You have been registered.' after registering as a tester in the Google Console!!\n\n以下のメールアドレスにテスターとして申し込みます。\nプロジェクト管理者は、Googleコンソールでテスターに登録した後、'登録されました'と申請したユーザーに返信してください！!\n\n";
                            // 테스터 신청 이메일 메시지를 구성합니다.
                            String emailMessage =
                                "$testApplyMessage\n${_authController.userData!['email']}";
                            //테스터 신청
                            Get.to(DeveloperMessageCreateScreen(
                              receiverUid: boards.createUid,
                              developer: boards.developer,
                              message: emailMessage,
                              boards: boards,
                              func: true,
                            ));
                          },
                          child: Text(
                            'Apply to be a Tester',
                            style: TextStyle(
                                fontSize: 16, color: colors.iconColor),
                          ).tr(),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Already participated as a tester",
                            style: TextStyle(
                                fontSize: 16, color: colors.iconColor),
                          ).tr(),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: size),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
