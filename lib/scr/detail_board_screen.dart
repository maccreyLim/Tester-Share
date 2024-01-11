import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class DetailBoardScreen extends StatelessWidget {
  final List<BoardFirebaseModel> boards;
  final ColorsCollection colors = ColorsCollection();

  // Use 'final' for the constructor parameter, and fix the constructor name
  DetailBoardScreen({Key? key, required this.boards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.network(
                  boards.first.iconImageUrl,
                  width: 120,
                  height: 120,
                ),
                const SizedBox(width: 20),
                cardText(boards.first.title),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '작성일: ${_formattedDate(boards.first.createAt)}',
              style: TextStyle(fontSize: 16, color: colors.textColor),
            ),
            if (boards.first.updateAt != null)
              Text(
                '수정일: ${_formattedDate(boards.first.updateAt)}',
                style: TextStyle(fontSize: 16, color: colors.textColor),
              ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '-  Summary  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),
            cardText(boards.first.introductionText),
          ],
        ),
      ),
    );
  }

  Widget cardText(String text) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: 20),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }
}
