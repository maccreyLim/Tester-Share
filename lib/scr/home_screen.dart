import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen.dart';
import 'package:tester_share_app/scr/detail_board_screen.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';
import 'package:tester_share_app/scr/setting_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:intl/intl.dart';
import 'package:icon_badge/icon_badge.dart';
import 'package:tester_share_app/widget/w.notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ColorsCollection colors = ColorsCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  final AuthController _authController = AuthController.instance;
  final MassageFirebaseController _massageFirebaseController =
      MassageFirebaseController();
  var messageString = "";
  int previousCount = 0;

  @override
  void initState() {
    //출시시 시간을 1분으로 수정 필요
    if (_authController.isLogin) {
      _getUnreadMessageCount();
      Timer.periodic(Duration(minutes: 5), (Timer timer) {
        _getUnreadMessageCount();
      });
    }
    super.initState();
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

        if (count != previousCount) {
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
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            // "메시지 내용: $messageString",
            "${_authController.userData?['profileName']}",
            style: TextStyle(color: colors.textColor, fontSize: 16),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        actions: [
          Obx(() => IconBadge(
                icon: const Icon(Icons.notifications, color: Colors.lightBlue),
                itemCount:
                    _authController.messageCount.value, // itemCount를 변수로 설정

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
                FlutterLocalNotification.showNotification("title", "안녕하세요");
              },
              icon: const Icon(Icons.message)),
          IconButton(
              onPressed: () {
                Get.to(() => SettingScreen());
              },
              icon: const Icon(Icons.settings)),
          IconButton(
              onPressed: () {
                _authController.signOut();
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
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
                  'The post does not exist',
                  style: TextStyle(color: colors.textColor, fontSize: 22),
                ),
              );
            }

            List<BoardFirebaseModel> boards = snapshot.data!;
            print(boards.first.createAt);

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
                          Row(
                            children: [
                              Image.network(
                                boards[index].iconImageUrl,
                                width: 80,
                                height: 80,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  cardText(boards[index].title, 20),
                                  const SizedBox(width: 10),
                                  cardText(
                                      '[${boards[index].testerRequest}/${boards[index].testerParticipation}]',
                                      20),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Creation date: ${_formattedDate(boards[index].createAt)}',
                                  style: TextStyle(
                                      fontSize: 14, color: colors.textColor),
                                ),
                                if (boards[index].updateAt != null)
                                  Text(
                                    'Modification date: ${_formattedDate(boards[index].updateAt!)}',
                                    style: TextStyle(
                                        fontSize: 14, color: colors.textColor),
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
                                  fontSize: 20)), // 표시할 최대 라인 수),
                          const SizedBox(height: 10),
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
                                          } else {
                                            // 다른 상태에는 기본 배경색을 설정합니다.
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
                                          ? 'In progress'
                                          : "Completed",
                                      style: TextStyle(
                                          color: colors.iconColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              cardText(
                                  'Developer: ${boards[index].developer}', 14),
                            ],
                          ),
                          Divider(),
                          SizedBox(height: 10),
                          SizedBox(width: double.infinity, child: BannerAD()),
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
      //아래배너광고
      // bottomNavigationBar: SizedBox(
      //   width: double.infinity,
      //   child: BannerAD(),
      // ),
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
}
