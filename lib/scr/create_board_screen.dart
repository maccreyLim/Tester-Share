// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class CreateBoardScreen extends StatefulWidget {
  const CreateBoardScreen({super.key});

  @override
  _CreateBoardScreenState createState() => _CreateBoardScreenState();
}

class _CreateBoardScreenState extends State<CreateBoardScreen> {
  //Property
  final AuthController _authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final ColorsCollection colors = ColorsCollection();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final MultiImageFirebaseController _multiImageFirebaseController =
      MultiImageFirebaseController();
  final SingleImageFirebaseController _singleImageFirebaseController =
      SingleImageFirebaseController();
  final BoardFirebaseController _boardFirebaseController =
      BoardFirebaseController();
  final InterstitialAdController adController = InterstitialAdController();
  TextEditingController titleController = TextEditingController();
  TextEditingController introductionTextController = TextEditingController();
  TextEditingController testerRequestController = TextEditingController();
  // TextEditingController testerParticipationController = TextEditingController();
  // TextEditingController imageUrlController = TextEditingController();
  // TextEditingController iconImageUrlController = TextEditingController();
  TextEditingController githubUrlController = TextEditingController();
  TextEditingController testerRequestProfileController =
      TextEditingController();
  // TextEditingController languageController = TextEditingController();
  TextEditingController appSetupUrlController = TextEditingController();
  List<String> availableLanguages = [
    "English",
    "Korean",
    "Chinese",
    "Japanese",
    "Spanish",
    "French",
    "German"
  ];
  List<String> selectedLanguages = [];
  File? pickedImage; //이미지를 담는 변수
  List<XFile?> pickedImages = []; // 이미지 File을 저장할 리스트

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    introductionTextController.dispose();
    testerRequestController.dispose();
    githubUrlController.dispose();
    testerRequestProfileController.dispose();
  }

  void _savePost() async {
    if (_authController.currentUser?.uid == null) {
      // 사용자 데이터가 없으면 예외 처리 또는 다른 조치를 취할 수 있습니다.
      print('Error: 유저데이타가 없습니다.');
      return;
    }

    List<String> appImagesUrl = [];
    String iconImageUrl = "";
    String? userUid = _authController.currentUser!.uid;
    print("저장할 uid : userUid");

    if (pickedImage != null) {
      iconImageUrl = await _singleImageFirebaseController.uploadSingleImage(
              pickedImage != null ? XFile(pickedImage!.path) : null) ??
          "";
    }
    if (pickedImages.isNotEmpty) {
      appImagesUrl =
          await _multiImageFirebaseController.uploadMultiImages(pickedImages);
    }

    if (_formKey.currentState!.validate()) {
      // 게시물 저장 로직을 여기에 추가
      // BoardFirebaseModel을 활용하여 새로운 게시물을 생성
      BoardFirebaseModel newPost = BoardFirebaseModel(
        docid: '', // Firestore에서 자동 생성되는 값이므로 비워둠
        isApproval: false,
        createUid: userUid.toString(), // 현재 사용자의 UID로 설정
        developer: _authController.userData?['profileName'],
        createAt: DateTime.now(),
        updateAt: null, // 처음 생성이므로 null로 설정
        title: titleController.text,
        introductionText: introductionTextController.text,
        testerRequest: int.parse(testerRequestController.text),
        testerParticipation: 0,
        appImagesUrl: appImagesUrl,
        iconImageUrl: iconImageUrl,
        githubUrl: githubUrlController.text,
        appSetupUrl: appSetupUrlController.text,
        testerRequestProfile: {
          'tester_name': [],
        },
        language: selectedLanguages,
      );
      try {
        print("Before saving post: pickedImage: $pickedImage");
        print("Before saving post: appImagesUrl: $appImagesUrl");
        print("Before saving post: newPost: $newPost");
        await _boardFirebaseController.addBoard(newPost);

        // 저장이 완료되면 홈 화면으로 이동
        Get.off(() => HomeScreen());
      } catch (e) {
        print("Post 저장에 실패 : $e");
      }
      // Firestore에 게시물 추가
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    color: Colors.white12,
                    child: Column(
                      children: [
                        pickedImage == null
                            ? IconButton(
                                onPressed: () async {
                                  XFile? pickedXFile =
                                      await _singleImageFirebaseController
                                          .pickSingleImage();
                                  setState(() {
                                    pickedImage = pickedXFile != null
                                        ? File(pickedXFile.path)
                                        : null;
                                  });
                                },
                                icon: Icon(
                                  Icons.camera_alt,
                                  size: 46,
                                  color: colors.textColor,
                                ),
                              )
                            : Image.file(
                                pickedImage!,
                                width: 84,
                                height: 84,
                              ),
                        if (pickedImage == null)
                          Text('Logo Image',
                              style: TextStyle(color: colors.textColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30), // 간격 조절을 위한 SizedBox 추가
                  // Expanded 제거
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.title),
                        labelText: 'Title',
                        hintText: 'Please write the title',
                        labelStyle: TextStyle(color: colors.textColor),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Supported Languages",
                    style: TextStyle(color: colors.textColor)),
                children: [
                  Column(
                    children: availableLanguages.map((language) {
                      bool isSelected = selectedLanguages.contains(language);
                      return CheckboxListTile(
                        title: Text(language,
                            style: TextStyle(color: colors.textColor)),
                        value: isSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value!) {
                              selectedLanguages.add(language);
                            } else {
                              selectedLanguages.remove(language);
                            }
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                      );
                    }).toList(),
                  ),
                ],
              ),
              TextFormField(
                controller: introductionTextController,
                maxLines: 3,
                decoration: InputDecoration(
                  icon: const Icon(Icons.text_fields),
                  labelText: 'Introduction Text',
                  hintText: 'Please write the introduction text',
                  labelStyle: TextStyle(color: colors.textColor),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduction text is required';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: testerRequestController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: const Icon(Icons.numbers),
                  labelText: 'Number of testers to request',
                  hintText: 'Please enter the number of testers required',
                  labelStyle: TextStyle(color: colors.textColor),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: githubUrlController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.link),
                    labelText: 'GitHub URL',
                    hintText: 'GitHub repository URL',
                    labelStyle: TextStyle(color: colors.textColor),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter GitHub repository URL';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: appSetupUrlController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.link),
                    labelText: 'Test App Download Address',
                    hintText:
                        'Please enter the download address of the Test App.',
                    labelStyle: TextStyle(color: colors.textColor),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the download address of the Test App.';
                    }
                    return null;
                  }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      onPressed: () async {
                        // 이미지 가져오기
                        await _multiImageFirebaseController
                            .pickMultiImage(pickedImages);
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: colors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    " App 이미지를 등록해주세요",
                    style: TextStyle(
                      color: colors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              pickedImages.isEmpty ? Container() : multiImageListView(),
              Expanded(child: SizedBox()),
              Align(alignment: Alignment.bottomCenter, child: _saveButton()),
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
          return Row(
            children: [
              // 이미지 표시 부분
              Column(
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
                  // List에서 이미지 삭제 버튼
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 20, // 조절 가능한 너비
                    height: 20,
                    child: IconButton(
                      onPressed: () async {
                        // 이미지파일 삭제
                        setState(() {
                          _multiImageFirebaseController.deleteImageList(
                              index, pickedImages);
                        });
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 36),
            ],
          );
        },
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {
          adController.loadAndShowAd();
          _savePost();
        },
        child: Text(
          'Create Post',
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              color: colors.iconColor),
        ),
      ),
    );
  }
}
