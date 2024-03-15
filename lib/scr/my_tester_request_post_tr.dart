import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen_tr.dart';
import 'package:tester_share_app/scr/my_tester_detail_board_screen.dart';
import 'package:tester_share_app/scr/project_join_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.get_dialog_tr.dart';
import 'package:tester_share_app/widget/w.reward_ad.dart';

class MyTesterRequestPostScreen extends StatelessWidget {
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  final MultiImageFirebaseController _multiImageFirebaseController =
      MultiImageFirebaseController();
  final SingleImageFirebaseController _singleImageFirebaseController =
      SingleImageFirebaseController();
  MyTesterRequestPostScreen({super.key});

  void showRewardAd() {
    final RewardAdManager _rewardAd = RewardAdManager();
    _rewardAd.showRewardFullBanner(() {
      // 광고를 보고 사용자가 리워드를 얻었을 때 실행할 로직
      // 예: 기부하기 또는 다른 작업 수행
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            "My Tester Request Post",
            style: TextStyle(color: _colors.textColor, fontSize: 16),
          ),
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
          stream: _board.boardStream(),
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
                  style: TextStyle(color: _colors.textColor, fontSize: 22),
                ).tr(),
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
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          // "진행중" 상태에 따라 배경색을 설정합니다.
                                          if (!boards[index].isApproval) {
                                            return _colors.stateIsClose;
                                          } else if (boards[index]
                                                  .testerRequest >
                                              boards[index]
                                                  .testerParticipation) {
                                            return _colors
                                                .stateIsIng; // Background color when the state is "In Progress"
                                          } else {
                                            // Default background color for other states
                                            return _colors.stateIsClose;
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
                          // SizedBox(height: 20),
                          Divider(),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: SizedBox(
                                  width: 220,
                                  height: 26,
                                  child: !(boards[index].isApproval)
                                      ? ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.red),
                                          ),
                                          onPressed: () async {
                                            //리워드광고
                                            showRewardAd();
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
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
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
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
