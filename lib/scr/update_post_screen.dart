import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class UpdatePostScreen extends StatefulWidget {
  final PostFirebaseModel post;

  const UpdatePostScreen({Key? key, required this.post}) : super(key: key);

  @override
  _UpdatePostScreenState createState() => _UpdatePostScreenState();
}

class _UpdatePostScreenState extends State<UpdatePostScreen> {
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection colors = ColorsCollection();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
  }

  void _updatePost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      Get.snackbar('Error', 'Title and content cannot be empty');
      return;
    }

    final updatedPost = PostFirebaseModel(
      id: widget.post.id,
      userId: widget.post.userId,
      title: _titleController.text,
      content: _contentController.text,
      images: widget.post.images,
      code: widget.post.code,
      createdAt: widget.post.createdAt,
      updatedAt: DateTime.now(),
      comments: widget.post.comments,
    );

    try {
      await _postController.updatePost(updatedPost);
      Get.back();
      Get.snackbar('Success', 'Post updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post');
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
              onPressed: _updatePost,
              child: Text('Update'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: colors.iconColor),
            ),
          ],
        ),
      ),
    );
  }
}
