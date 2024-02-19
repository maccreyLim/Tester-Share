import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen.dart';
import 'package:tester_share_app/scr/my_tester_detail_board_screen.dart';
import 'package:tester_share_app/scr/project_join_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad_example.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class MyTesterRequestPostScreen extends StatelessWidget {
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController _authController = AuthController.instance;
  final BoardFirebaseController _board = BoardFirebaseController();
  final MultiImageFirebaseController _multiImageFirebaseController =
      MultiImageFirebaseController();
  final SingleImageFirebaseController _singleImageFirebaseController =
      SingleImageFirebaseController();
  MyTesterRequestPostScreen({super.key});

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
                  '게시물이 존재하지 않습니다.',
                  style: TextStyle(color: _colors.textColor, fontSize: 22),
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
                                          if (boards[index].testerRequest >
                                              boards[index]
                                                  .testerParticipation) {
                                            return _colors
                                                .stateIsIng; // 상태가 "진행중"일 때의 배경색
                                          } else {
                                            // 다른 상태에는 기본 배경색을 설정합니다.
                                            return _colors.stateIsClose;
                                          }
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.to(() => ProjectJoinScreen());
                                    },
                                    child: Text(
                                      boards[index].testerRequest >
                                              boards[index].testerParticipation
                                          ? 'In progress'
                                          : "Completed",
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
                              SizedBox(
                                width: 140,
                                height: 30,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.red),
                                  ),
                                  onPressed: () async {
                                    //Multi image삭제
                                    await _multiImageFirebaseController
                                        .deleteImagesUrlFromStorage(
                                            boards.first.appImagesUrl);
                                    //Single image삭제
                                    await _singleImageFirebaseController
                                        .deleteImageByUrl(
                                            boards.first.iconImageUrl);
                                    //삭제 구현
                                    _board.deleteBoard(boards.first.docid);
                                  },
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: _colors.iconColor,
                                      fontSize:
                                          _fontSizeCollection.buttonFontSize,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
        child: BannerAdExample(),
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
}
