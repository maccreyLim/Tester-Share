import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class CommentInputDialog {
  static void showCommentInput({
    required BuildContext context,
    required Function(String) onCommentSubmitted,
  }) {
    TextEditingController commentController = TextEditingController();
    ColorsCollection _color = ColorsCollection();

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey, // 회색 배경색으로 설정
        title: const Text('댓글 입력',
            style: TextStyle(color: Colors.black)), // 제목 텍스트 색상 설정
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: '댓글을 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // 대화 상자 닫기
            },
            child: const Text('취소',
                style: TextStyle(color: Colors.black)), // 취소 버튼 텍스트 색상 설정
          ),
          ElevatedButton(
            onPressed: () {
              String comment = commentController.text;
              if (comment.isNotEmpty) {
                onCommentSubmitted(comment); // 입력된 댓글 콜백 호출
              }
              Get.back(); // 대화 상자 닫기
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // 확인 버튼 배경색 설정
            ),
            child: Text(
              '확인',
              style: TextStyle(color: _color.iconColor),
            ),
          ),
        ],
      ),
    );
  }
}
