// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';
import 'package:image_picker/image_picker.dart';

class UpdateBoardScreen extends StatefulWidget {
  final BoardFirebaseModel boards;
  const UpdateBoardScreen({Key? key, required this.boards}) : super(key: key);

  @override
  _UpdateBoardScreenState createState() => _UpdateBoardScreenState();
}

class _UpdateBoardScreenState extends State<UpdateBoardScreen> {
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
  TextEditingController titleController = TextEditingController();
  TextEditingController introductionTextController = TextEditingController();
  TextEditingController testerRequestController = TextEditingController();
  TextEditingController githubUrlController = TextEditingController();
  TextEditingController testerRequestProfileController =
      TextEditingController();
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
  File? pickedImage;
  List<XFile?> pickedImages = [];

  @override
  void initState() {
    try {
      super.initState();
      pickedImages = widget.boards.appImagesUrl
          .map((path) => XFile(path))
          .toList(growable: true);
      _initializeForm();
    } catch (e, stackTrace) {
      print('Error in initState: $e\n$stackTrace');
    }
  }

  void _initializeForm() {
    titleController.text = widget.boards.title;
    introductionTextController.text = widget.boards.introductionText;
    testerRequestController.text = widget.boards.testerRequest.toString();
    githubUrlController.text = widget.boards.githubUrl;
    appSetupUrlController.text = widget.boards.appSetupUrl;
    selectedLanguages = widget.boards.language!.whereType<String>().toList();
    pickedImage = File(widget.boards.iconImageUrl);
  }

  void _pickImages() async {
    try {
      List<XFile?> pickedImageFiles =
          await _multiImageFirebaseController.pickMultiImage(pickedImages);
      setState(() {
        pickedImages = pickedImageFiles;
      });
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void _savePost() async {
    try {
      // 현재 사용자의 UID가 없으면 에러 출력 후 함수 종료
      if (_authController.currentUser?.uid == null) {
        print('오류: 사용자 데이터를 가져올 수 없습니다.');
        return;
      }

      List<String> appImagesUrl = [];
      String iconImageUrl = "";
      String? userUid = _authController.currentUser!.uid;

      // 선택된 이미지들이 유효한지 검사
      if (_validatePickedImages()) {
        // 다중 이미지 업데이트
        List<String> urls = await _multiImageFirebaseController
            .updateMultiImages(pickedImages, widget.boards.appImagesUrl);
        appImagesUrl.addAll(urls);
      }

      // 폼 검증
      if (_formKey.currentState!.validate()) {
        // 새로운 게시물 모델 생성
        BoardFirebaseModel newPost = BoardFirebaseModel(
          docid: '',
          isApproval: false,
          createUid: userUid.toString(),
          developer: _authController.userData?['profileName'],
          createAt: DateTime.now(),
          updateAt: null,
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

        // 게시물 업데이트
        await _boardFirebaseController.updateBoard(newPost);

        // 홈 화면으로 이동
        Get.back();
      }
    } catch (e, stackTrace) {
      // 예외 발생 시 에러 출력 및 필요한 경우 사용자에게 메시지 표시
      print('오류 in _savePost: $e\n$stackTrace');
      // 에러 처리를 위한 추가적인 동작 수행
    }
  }

// 선택된 이미지들이 유효한지 검증하는 함수
  bool _validatePickedImages() {
    if (pickedImages.every(
      (file) =>
          file != null &&
          (file.path.startsWith('http') || File(file.path).existsSync()),
    )) {
      return true;
    } else {
      // 선택된 이미지가 유효하지 않을 경우 에러 출력
      print('오류: 선택된 이미지가 올바르지 않습니다.');
      // 에러 처리를 위한 추가적인 동작 수행
      return false; // 또는 예외를 throw하여 프로세스를 중지할 수 있음
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
                            : Image.network(
                                widget.boards.iconImageUrl,
                                width: 84,
                                height: 84,
                              ),
                        if (pickedImage == null)
                          Text('Logo Image',
                              style: TextStyle(color: colors.textColor)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
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
              Column(
                children: [
                  ExpansionTile(
                    title: Text("Supported Languages",
                        style: TextStyle(color: colors.textColor)),
                    children: [
                      Column(
                        children: availableLanguages.map((language) {
                          bool isSelected =
                              selectedLanguages.contains(language);
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
                      onPressed: _pickImages,
                      icon: Icon(
                        Icons.camera_alt,
                        size: 60,
                        color: colors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text(
                    "Please register App images",
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
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: pickedImages[index]!.path.startsWith('http')
                        ? Image.network(
                            pickedImages[index]!.path,
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(pickedImages[index]!.path),
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    width: 20,
                    height: 20,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          _multiImageFirebaseController
                              .deleteUpdateImage(
                                  index, widget.boards.appImagesUrl)
                              .then((value) => setState(() {}));
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
      height: _fontSizeCollection.buttonSize,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () {
          InterstitialAd();
          _savePost();
        },
        child: Text(
          'Update Post',
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              color: colors.iconColor),
        ),
      ),
    );
  }
}
