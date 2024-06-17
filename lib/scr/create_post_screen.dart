// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/post_firebase_controller.dart';
import 'package:tester_share_app/controller/post_multi_image_firebase_controller.dart';
import 'package:tester_share_app/model/post_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostFirebaseController _postController = PostFirebaseController();
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _font = FontSizeCollection();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final PostMultiImageFirebaseController _postMultiImageFirebaseController =
      PostMultiImageFirebaseController();
  final AuthController _authController = AuthController.instance;
  List<String> appImagesUrl = [];

  List<XFile?> pickedImages = []; // 이미지 File을 저장할 리스트

  void _submitPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      Get.snackbar('Error', 'Title and content cannot be empty');
      return;
    }

    if (pickedImages.isNotEmpty) {
      appImagesUrl = await _postMultiImageFirebaseController
          .uploadMultiImages(pickedImages);
    }

    final newPost = PostFirebaseModel(
      id: '', // Firebase에서 자동 생성되므로 빈 값
      userId: _authController.userData!['uid'], // 현재 사용자의 ID로 설정해야 함
      title: _titleController.text,
      content: _contentController.text,
      code: _codeController.text,
      createdAt: DateTime.now(),
      comments: [],
      images: appImagesUrl,
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
      backgroundColor: _colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: _colors.background,
        title: Text(
          "Community",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: _colors.iconColor),
                  border: const OutlineInputBorder(),
                ),
                style: TextStyle(
                  color: _colors.iconColor, // 입력받은 글씨의 색을 설정
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: TextStyle(color: _colors.iconColor),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 8,
                style: TextStyle(
                  color: _colors.iconColor, // 입력받은 글씨의 색을 설정
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code',
                  labelStyle: TextStyle(color: _colors.iconColor),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 8,
                style: TextStyle(
                  color: _colors.importantMessage, // 입력받은 글씨의 색을 설정
                ),
              ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: () async {
                  // 이미지 가져오기
                  List<XFile?>? images = await _postMultiImageFirebaseController
                      .pickMultiImage(pickedImages);
                  if (images.isNotEmpty) {
                    setState(() {
                      pickedImages = images;
                    });
                  }
                },
                icon: Icon(
                  Icons.camera_alt,
                  size: 60,
                  color: _colors.textColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  pickedImages.isEmpty
                      ? Container()
                      : Flexible(
                          child: multiImageListView(),
                        ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitPost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colors.buttonColor,
                  ),
                  child: Text('Create Post',
                      style: TextStyle(
                        color: _colors.iconColor,
                        fontSize: _font.buttonFontSize,
                      ) // This appears to be using some localization or translation mechanism.
                      ).tr(),
                ),
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

  Widget multiImageListView() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pickedImages.length,
        itemBuilder: (context, index) {
          return Container(
            width: 150,
            margin: const EdgeInsets.only(right: 10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.file(
                    File(pickedImages[index]!.path),
                    height: 150,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  height: 20,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _postMultiImageFirebaseController.deleteImageList(
                          index,
                          pickedImages,
                        );
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
