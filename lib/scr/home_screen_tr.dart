import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/model/user_firebase_model.dart';
import 'package:tester_share_app/scr/bugtodos_screen.dart';
import 'package:tester_share_app/scr/create_board_screen_tr.dart';
import 'package:tester_share_app/scr/detail_board_screen_tr.dart';
import 'package:tester_share_app/scr/developer_message_create_screen_tr.dart';
import 'package:tester_share_app/scr/door_screen_tr.dart';
import 'package:tester_share_app/scr/faq_screen.dart';
import 'package:tester_share_app/scr/message_state_screen_tr.dart';
import 'package:tester_share_app/scr/notice_screen_tr.dart';
import 'package:tester_share_app/scr/post_screen.dart';
import 'package:tester_share_app/scr/send_registration_message.dart';
import 'package:tester_share_app/scr/setting_screen_tr.dart';
import 'package:tester_share_app/scr/terms_and_privacy_screen.dart';
import 'package:tester_share_app/widget/w.RewardAdManager.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:tester_share_app/widget/w.fcm.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.notification.dart';
import 'package:tester_share_app/widget/w.request_permission.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final InAppReview inAppReview = InAppReview.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  final AuthController _authController = AuthController.instance;
  final MassageFirebaseController _massageFirebaseController =
      MassageFirebaseController();
  var messageString = "";
  int previousCount = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _getUnreadMessageCount();
    _checkPermissions();
    //FCM 초기화
    FcmManager.initialize();
    super.initState();
    setState(() {});
  }

  Future<void> _checkPermissions() async {
    final requestPermission = RequestPermission();
    await requestPermission.checkIfPermissionGranted();
  }

//읽지 않은 메시지를 받아오기
  Future<void> _getUnreadMessageCount() async {
    await for (int count
        in _massageFirebaseController.getUnreadMessageCountStream()) {
      if (mounted) {
        setState(() {
          _authController.setMessageCount(count);
          print(count);
        });

        if (count != previousCount && count != 0) {
          FlutterLocalNotification.showNotification(
              "$count개의 메시지가 도착", "확인하시기를 바랍니다.");
          previousCount = count; // 현재 count 값을 이전 값으로 업데이트
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ScaffoldKey를 설정합니다.
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.grey), // 원하는 색상으로 변경
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // 햄버거 메뉴를 누르면 드로어가 열리도록 설정
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "Tester Share",
            style: TextStyle(color: colors.textColor, fontSize: 14),
          ),
        ),
        backgroundColor: colors.background,
        actions: [
          Obx(() => IconBadge(
                icon: const Icon(Icons.notifications, color: Colors.lightBlue),
                itemCount: _authController.messageCount.value,
                badgeColor: Colors.redAccent,
                itemColor: Colors.white,
                maxCount: 99,
                hideZero: true,
                onTap: () {
                  Get.to(const MessageStateScreen());
                },
              )),
          IconButton(
            onPressed: () {
              //버그체크리스트
              Get.to(() => const BugTodosScreen());
            },
            icon: const Icon(
              Icons.bug_report,
              color: Colors.red,
            ),
          ),
          IconButton(
              onPressed: () {
                Get.to(() => SettingScreen());
              },
              icon: const Icon(Icons.settings, color: Colors.yellow)),
          IconButton(
              onPressed: () {
                _authController.signOut();
              },
              icon: const Icon(
                Icons.logout_outlined,
                color: Colors.white,
              )),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 35, 35, 35),
                borderRadius: BorderRadius.only(
                    // bottomLeft: Radius.circular(20), // 좌하단 코너를 둥글게 만듭니다.
                    bottomRight: Radius.circular(40), // 우하단 코너를 둥글게 만듭니다.
                    // topLeft: Radius.circular(20),
                    topRight: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${_authController.userData?['profileName']}",
                    style: TextStyle(color: colors.textColor, fontSize: 20),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Number of App Launch Experiences',
                            style: TextStyle(
                                color: colors.textColor, fontSize: 12),
                          ).tr(),
                          Text(
                            'Number of Tester Requests',
                            style: TextStyle(
                                color: colors.textColor, fontSize: 12),
                          ).tr(),
                          Text(
                            'Tester Participation Count',
                            style: TextStyle(
                                color: colors.textColor, fontSize: 12),
                          ).tr(),
                          Text(
                            'Point',
                            style: TextStyle(
                                color: colors.textColor, fontSize: 12),
                          ).tr(),
                        ],
                      ),
                      const SizedBox(width: 40),
                      Obx(() => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _authController.userData!['deployed']
                                    .toString(),
                                style: TextStyle(
                                    color: colors.textColor, fontSize: 12),
                              ),
                              Text(
                                _authController.userData!['testerRequest']
                                    .toString(),
                                style: TextStyle(
                                    color: colors.textColor, fontSize: 12),
                              ),
                              Text(
                                _authController.userData!['testerParticipation']
                                    .toString(),
                                style: TextStyle(
                                    color: colors.textColor, fontSize: 12),
                              ),
                              Text(
                                _authController.userData!['point'].toString(),
                                style: TextStyle(
                                    color: colors.importantMessage,
                                    fontSize: 12),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.question_mark,
                color: colors.iconColor,
              ),
              title: Text(
                "Tester Share is?",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                Get.to(DoorScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.announcement,
                color: colors.iconColor,
              ),
              title: Text(
                "Notice",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                Get.to(() => NoticeScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bug_report,
                color: colors.iconColor,
              ),
              title: Text(
                "Bug Report Todo",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                Get.to(() => const BugTodosScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                color: colors.iconColor,
              ),
              title: Text(
                "FAQ",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                Get.to(() => FAQScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.library_books,
                color: colors.iconColor,
              ),
              title: Text(
                "Terms and Privacy",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                Get.to(() => const TermsAndPrivacyScreen());
              },
            ),
            ListTile(
              leading: Icon(
                Icons.handshake,
                color: colors.iconColor,
              ),
              title: Text(
                "Inquiries and Partnerships",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () {
                _sendEmail();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.reviews,
                color: colors.iconColor,
              ),
              title: Text(
                "Leave a review on Google Play Store",
                style: TextStyle(
                    color: colors.textColor,
                    fontSize: _fontSizeCollection.settingFontSize),
              ).tr(),
              onTap: () async {
                if (await inAppReview.isAvailable()) {
                  inAppReview.openStoreListing();
                }
              },
            ),
            ListTile(
              leading: Icon(
                Icons.tv,
                color: colors.iconColor,
              ),
              title: Text(
                "Earn points by watching \nadvertisements",
                style: TextStyle(
                  color: Colors.yellow,
                  fontSize: _fontSizeCollection.settingFontSize,
                ),
              ).tr(),
              onTap: () {
                //안내문
                _showLoadingDialog();
                // 리워드광고
                showRewardAd();
              },
            ),
          ],
        ),
      ),
      backgroundColor: colors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<BoardFirebaseModel>>(
          stream: _board.streamApprovedBoards(),
          builder: (context, AsyncSnapshot<List<BoardFirebaseModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              print('Data from Firestore: ${snapshot.data}');
              return Center(
                child: Text(
                  "The post does not exist",
                  style: TextStyle(color: colors.textColor, fontSize: 22),
                ).tr(),
              );
            }

            List<BoardFirebaseModel> boards = snapshot.data!;
            boards.sort((a, b) {
              if (a.testerRequest > a.testerParticipation &&
                  b.testerRequest <= b.testerParticipation) {
                return -1; // a를 b보다 앞으로 배치
              } else if (a.testerRequest <= a.testerParticipation &&
                  b.testerRequest > b.testerParticipation) {
                return 1; // b를 a보다 앞으로 배치
              } else {
                // testerRequest와 testerParticipation이 같거나 모두 크거나 작을 경우 createAt으로 비교
                return b.createAt.compareTo(a.createAt);
              }
            });

            // 여기에서 boards 리스트를 사용하여 UI를 업데이트하세요.

            return ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailBoardScreen(boards: boards[index]));
                  },
                  child: Card(
                    color: colors.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              boards[index].iconImageUrl == ""
                                  ? Image.asset(
                                      "assets/images/no-image.png",
                                      width: 80,
                                      height: 80,
                                    )
                                  : Image.network(
                                      boards[index].iconImageUrl,
                                      width: 80,
                                      height: 80,
                                    ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cardText(boards[index].title, 18),
                                  const SizedBox(width: 10),
                                  cardText(
                                      '[${boards[index].testerParticipation}/${boards[index].testerRequest}]',
                                      16),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              // Todo: 테스터 신청 구현
                              boards[index].testerRequest -
                                          boards[index].testerParticipation <=
                                      0
                                  ? Container()
                                  : boards[index].rquestProfileName.contains(
                                          _authController
                                              .userData!['profileName'])
                                      ? IconButton(
                                          onPressed: () {
                                            Get.dialog(
                                              AlertDialog(
                                                backgroundColor: Colors.black,
                                                title: const Text(""),
                                                content: const Text(
                                                    'You have already joined this project',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    )).tr(),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text(
                                                        'Confirmation',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        )).tr(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.how_to_reg,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : IconButton(
                                          onPressed: () {
                                            String testApplyMessage =
                                                "아래의 메일 주소로 테스터를 신청합니다.\n 프로젝트 관리자분은 구글콘솔에서 테스터 등록후 '등록되었습니다.'라고 신청하신 유저에게 답장을 주세요!! \n\nI am applying as a tester to the email address below. \nProject administrators, please reply to the user who applied with 'You have been registered.' after registering as a tester in the Google Console!!\n\n以下のメールアドレスにテスターとして申し込みます。\nプロジェクト管理者は、Googleコンソールでテスターに登録した後、'登録されました'と申請したユーザーに返信してください！!\n\n";
                                            // 테스터 신청 이메일 메시지를 구성합니다.
                                            String emailMessage =
                                                "$testApplyMessage\n${_authController.userData!['email']}";
                                            //테스터 신청
                                            Get.to(DeveloperMessageCreateScreen(
                                              receiverUid:
                                                  boards[index].createUid,
                                              developer:
                                                  boards[index].developer,
                                              message: emailMessage,
                                              boards: boards[index],
                                              func: true,
                                            ));
                                          },
                                          icon: const Icon(
                                            Icons.person,
                                            color: Colors.amberAccent,
                                          ),
                                        )
                            ],
                          ),
                          //작성일 표시 부분
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Creation date",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textColor),
                                    ).tr(),
                                    Text(
                                      ': ${_formattedDate(boards[index].createAt)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: colors.textColor),
                                    ),
                                  ],
                                ),
                                if (boards[index].updateAt != null)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Modification date",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: colors.textColor),
                                      ).tr(),
                                      Text(
                                        ': ${_formattedDate(boards[index].updateAt!)}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: colors.textColor),
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(boards[index].introductionText,
                              overflow: TextOverflow.ellipsis, // 초과되면 생략 부호 표시
                              maxLines: 1,
                              style: TextStyle(
                                  color: colors.textColor,
                                  fontSize: 16)), // 표시할 최대 라인 수),
                          const SizedBox(height: 10),
                          //진행중,완료,출시 표시 부분
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 120,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      // 버튼의 배경색을 상태에 따라 동적으로 변경하는 설정입니다.
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          // "진행중" 상태에 따라 배경색을 설정합니다.
                                          if (boards[index].testerRequest >
                                              boards[index]
                                                  .testerParticipation) {
                                            return colors
                                                .stateIsIng; // 상태가 "진행중"일 때의 배경색
                                          } else if (boards[index].isDeploy ==
                                              true) {
                                            return colors
                                                .Deploymentcompleted; // 배포가 완료된 상태의 배경색
                                          } else {
                                            // 완료 상태에는 기본 배경색을 설정합니다.
                                            return colors.stateIsClose;
                                          }
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => DetailBoardScreen(
                                            boards: boards[index],
                                          ));
                                    },
                                    child: Text(
                                      boards[index].testerRequest >
                                              boards[index].testerParticipation
                                          ? "In progress"
                                          : boards[index].isDeploy
                                              ? "Released"
                                              : "Completed",
                                      style: TextStyle(
                                          color: colors.iconColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ).tr()),
                              ),
                              Row(
                                children: [
                                  cardTextButton(
                                      context,
                                      "Project Developer Information",
                                      14,
                                      boards[index].developer,
                                      _authController.userData!['deployed'],
                                      _authController
                                          .userData!['testerParticipation'],
                                      boards[index].createUid),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          _authController.userData!['uid'] ==
                                  boards[index].createUid
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Get.to(() => SendRegistrationMessage(
                                            boards: boards[index],
                                          ));
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        "Send Registration Message to Tester Applicants",
                                        style:
                                            TextStyle(color: colors.iconColor),
                                      ).tr(),
                                      const SizedBox(width: 20),
                                      const Icon(
                                        Icons.send,
                                        color: Colors.blueAccent,
                                      ),
                                    ],
                                  ),
                                )
                              : Container(),
                          _authController.userData!['uid'] ==
                                  boards[index].createUid
                              ? const Divider()
                              : Container(),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            child: BannerAD(),
                          ),
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 테스터 쉐어 추가
          Get.to(() => const CreateBoardScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: size),
    );
  }

// getXDialog 함수 정의
  Widget cardTextButton(
    BuildContext context,
    String title,
    double size,
    String buttontext,
    int releaseExperience,
    int numberOfTestParticipations,
    String uid,
  ) {
    return TextButton(
      onPressed: () async {
        try {
          // 사용자 데이터 가져오기
          UserFirebaseModel? userPost = await _authController.getUserData(uid);
          if (userPost != null) {
            // AlertDialog에 사용자 데이터 표시
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(
                    tr(title),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr("contentText"),
                        style: TextStyle(color: Colors.grey, fontSize: size),
                      ).tr(args: [
                        userPost.deployed.toString(),
                        userPost.testerParticipation.toString(),
                        userPost.point.toString()
                      ]),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Close",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ).tr(),
                    ),
                  ],
                );
              },
            );
          } else {
            // 사용자 데이터가 없는 경우에 대한 처리
            // 이 예제에서는 아무 작업도 수행하지 않음
          }
        } catch (e) {
          // 오류 발생 시 예외 처리
          print("오류 발생: $e");
          // 사용자에게 오류 메시지 표시 등의 추가 작업 가능
        }
      },
      child: Text(
        "DeveloperTextButton",
        style: TextStyle(color: Colors.purple[300]),
      ).tr(args: [buttontext]),
    );
  }

  void _sendEmail() async {
    var _body = tr(
        "Please provide the following information for assistance.\nID:\nOS Version:\nDevice Modle:\nPlease write ypur inquiry below.\n");
    var _subject = tr('Inquiry and Partnership Inquiry Regarding Tester Share');
    final Email email = Email(
        body: _body,
        subject: _subject,
        recipients: ['maccrey@naver.com'],
        cc: ['m01071630214@gmail.com'],
        isHTML: false);

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      String title = tr(
          "Since I cannot use the default mail app,\nit is difficult to send inquiries directly through the app.\n\nPlease use your preferred email\nand send inquiries to maccrey@naver.com. Thank you.");
      ;
      Get.defaultDialog(
        title: tr("Guidance"),
        content: Text(title),
        textConfirm: tr("Confirmation"),
        confirmTextColor: Colors.white54,
        onConfirm: Get.back,
      );
    }
  }

  void _showLoadingDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black, // 배경색을 회색으로 변경
        title: Text("Please wait a moment!!",
                style: TextStyle(color: colors.iconColor))
            .tr(),
        content: Text("An advertisement will be shown soon.",
                style: TextStyle(color: colors.iconColor))
            .tr(),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("확인"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    // 3초 후에 다이얼로그를 닫습니다.
    // 3초 후에 다이얼로그를 닫습니다.
    Timer(Duration(seconds: 3), () {
      Get.back();
    });
  }

  void showRewardAd() {
    final RewardAdManager _rewardAd = RewardAdManager();
    _rewardAd.showRewardFullBanner(() {
      String _uid = _authController.userData!['uid'];
      int value = ++_authController.userData!['point']; // 전위 증가 연산자 사용

      // 업데이트할 데이터
      Map<String, dynamic> _userNewData = {
        "point": value,
        // 필요한 경우 다른 필드도 추가할 수 있습니다.
      };
      // 사용자 데이터 업데이트
      _authController.updateUserData(_uid, _userNewData);
      // 광고를 보고 사용자가 리워드를 얻었을 때 실행할 로직
      // 예: 기부하기 또는 다른 작업 수행
    });
  }
}
