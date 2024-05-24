import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection colors = ColorsCollection();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      Get.snackbar('Error', 'Title and content cannot be empty');
      return;
    }

    final newPost = PostFirebaseModel(
      id: '', // Firebase에서 자동 생성되므로 빈 값
      userId: 'user-id', // 현재 사용자의 ID로 설정해야 함
      title: _titleController.text,
      content: _contentController.text,
      createdAt: DateTime.now(),
      comments: [],
    );

    try {
      await _postController.addPost(newPost);
      Get.back();
      Get.snackbar('Success', 'Post created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post');
    }
  }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: colors.iconColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: colors.iconColor),
                border: OutlineInputBorder(),
              ),
              maxLines: 8,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitPost,
              child: Text('Submit'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: colors.iconColor),
            ),
          ],
        ),
      ),
    );
  }
}
