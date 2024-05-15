import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/widget/w.RewardAdManager.dart';
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
  final MassageFirebaseController _mfirebase = MassageFirebaseController();
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
    "German",
    "Other languages"
  ];
  List<String> selectedLanguages = [];
  File? pickedImage; //이미지를 담는 변수
  List<XFile?> pickedImages = []; // 이미지 File을 저장할 리스트
  int point = 0;

  @override
  void initState() {
    _initializeForm();
    super.initState();
  }

  void _initializeForm() {
    testerRequestController.text =
        _authController.userData!['point'].toString();
    super.initState();
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

  Future<void> _savePost() async {
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
        isDeploy: false,
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
        language: selectedLanguages,
        rquestProfileName: [],
      );
      try {
        await _boardFirebaseController.addBoard(newPost);
        String _uid = _authController.userData!['uid'];
        int value =
            ++_authController.userData!['testerRequest']; // 전위 증가 연산자 사용
        int savepoint =
            int.parse(_authController.userData!['point'].toString()) -
                int.parse(testerRequestController.text);

        // 업데이트할 데이터
        Map<String, dynamic> _userNewData = {
          "testerRequest": value,
          "point": savepoint
        };
        // 사용자 데이터 업데이트
        _authController.updateUserData(_uid, _userNewData);

        //관리자에게 새 프로젝트 생성 알림
        final nickname = _authController.userData!['profileName'] as String;
        MessageModel message = MessageModel(
            senderUid: userUid.toString(),
            receiverUid: "17sgMj5H7qMh7JyZ81SlESYRGV52",
            contents: "미승인된 $nickname님의 새로운 프로젝트가 있습니다.",
            timestamp: DateTime.now());
        _mfirebase.createMessage(message, nickname);
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
                  Expanded(
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        icon: const Icon(Icons.title),
                        labelText: tr('Title'),
                        hintText: tr('Please write the title'),
                        labelStyle: TextStyle(color: colors.textColor),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return tr('Title is required');
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text("Supported Languages",
                        style: TextStyle(color: colors.textColor))
                    .tr(),
                children: [
                  Column(
                    children: availableLanguages.map((language) {
                      bool isSelected = selectedLanguages.contains(language);
                      return CheckboxListTile(
                        title: Text(tr(language),
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
                  const SizedBox(height: 10),
                  // 선택된 언어가 없으면 에러 메시지를 표시합니다.
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  selectedLanguages.isEmpty
                      ? const Text(
                          "Please select at least one language",
                          style: TextStyle(color: Colors.red),
                        ).tr()
                      : Text(
                          selectedLanguages
                              .map((language) => tr(language))
                              .join(', '),
                          style: const TextStyle(color: Colors.blue),
                        ),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: introductionTextController,
                maxLines: 3,
                decoration: InputDecoration(
                  icon: const Icon(Icons.text_fields),
                  labelText: tr('Introduction Text'),
                  hintText: tr('Please write the introduction text'),
                  labelStyle: TextStyle(color: colors.textColor),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('Introduction text is required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: testerRequestController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  icon: const Icon(Icons.numbers),
                  labelText: tr('Number of testers to request'),
                  hintText: tr('Please enter the number of testers required'),
                  labelStyle: TextStyle(color: colors.textColor),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return tr('Please enter a valid number');
                  }

                  int requestedTesters = int.parse(value);
                  int availablePoints =
                      int.parse(_authController.userData!['point'].toString());

                  if (requestedTesters > availablePoints) {
                    return tr("Insufficient points.");
                  }

                  return null;
                },
              ),
              Row(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 40),
                      Obx(() {
                        String _point =
                            _authController.userData!['point'].toString();
                        return Text(
                          "( You can request recruitment of up to {} testers currently. )",
                          style:
                              TextStyle(color: colors.textColor, fontSize: 10),
                        ).tr(args: [_point]);
                      }),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 30),
                    SizedBox(
                      width: 300,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          //안내문
                          _showLoadingDialog();
                          setState(() {
                            showRewardAd();
                          });
                        },
                        child:
                            const Text("Earn points by watching advertisements")
                                .tr(),
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: githubUrlController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.link),
                    labelText: tr('GitHub URL'),
                    hintText: tr('GitHub repository URL'),
                    labelStyle: TextStyle(color: colors.textColor),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    return null;
                    // 그 외의 경우는 GitHub repository URL이 입력되었는지 확인
// 유효성 검사 통과
                  }),
              const SizedBox(height: 20),
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: appSetupUrlController,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.link),
                    labelText: tr('Web participation link'),
                    hintText: tr(
                        'Please enter the download address of the Test App.'),
                    labelStyle: TextStyle(color: colors.textColor),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr(
                          'Please enter the download address of the Test App.');
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
                    tr("Please register the app image"),
                    style: TextStyle(
                      color: colors.textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              pickedImages.isEmpty ? Container() : multiImageListView(),
              const SizedBox(height: 20), // Expanded 위젯 제거 후 간격 조절 위젯 추가
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
          return SizedBox(
            width: 150,
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
                  width: 20,
                  height: 20,
                  child: IconButton(
                    onPressed: () async {
                      setState(() {
                        _multiImageFirebaseController.deleteImageList(
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

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        ),
        onPressed: () async {
          // 유효성 검사를 수행
          if (!_formKey.currentState!.validate()) {
            // 하나 이상의 필수 항목이 비어 있음을 알림
            return;
          }
          Get.dialog(
            const Center(
              child: CircularProgressIndicator(),
            ),
            barrierDismissible: false,
          );
          adController.loadAndShowAd();
          await _savePost(); // _savePost()가 완료될 때까지 대기
          // 저장이 완료되면 홈 화면으로 이동
          Get.back();
          Get.back();
          MessageModel message = MessageModel(
              senderUid: "17sgMj5H7qMh7JyZ81SlESYRGV52",
              receiverUid: _authController.userData!['uid'],
              contents:
                  "The project has been registered\nYou can check it in Setting -> My Tester Request Post\nPlease wait momentarily while the administrator reviews and approves the project\n\n프로젝트가 등록되었습니다.\n설정 -> 나의 테스터 요청 게시물에서 확인할 수 있습니다.\n관리자가 프로젝트를 검토하고 승인할 때까지 잠시만 기다려 주십시오.\n\nプロジェクトが登録されました。\n設定 -> 私のテスター要求投稿で確認できます。\n管理者がプロジェクトをレビューし、承認するまでしばらくお待ちください。",
              timestamp: DateTime.now());
          _mfirebase.createMessage(message, tr("Admin"));
        },
        child: Text(
          'Create Post',
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              color: colors.iconColor),
        ).tr(),
      ),
    );
  }

  void showRewardAd() {
    final RewardAdManager _rewardAd = RewardAdManager();
    _rewardAd.showRewardFullBanner(() {
      String _uid = _authController.userData!['uid'];
      int value = ++_authController.userData!['point']; // 전위 증가 연산자 사용

      // 업데이트할 데이터
      Map<String, dynamic> _userNewData = {
        "point": value,
        // 필요한 경우 다른 필드도 추가할 수 있습니다.
      };
      // 사용자 데이터 업데이트
      _authController.updateUserData(_uid, _userNewData);
      // 광고를 보고 사용자가 리워드를 얻었을 때 실행할 로직
      // 예: 기부하기 또는 다른 작업 수행
    });
  }

  void _showLoadingDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black, // 배경색을 회색으로 변경
        title: Text("잠시만 기다려 주세요!!", style: TextStyle(color: colors.iconColor)),
        content: Text("곧 광고가 나옵니다.", style: TextStyle(color: colors.iconColor)),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("확인"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    // 3초 후에 다이얼로그를 닫습니다.
    // 3초 후에 다이얼로그를 닫습니다.
    Timer(Duration(seconds: 3), () {
      Get.back();
    });
  }
}
