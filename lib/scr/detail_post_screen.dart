import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:get/get.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.comment_input_dialog.dart';

class DetailPostScreen extends StatelessWidget {
  final PostFirebaseModel post;
  // final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection _colors = ColorsCollection();
  final DateFormat formatter =
      DateFormat('yyyy-MM-dd HH:mm:ss'); // DateFormat instance

  DetailPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _colors.background,
        title: Text(
          "Detail",
          style: TextStyle(color: _colors.iconColor),
        ).tr(),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              Text(
                post.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _colors.iconColor,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 20),
              Text(
                post.content,
                style: TextStyle(fontSize: 16, color: _colors.textColor),
              ),
              const SizedBox(height: 40),
              if (post.code != null)
                Center(
                  child: HighlightView(
                    language: 'dart',
                    post.code!, // Corrected to 'code:'
                    textStyle: const TextStyle(
                      fontFamily: 'Courier', // Fixed-width font
                      fontSize: 12.0,
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    if (post.images != null && post.images!.isNotEmpty)
                      for (var image in post.images!)
                        Image.network(
                          image,
                          width: 300, // Adjust as needed
                          height: 400, // Adjust as needed
                          fit: BoxFit.cover,
                        )
                    else
                      const Text('No images available'),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ).tr(),
                  IconButton(
                    onPressed: () {
                      print("댓글 달기 클릭");
                      //Getdialog를 띄워 댓글 입력 받기
                      CommentInputDialog.showCommentInput(
                        context: context,
                        onCommentSubmitted: (comment) {
                          // 댓글이 제출되었을 때 처리할 로직 추가
                          print('제출된 댓글: $comment');
                        },
                      );
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.amber,
                    iconSize: 20,
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 4),
              if (post.comments != [])
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: post.comments.length,
                  itemBuilder: (context, index) {
                    var comment = post.comments[index];
                    final String formattedDate = formatter
                        .format(comment.createdAt); // Formatting createdAt
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              comment.userId,
                              style: TextStyle(
                                  color: _colors.textColor, fontSize: 12),
                            ),
                            Row(
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                      color: _colors.textColor, fontSize: 10),
                                ),
                                // 작성자인 경우 표시
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.close),
                                  color: _colors.importantMessage,
                                  iconSize: 14,
                                )
                              ],
                            ),
                          ],
                        ),
                        Text(
                          comment.content,
                          style: TextStyle(color: _colors.iconColor),
                        ),
                        Divider(color: _colors.textColor)
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
