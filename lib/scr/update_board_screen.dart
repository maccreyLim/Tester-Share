// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class UpdateBoardScreen extends StatefulWidget {
  final BoardFirebaseModel boards;
  const UpdateBoardScreen({Key? key, required this.boards}) : super(key: key);

  @override
  _UpdateBoardScreenState createState() => _UpdateBoardScreenState();
}

class _UpdateBoardScreenState extends State<UpdateBoardScreen> {
  // Property
  final AuthController _authController = AuthController.instance;
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
  String? pickedImageUrl;
  List<XFile?> pickedimages = []; // List to store image files

  void _pickImage() async {
    XFile? pickedImageFile =
        await _singleImageFirebaseController.pickSingleImage();
    setState(() {
      pickedImage = pickedImageFile != null ? File(pickedImageFile.path) : null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    introductionTextController.dispose();
    testerRequestController.dispose();
    githubUrlController.dispose();
    testerRequestProfileController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _initializeForm();
    selectedLanguages = widget.boards.language!.whereType<String>().toList();

    pickedImageUrl = widget.boards.iconImageUrl;

    pickedimages = widget.boards.appImagesUrl
        .map((path) => XFile(path))
        .toList(growable: true);

    // Set up listeners for controllers
    titleController.addListener(() {
      setState(() {
        widget.boards.title = titleController.text;
      });
    });
    introductionTextController.addListener(() {
      setState(() {
        widget.boards.introductionText = introductionTextController.text;
      });
    });
    testerRequestController.addListener(() {
      setState(() {
        widget.boards.testerRequest = int.parse(testerRequestController.text);
      });
    });
    appSetupUrlController.addListener(() {
      setState(() {
        widget.boards.appSetupUrl = appSetupUrlController.text;
      });
    });
  }

  void _initializeForm() {
    titleController.text = widget.boards.title;
    introductionTextController.text = widget.boards.introductionText;
    testerRequestController.text = widget.boards.testerRequest.toString();
    githubUrlController.text = widget.boards.githubUrl;
    appSetupUrlController.text = widget.boards.appSetupUrl;
  }

  void _savePost() async {
    if (_authController.currentUser?.uid == null) {
      print('Error: User data not available.');
      return;
    }

    List<String> appImagesUrl = [];
    String downloadUrl = "";
    String? userUid = _authController.currentUser!.uid;
    print("UID to save: $userUid");
    // 이미지 목록이 비어 있지 않고 파일이 존재하는지 확인한 후 업로드
    if (pickedimages.isNotEmpty &&
        pickedimages.every(
            (file) => file?.path != null && File(file!.path).existsSync())) {
      appImagesUrl =
          await _multiImageFirebaseController.uploadMultiImages(pickedimages);
    }

    if (pickedImage != null && pickedImage!.existsSync()) {
      downloadUrl = (await _singleImageFirebaseController
          .uploadSingleImage(XFile(pickedImage!.path)))!;
    }
    print(appImagesUrl);
    print(pickedImage);

    if (_formKey.currentState!.validate()) {
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
        iconImageUrl: downloadUrl,
        githubUrl: githubUrlController.text,
        appSetupUrl: appSetupUrlController.text,
        testerRequestProfile: {
          'tester_name': [],
        },
        language: selectedLanguages,
      );

      await _boardFirebaseController.updateBoard(newPost);

      Get.off(() => HomeScreen());
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
              Get.off(() => HomeScreen());
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
                  Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        width: 84,
                        height: 84,
                        color: Colors.white12,
                        child: Column(
                          children: [
                            Image.network(
                              pickedImageUrl!,
                              width: 84,
                              height: 84,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() async {
                            XFile? xFile = await _singleImageFirebaseController
                                .pickSingleImage();
                            pickedImage =
                                xFile != null ? File(xFile.path) : null;
                          });
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 20,
                        ),
                      ),
                    ],
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
              ExpansionTile(
                title: Text(
                  "Supported Languages",
                  style: TextStyle(color: colors.textColor),
                ),
                children: [
                  Column(
                    children: availableLanguages.map((language) {
                      bool isSelected = selectedLanguages.contains(language);
                      return CheckboxListTile(
                        title: Text(
                          language,
                          style: TextStyle(color: colors.textColor),
                        ),
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
                controller: githubUrlController,
                decoration: InputDecoration(
                  icon: const Icon(Icons.link),
                  labelText: 'GitHub URL',
                  hintText: 'GitHub repository URL',
                  labelStyle: TextStyle(color: colors.textColor),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
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
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: IconButton(
                      onPressed: () async {
                        await _multiImageFirebaseController
                            .pickMultiImage(pickedimages);
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
                    "Please register App images",
                    style: TextStyle(
                      color: colors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              pickedimages.isEmpty ? Container() : multiImageListView(),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: _savePost,
                child: Text(
                  'Update Post',
                  style: TextStyle(fontSize: 20, color: colors.iconColor),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget multiImageListView() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pickedimages.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: pickedimages[index]!.path.startsWith('http')
                        ? Image.network(
                            pickedimages[index]!.path,
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(pickedimages[index]!.path),
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
                        _multiImageFirebaseController.deleteImageList(
                            index, pickedimages);
                        setState(() {});
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
}
