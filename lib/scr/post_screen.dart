import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/scr/create_post_screen.dart';
import 'package:tester_share_app/scr/detail_post_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
// UpdatePostScreen 임포트

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController authController = AuthController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        title: Text(
          "Community",
          style: TextStyle(color: colors.iconColor),
        ).tr(),
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
      body: StreamBuilder<List<PostFirebaseModel>>(
        stream: _postController.getPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(
                  color: colors.iconColor,
                ),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No posts available",
                style: TextStyle(color: colors.iconColor),
              ).tr(),
            );
          }

          List<PostFirebaseModel> posts = snapshot.data!;
          print('Number of posts: ${posts.length}'); // 게시물 수 출력

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        posts[index].title,
                        style: TextStyle(color: colors.iconColor),
                        maxLines: 1, // 한 줄로 줄이기
                        overflow: TextOverflow.ellipsis, // 넘치는 부분에 대한 처리
                      ),
                      subtitle: Text(
                        posts[index].content,
                        style: TextStyle(color: colors.textColor),
                        maxLines: 1, // 한 줄로 줄이기
                        overflow: TextOverflow.ellipsis, // 넘치는 부분에 대한 처리
                      ),
                      onTap: () {
                        Get.to(() => DetailPostScreen(post: posts[index]));
                        // Get.to(() => UpdatePostScreen(post: posts[index]));
                      },
                    ),
                    Container(
                      color: Color.fromARGB(255, 48, 47, 47), // 원하는 색상으로 변경
                      height: 1.0, // Divider의 높이 설정
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => CreatePostScreen());
        },
        child: Icon(Icons.add),
        backgroundColor: colors.iconColor,
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
