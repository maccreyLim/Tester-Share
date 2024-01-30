import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen.dart';
import 'package:tester_share_app/scr/detail_board_screen.dart';
import 'package:tester_share_app/scr/project_join_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가

class HomeScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  final AuthController _authController = AuthController.instance;
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _authController.userData?['profileName'],
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        actions: [
          IconButton(
              onPressed: () {
                _authController.signOut();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      backgroundColor: colors.background,
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
                                  '작성일: ${_formattedDate(boards[index].createAt)}',
                                  style: TextStyle(
                                      fontSize: 14, color: colors.textColor),
                                ),
                                if (boards[index].updateAt != null)
                                  Text(
                                    '수정일: ${_formattedDate(boards[index].updateAt!)}',
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
                                width: 100,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      // 버튼의 배경색을 상태에 따라 동적으로 변경하는 설정입니다.
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          // "진행중" 상태에 따라 배경색을 설정합니다.
                                          if (boards[index].testerRequest <
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
                                      Get.to(() => ProjectJoinScreen());
                                    },
                                    child: Text(
                                      boards[index].testerRequest <
                                              boards[index].testerParticipation
                                          ? '진행중'
                                          : "완 료",
                                      style: TextStyle(
                                          color: colors.iconColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                              cardText(
                                  'Developer: ${boards[index].developer}', 14),
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
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: size),
    );
  }
}
