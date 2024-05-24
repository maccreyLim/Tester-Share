import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class DetailPostScreen extends StatelessWidget {
  final PostFirebaseModel post;
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection colors = ColorsCollection();

  DetailPostScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        // title: Text(
        //   "Detail",
        //   style: TextStyle(color: colors.iconColor),
        // ).tr(),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 18),
            Text(
              post.title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.iconColor),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 20),
            Text(
              post.content,
              style: TextStyle(fontSize: 16, color: colors.textColor),
            ),
            const SizedBox(height: 16),
            const Text(
              "Comments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ).tr(),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: post.comments.length,
                itemBuilder: (context, index) {
                  final comment = post.comments[index];
                  return ListTile(
                    title: Text(comment.content),
                    subtitle: Text(
                      "By: ${comment.userId}, ${comment.createdAt.toString()}",
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
