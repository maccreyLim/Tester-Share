import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen_tr.dart';
import 'package:tester_share_app/scr/my_tester_detail_board_screen_tr.dart';
import 'package:tester_share_app/scr/send_registration_message.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class MyTesterRequestPostScreen extends StatefulWidget {
  const MyTesterRequestPostScreen({super.key});

  @override
  State<MyTesterRequestPostScreen> createState() =>
      _MyTesterRequestPostScreenState();
}

class _MyTesterRequestPostScreenState extends State<MyTesterRequestPostScreen> {
  final ColorsCollection _colors = ColorsCollection();

  final FontSizeCollection _fontSizeCollection = FontSizeCollection();

  final BoardFirebaseController _board = BoardFirebaseController();

  final MultiImageFirebaseController _multiImageFirebaseController =
      MultiImageFirebaseController();

  final SingleImageFirebaseController _singleImageFirebaseController =
      SingleImageFirebaseController();

  final AuthController _authController = AuthController.instance;

  final InterstitialAdController adController = InterstitialAdController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "My Tester Request Post",
            style: TextStyle(color: _colors.textColor, fontSize: 16),
          ).tr(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: _colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.close,
              color: _colors.iconColor,
            ),
          )
        ],
      ),
      backgroundColor: _colors.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<BoardFirebaseModel>>(
          stream: _board.boardStream(
              currentUserUid: _authController.userData!['uid']),
          builder: (context, AsyncSnapshot<List<BoardFirebaseModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              print('스냅샷 데이타: ${snapshot.data}');
              return Center(
                child: Text(
                  "The post does not exist",
                  style: TextStyle(color: _colors.textColor, fontSize: 22),
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
                    Get.to(
                        () => MyTestDetailBoardScreen(boards: boards[index]));
                  },
                  child: Card(
                    color: _colors.cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
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
                                  cardText(boards[index].title, 20),
                                  const SizedBox(width: 10),
                                  cardText(
                                      '[${boards[index].testerParticipation}/${boards[index].testerRequest}]',
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
                                      fontSize: 14, color: _colors.textColor),
                                ),
                                if (boards[index].updateAt != null)
                                  Text(
                                    'Modification date: ${_formattedDate(boards[index].updateAt!)}',
                                    style: TextStyle(
                                        fontSize: 14, color: _colors.textColor),
                                  )
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),
                          Text(boards[index].introductionText,
                              overflow: TextOverflow.ellipsis, // 초과되면 생략 부호 표시
                              maxLines: 1,
                              style: TextStyle(
                                  color: _colors.textColor,
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
                                      backgroundColor: WidgetStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          // "진행중" 상태에 따라 배경색을 설정합니다.
                                          if (!boards[index].isApproval) {
                                            return _colors.stateIsClose; // 미승인
                                          } else if (boards[index]
                                                  .testerRequest <=
                                              boards[index]
                                                  .testerParticipation) {
                                            return _colors
                                                .finish; // Background color when the state is "In Progress"
                                          } else {
                                            // Default background color for other states
                                            return _colors.stateIsIng;
                                          }
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      // If not in progress
                                      if (!boards[index].isApproval) {
                                        showMyDialog(context,
                                            tr("Please wait until the administrator approves"));
                                      } else {
                                        showMyDialog(context,
                                            tr("Deletion is not possible as it is currently in progress"));
                                      }
                                    },
                                    child: Text(
                                      boards[index].isApproval
                                          ? boards[index].testerRequest >
                                                  boards[index]
                                                      .testerParticipation
                                              ? tr('In progress')
                                              : tr("Completed")
                                          : tr('Unapproval'),
                                      style: TextStyle(
                                          color: _colors.iconColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                              cardText(
                                  'Developer: ${boards[index].developer}', 14),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                Get.to(() => SendRegistrationMessage(
                                    boards: boards[index]));
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Send Registration Message to Tester Applicants",
                                  style: TextStyle(color: _colors.iconColor),
                                ).tr(),
                                const SizedBox(width: 20),
                                const Icon(
                                  Icons.send,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            child: BannerAD(),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: SizedBox(
                                  width: 294,
                                  height: 28,
                                  child: !(boards[index].isApproval)
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all<Color>(
                                                    Colors.red),
                                          ),
                                          onPressed: () async {
                                            //리워드광고
                                            adController.loadAndShowAd();
                                            // Multi image 삭제
                                            await _multiImageFirebaseController
                                                .deleteImagesUrlFromStorage(
                                                    boards.first.appImagesUrl);
                                            print("멀티이미지가 삭제되었습니다.");
                                            // Single image 삭제
                                            await _singleImageFirebaseController
                                                .deleteImageUrl(
                                                    boards.first.iconImageUrl);
                                            print("싱글이미지가 삭제되었습니다.");
                                            // 삭제 구현
                                            _board.deleteBoard(
                                                boards.first.docid);
                                            print("게시판데이타가 삭제되었습니다.");
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: _colors.iconColor,
                                              fontSize: _fontSizeCollection
                                                  .buttonFontSize,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ).tr(),
                                        )
                                      : Text(
                                          "Inapproved projects cannot be deleted or modified",
                                          style: TextStyle(
                                              color: _colors.textColor,
                                              fontSize: 10),
                                        ).tr(),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              boards[index].isApproval &&
                                      boards[index].isDeploy == false
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(290, 30), // 버튼의 최소 크기 설정
                                        // 다른 스타일 설정
                                      ),
                                      onPressed: () {
                                        String docUid = boards[index].docid;
                                        Map<String, dynamic> newData = {
                                          "isDeploy": true,
                                          "deployAt": DateTime.now(),
                                          // 필드와 값 추가
                                        };
                                        _board.updateBoardData(docUid, newData);
                                        String uid =
                                            _authController.userData!['uid'];
                                        int deployed = _authController
                                                .userData!['deployed'] +
                                            1;
                                        Map<String, dynamic> userData = {
                                          'deployed': deployed
                                        };

                                        _authController.updateUserData(
                                            uid, userData);
                                        print("배포 변경 데이터 : $uid , $deployed");
                                      },
                                      child: const Text(
                                              "Is Google Play deployment done?")
                                          .tr())
                                  : boards[index].isApproval &&
                                          boards[index].isDeploy
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(
                                                290, 30), // 버튼의 최소 크기 설정
                                            // 다른 스타일 설정
                                            backgroundColor: Colors.amber,
                                          ),
                                          onPressed: () {},
                                          child: const Text(
                                                  "Google Play Deployment Completed")
                                              .tr())
                                      : Container()
                            ],
                          )
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
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            // 테스터 쉐어 추가
            Get.to(() => const CreateBoardScreen());
          },
          child: const Icon(Icons.add),
        ),
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
      style: TextStyle(color: _colors.textColor, fontSize: size),
    );
  }

  void showMyDialog(BuildContext context, String content) {
    // GetX 패키지를 이용하여 다이얼로그 표시
    Get.dialog(
      // 다이얼로그 내용을 구성합니다.
      AlertDialog(
        title: const Text('Notification').tr(),
        content: Text(content),
        actions: <Widget>[
          // 확인 버튼 추가
          TextButton(
            onPressed: () {
              // 다이얼로그 닫기
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
