import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class DetailPostScreen extends StatelessWidget {
  final PostFirebaseModel post;
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection _colors = ColorsCollection();

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
                    post.code.toString(), // Corrected to 'code:'
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
              const SizedBox(height: 20),
              const Text(
                "Comments",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ).tr(),
              const SizedBox(height: 8),
              if (post.comments != null)
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: post.comments!.length,
                  itemBuilder: (context, index) {
                    var comment = post.comments![index];
                    return Text(
                      "By: ${comment.userId}, ${comment.createdAt.toString()},\n${comment.content}",
                      style: TextStyle(color: _colors.iconColor),
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
