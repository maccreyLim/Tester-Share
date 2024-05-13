//기존이미지 삭제수정은 됨. 기존이미지에서 추가를 하면 이미지파일은 올라가는데 appImageUrl에는 주소가 리스트에 기족이 안됨

import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/my_tester_request_post_tr.dart';
import 'package:tester_share_app/widget/w.RewardAdManager.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

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
  final InterstitialAdController adController = InterstitialAdController();
  TextEditingController titleController = TextEditingController();
  TextEditingController introductionTextController = TextEditingController();
  TextEditingController testerRequestController = TextEditingController();
  TextEditingController githubUrlController = TextEditingController();
  TextEditingController testerRequestProfileController =
      TextEditingController();
  TextEditingController appSetupUrlController = TextEditingController();
  List<String> availableLanguages = [
    tr("English"),
    tr("Korean"),
    tr("Chinese"),
    tr("Japanese"),
    tr("Spanish"),
    tr("French"),
    tr("German")
  ];
  List<String> selectedLanguages = [];
  File? pickedImage;
  List<XFile?> pickedImages = [];
  List<String> appImagesUrl = [];

  @override
  void initState() {
    try {
      //초기화 함수 호출
      pickedImages = widget.boards.appImagesUrl
          .map((path) => XFile(path))
          .toList(growable: true);
      _initializeForm();
    } catch (e, stackTrace) {
      print('Error in initState: $e\n$stackTrace');
    }
    super.initState();
  }

//폼 초기화 함수
  void _initializeForm() {
    titleController.text = widget.boards.title;
    introductionTextController.text = widget.boards.introductionText;
    testerRequestController.text = widget.boards.testerRequest.toString();
    githubUrlController.text = widget.boards.githubUrl ?? '';
    appSetupUrlController.text = widget.boards.appSetupUrl;
    selectedLanguages = widget.boards.language!.whereType<String>().toList();
    pickedImage = File(widget.boards.iconImageUrl);
  }

  void _savePost() async {
    try {
      // 현재 사용자의 UID가 없으면 에러 출력 후 함수 종료
      if (_authController.currentUser?.uid == null) {
        print('오류: 사용자 데이터를 가져올 수 없습니다.');
        return;
      }

      String iconImageUrl = widget.boards.iconImageUrl;
      String? userUid = _authController.currentUser!.uid;

      // 폼 검증
      if (_formKey.currentState!.validate()) {
        // 새로 추가된 이미지만 필터링
        List<XFile?> newImages = pickedImages
            .where((image) =>
                image != null &&
                !widget.boards.appImagesUrl.contains(image.path))
            .toList();

        // 선택된 이미지들이 유효한지 검사
        if (_validatePickedImages()) {
          // 이미지가 변경된 경우에만 업로드 수행
          if (newImages.isNotEmpty ||
              appImagesUrl.length != pickedImages.length) {
            // 다중 이미지 업로드
            List<String> newUrls = await _multiImageFirebaseController
                .updateMultiImages(pickedImages, widget.boards.appImagesUrl);
            appImagesUrl = newUrls; // 새로운 URL로 리스트 업데이트
          }
        }

        // 새로운 게시물 모델 생성
        BoardFirebaseModel newPost = BoardFirebaseModel(
          docid: widget.boards.docid,
          isApproval: widget.boards.isApproval,
          isDeploy: widget.boards.isDeploy,
          createUid: userUid.toString(),
          developer: _authController.userData?['profileName'],
          createAt: widget.boards.createAt,
          updateAt: DateTime.now(),
          title: titleController.text,
          introductionText: introductionTextController.text,
          testerRequest: int.parse(testerRequestController.text),
          testerParticipation: widget.boards.testerParticipation,
          appImagesUrl: appImagesUrl,
          iconImageUrl: iconImageUrl,
          githubUrl: githubUrlController.text,
          appSetupUrl: appSetupUrlController.text,
          language: selectedLanguages,
          rquestProfileName: widget.boards.rquestProfileName,
        );

        // 게시물 업데이트
        await _boardFirebaseController.updateBoard(newPost);

        // 홈 화면으로 이동
        Get.to(() => MyTesterRequestPostScreen());
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
              Column(
                children: [
                  ExpansionTile(
                    title: Text("Supported Languages",
                            style: TextStyle(color: colors.textColor))
                        .tr(),
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
                enabled: false, // 수정 불가능하도록 설정
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return tr('Please enter a valid number');
                  }
                  return null;
                },
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
                      return tr('Please enter GitHub repository URL');
                    }
                    return null;
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
                        List<XFile?> result =
                            await _multiImageFirebaseController
                                .pickMultiImage(pickedImages);
                        setState(() {
                          pickedImages = result;
                          print("업데이트된 리스트:$pickedImages");
                        });
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
              SizedBox(height: 20),
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
              SizedBox(
                width: 150,
                child: Column(
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
                      margin: const EdgeInsets.only(top: 10),
                      width: 20,
                      height: 20,
                      child: IconButton(
                        onPressed: () async {
                          // 기존 이미지를 삭제하고 리스트에서도 제거
                          List<String> updatedImageUrls =
                              await _multiImageFirebaseController
                                  .deleteUpdateImageList(
                                      index, widget.boards.appImagesUrl);

                          setState(() {
                            pickedImages.removeAt(index);
                            appImagesUrl.clear();
                            appImagesUrl.addAll(updatedImageUrls);
                            print("삭제 업데이트할 리스트: $updatedImageUrls");
                            print("최종 업데이트할 리스트: $appImagesUrl");
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
              ),
              // const SizedBox(width: 10), // 이미지 간격 조정을 위한 SizedBox 추가
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
          adController.loadAndShowAd();
          _savePost();
        },
        child: Text(
          'Update Post',
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
}
