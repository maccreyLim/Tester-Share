import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/my_tester_request_post.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

Widget getXDialog(BuildContext context, String message) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: contentBox(context, message),
  );
}

Widget contentBox(BuildContext context, String message) {
  final ColorsCollection _colors = ColorsCollection();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey, //배경색변경
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              message,
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Get.to(MyTesterRequestPostScreen());
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red), // 버튼 배경색
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(200, 40)), // 버튼 최소 크기
            ),
            child: Text(
              'Go My Tester Request Post',
              style: TextStyle(color: Colors.white),
            ).tr(),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  _colors.buttonColor), // 버튼 배경색
              minimumSize:
                  MaterialStateProperty.all<Size>(Size(232, 40)), // 버튼 최소 크기
            ),
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white),
            ).tr(),
          ),
          SizedBox(height: 8),
        ],
      ),
    ),
  );
}
