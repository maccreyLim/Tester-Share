import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/create_board_screen.dart';
import 'package:tester_share_app/scr/detail_board_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:intl/intl.dart'; // intl 패키지 추가

class HomeScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.off(() => HomeScreen());
            },
            icon: Icon(
              Icons.close,
              color: colors.background,
            ),
          )
        ],
      ),
      body: StreamBuilder<List<BoardFirebaseModel>>(
        stream: _board.boardStream(),
        builder: (context, AsyncSnapshot<List<BoardFirebaseModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                  Get.to(() => DetailBoardScreen(boards: boards));
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
                            const SizedBox(width: 20),
                            cardText(boards[index].title),
                          ],
                        ),
                        Text(
                          '작성일: ${_formattedDate(boards[index].createAt)}',
                          style:
                              TextStyle(fontSize: 12, color: colors.textColor),
                        ),
                        if (boards[index].updateAt != null)
                          Text(
                            '수정일: ${_formattedDate(boards[index].updateAt)}',
                            style: TextStyle(
                                fontSize: 12, color: colors.textColor),
                          ),
                        const SizedBox(height: 4),
                        Text(boards[index].introductionText,
                            overflow: TextOverflow.ellipsis, // 초과되면 생략 부호 표시
                            maxLines: 1,
                            style: TextStyle(
                                color: colors.textColor,
                                fontSize: 20)), // 표시할 최대 라인 수),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            cardText('Developer: ${boards[index].createUid}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 테스터 쉐어 추가
          Get.to(() => CreateBoardScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  Widget cardText(String text) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: 20),
    );
  }
}
