import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/login_screen_tr.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.fcm.dart';
import 'package:easy_localization/easy_localization.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with WidgetsBindingObserver {
  final InAppReview inAppReview = InAppReview.instance;
  final ColorsCollection colors = ColorsCollection();
  final BoardFirebaseController _board = BoardFirebaseController();

  int previousCount = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //FCM 초기화
    FcmManager.initialize();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // ScaffoldKey를 설정합니다.
      appBar: AppBar(
        title: Text(
          "Current Project",
          style: TextStyle(
            color: colors.textColor,
            fontSize: 20,
          ),
        ).tr(),
        backgroundColor: colors.background,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => LoginScreen());
              },
              icon: const Icon(
                Icons.login_outlined,
                color: Colors.white,
              )),
        ],
      ),

      backgroundColor: colors.background,
      body: Padding(
        padding: const EdgeInsets.all(14.0),
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
            // 정렬 로직
            boards.sort((a, b) {
              // 1. 출시 완료 문서 우선 (false before true)
              if (a.isDeploy != b.isDeploy) {
                return a.isDeploy ? 1 : -1; // true면 1, false면 -1 반환
              }

              // 2. 테스터 모집 완료 문서 우선 (true before false)
              bool aIsRecruiting =
                  a.testerRequest - a.testerParticipation > 0 && !a.isDeploy;
              bool bIsRecruiting =
                  b.testerRequest - b.testerParticipation > 0 && !b.isDeploy;
              if (aIsRecruiting != bIsRecruiting) {
                return aIsRecruiting ? -1 : 1; // true면 1, false면 -1 반환
              }

              // 3. 생성일 기준 내림차순 정렬
              return b.createAt.compareTo(a.createAt);
            });

            // 여기에서 boards 리스트를 사용하여 UI를 업데이트하세요.

            return ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.dialog(
                        // 다이얼로그 내용을 구성합니다.
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text('Notification').tr(),
                          content: const Text(
                                  "Membership registration or login is required.")
                              .tr(),
                          actions: <Widget>[
                            // 확인 버튼 추가
                            TextButton(
                              onPressed: () {
                                // 다이얼로그 닫기
                                Get.back();
                              },
                              child: const Text(
                                "Close",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),
                              ).tr(),
                            ),
                            TextButton(
                              onPressed: () {
                                // 다이얼로그 닫기
                                Get.back();
                                Get.to(() => const LoginScreen());
                              },
                              child: const Text(
                                "Go to Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.red,
                                    fontSize: 16),
                              ).tr(),
                            ),
                          ],
                        ),
                      );
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
                                        fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        boards[index].iconImageUrl,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.contain,
                                      ),
                                const SizedBox(width: 20),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        boards[index].title,
                                        style: TextStyle(
                                          color: colors.textColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        boards[index].introductionText,
                                        style: TextStyle(
                                          color: colors.textColor,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 10),
                                      boards[index].isDeploy == true
                                          ? const Text(
                                              "Released",
                                              style: TextStyle(
                                                color: Colors.amber,
                                                fontSize: 12,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ).tr()
                                          : boards[index].testerRequest -
                                                      boards[index]
                                                          .testerParticipation ==
                                                  0
                                              ? const Text(
                                                  "Tester Recruitment Completed",
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).tr()
                                              : const Text(
                                                  "Tester Recruitment In Progress",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ).tr(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
