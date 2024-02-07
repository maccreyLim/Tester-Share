import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi_diary/controller/diary_controller.dart';
import 'package:navi_diary/controller/auth_controller.dart';
import 'package:navi_diary/model/diary_model.dart';
import 'package:navi_diary/scr/home_screen.dart';
import 'package:navi_diary/widget/show_toast.dart';
import 'package:image_picker/image_picker.dart';

class UpdateDiaryScreen extends StatefulWidget {
  final DiaryModel diary;

  const UpdateDiaryScreen({Key? key, required this.diary}) : super(key: key);

  @override
  State<UpdateDiaryScreen> createState() => _UpdateDiaryScreenState();
}

class _UpdateDiaryScreenState extends State<UpdateDiaryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController.instance;
  final DiaryController _diaryController = DiaryController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();

  List<XFile?> images = [];
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool isDlelete = false;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    images = widget.diary.photoURL!
        .map((path) => XFile(path))
        .toList(growable: true);

    // titleController의 값이 변경될 때마다 호출되는 콜백 함수 등록
    titleController.addListener(() {
      // titleController 값이 변경될 때마다 widget.diary.title 업데이트
      setState(() {
        widget.diary.title = titleController.text;
      });
    });

    // contentsController의 값이 변경될 때마다 호출되는 콜백 함수 등록
    contentsController.addListener(() {
      // contentsController 값이 변경될 때마다 widget.diary.contents 업데이트
      setState(() {
        widget.diary.contents = contentsController.text;
      });
    });
  }

  void _initializeForm() {
    // 폼의 타이틀과 내용 초기화
    titleController.text = widget.diary.title;
    contentsController.text = widget.diary.contents;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 키보드를 내리는 함수
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          // 뒤로 가기
          Get.back();
          setState(() {});
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body:
            //배경 화면 구현
            Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.deepPurple,
                Colors.purpleAccent,
              ],
            ),
          ),
          child: Stack(
            children: [
              //TextFormFild가 있는 스택
              _buildFormContainer(),
              //Update a Diary 텍스트 구현
              _buildTitleText(),
              //수정 버튼
              _buildSaveButton(),
              //삭제버튼
              _buildDeleteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContainer() {
    return Positioned(
      top: 300.h,
      left: 20.w,
      child: Center(
        child: Container(
          width: 1040.w,
          height: 1500.h,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  _buildTitleTextField(),
                  const SizedBox(height: 10),
                  _buildContentsTextField(),
                  _buildCameraIconButton(),
                  const SizedBox(height: 10),
                  _buildImageListView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Positioned(
      top: 140.h,
      left: 20.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Update Diary',
                style: GoogleFonts.pacifico(
                  fontSize: 150.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10.w),
              IconButton(
                onPressed: () {
                  Get.off(() => const HomeScreen());
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      bottom: 220.h,
      left: 20.w,
      child: SizedBox(
        width: 1040.w,
        height: 150.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
          child: Text(
            '수정',
            style: TextStyle(
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          onPressed: () async {
            try {
              // 다이어리 업데이트
              await _saveDiary(images);

              Get.offAll(() => const HomeScreen());
            } catch (e) {
              print('Error saving diary: $e');
            } finally {
              Get.back();
            }
          },
          onLongPress: () {
            // 홈 스크린으로 이동
            Get.to(() => const HomeScreen());
          },
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Positioned(
      bottom: 50.h,
      left: 20.w,
      child: SizedBox(
        width: 1040.w,
        height: 150.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: isDlelete ? Colors.pink : Colors.grey),
          child: Text(
            isDlelete ? '길게 누르면 삭제가 됩니다.' : '삭제',
            style: TextStyle(
              fontSize: 50.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white60,
            ),
          ),
          onPressed: () {
            //길게 눌렀을때 삭제 됨을 표시
            setState(() {
              isDlelete = !isDlelete;
            });
          },
          onLongPress: () async {
            // 파이어 스토리지에서 이미지 삭제
            if (widget.diary.photoURL?.isNotEmpty == true) {
              deleteImages(widget.diary.photoURL);
            }

            // 파이어스토어에서 다이어리 삭제
            await _diaryController.deleteDiary(widget.diary.id.toString());

            // 홈 화면으로 이동
            Get.to(() => const HomeScreen());
          },
        ),
      ),
    );
  }

  Widget _buildTitleTextField() {
    return TextFormField(
      controller: titleController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: Icon(Icons.title),
        labelText: 'Title',
        hintText: 'Please write the title"',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required field';
        }
        return null;
      },
    );
  }

  Widget _buildContentsTextField() {
    return TextFormField(
      maxLength: 400,
      maxLines: 8,
      controller: contentsController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: Icon(Icons.content_paste),
        labelText: 'Contents',
        hintText: 'Please write the contents"',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required field';
        }
        return null;
      },
    );
  }

  Widget _buildCameraIconButton() {
    return IconButton(
      onPressed: _pickMultiImage,
      icon: Icon(
        Icons.camera_alt_outlined,
        size: 140.sp,
      ),
    );
  }

  void _pickMultiImage() async {
    try {
      // 이미지 선택
      List<XFile>? selectedImages = await ImagePicker().pickMultiImage();

      if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages);
        setState(() {});
      }
    } catch (e) {
      print('이미지 선택 오류: $e');
    }
  }

  Widget _buildImageListView() {
    return Container(
      height: 280.h,
      width: 1000.w,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return _buildImageContainer(index);
        },
      ),
    );
  }

  // Widget _buildAddImageButton() {
  //   return GestureDetector(
  //     onTap: _pickMultiImage,
  //     child: Container(
  //       color: Colors.amber,
  //       height: 200.h,
  //       width: 140.w,
  //       margin: const EdgeInsets.only(right: 10),
  //       decoration: BoxDecoration(
  //         color: Colors.grey.withOpacity(0.3),
  //         borderRadius: BorderRadius.circular(15.0),
  //       ),
  //       child: const Center(
  //         child: Icon(
  //           Icons.add,
  //           size: 40,
  //           color: Colors.white,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildImageContainer(int index) {
    return Container(
      height: 160.h,
      width: 240.w,
      child: Stack(
        children: [
          Positioned(
            top: 18.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: images[index]!.path.startsWith('http')
                  ? Image.network(
                      images[index]!.path,
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(images[index]!.path),
                      width: 200.w,
                      height: 200.h,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: 50.h,
            left: 50.w,
            child: Container(
              width: 260.w,
              height: 400.h,
              child: IconButton(
                onPressed: () {
                  // 이미지 삭제
                  deleteUpdateImage(index);
                  setState(() {});
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.black54,
                  size: 70.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _saveDiary(List<XFile?> updatedImages) async {
    if (_formKey.currentState!.validate()) {
      if (_authController.userData != null) {
        try {
          // 로딩 인디케이터 표시
          showLoadingIndicator();

          // 삭제된 이미지 URL 가져오기
          List<String> deletedImageUrls = widget.diary.photoURL!
              .where((existingImageUrl) => !updatedImages
                  .any((newImage) => newImage?.path == existingImageUrl))
              .toList();

          // Firestore에서 삭제된 이미지 삭제
          await _deleteImagesFromFirestore(deletedImageUrls);

          print('새 이미지 업로드 중...');
          // 새 이미지 업로드 및 URL 가져오기
          List<String> newImageUrls = await _uploadNewImages(updatedImages);
          print('새 이미지 URL: $newImageUrls');

          // 다이어리 업데이트
          await _diaryController.updateDiary(
            widget.diary,
            images,
            deletedImageUrls,
            newImageUrls,
          );

          showToast('일기가 성공적으로 업데이트되었습니다', 1);
        } catch (e) {
          print('일기 업데이트 오류: $e');
          showToast('일기 업데이트 중 오류가 발생했습니다', 2);
        } finally {
          // 로딩 인디케이터 숨기기
          hideLoadingIndicator();
        }
      } else {
        showToast('사용자 데이터를 찾을 수 없습니다', 2);
      }
    }
  }

  // 로딩 인디케이터를 표시하는 메서드
  void showLoadingIndicator() {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // 로딩 인디케이터를 숨기는 메서드
  void hideLoadingIndicator() {
    Get.back();
  }

  Future<List<String>> _uploadNewImages(List<XFile?> newImages) async {
    List<String> updatedImageUrls = [];
    // 현재 로그인한 사용자의 UID 가져오기
    String uid = _authController.userData!['uid'] ?? 'unknown_user';

    for (XFile? newImage in newImages) {
      if (newImage != null) {
        if (newImage.path.startsWith('http')) {
          // 이미지가 이미 원격 URL인 경우 URL 그대로 사용
          updatedImageUrls.add(newImage.path);
        } else {
          // 이미지를 압축하고 Firebase Storage에 업로드
          File compressedImage = await _compressAndGetFile(File(newImage.path));
          final ref = _storage.ref().child('images/$uid/${DateTime.now()}');
          await ref.putFile(compressedImage);
          final url = await ref.getDownloadURL();
          updatedImageUrls.add(url);
        }
      }
    }

    return updatedImageUrls;
  }

  Future<void> _deleteImagesFromFirestore(List<String> deletedImageUrls) async {
    for (String deletedImageUrl in deletedImageUrls) {
      print('Firestore에서 이미지 삭제 중...');
      // Firestore에서 이미지 삭제
      await _diaryController.deleteImageFromFirestore(
          widget.diary, deletedImageUrl);
    }
    print('이미지가 성공적으로 삭제되었습니다.');
  }

  // 이미지를 압축하고 파일을 반환하는 비동기 함수
  Future<File> _compressAndGetFile(File file) async {
    // 이미지 품질 설정 (0부터 100까지, 높은 품질일수록 용량이 큼)
    int quality = 60;

    // FlutterImageCompress 라이브러리를 사용하여 이미지 압축
    List<int> compressedBytes = await FlutterImageCompress.compressWithList(
      file.readAsBytesSync(),
      quality: quality,
    );

    // 압축된 이미지를 새로운 파일로 저장
    File compressedFile = File('${file.path}_compressed.jpg')
      ..writeAsBytesSync(compressedBytes);

    // 압축된 파일 반환
    return compressedFile;
  }

// 이미지 수정삭제
  void deleteUpdateImage(int index) async {
    // photoURL이 null인 경우 빠져나감
    if (widget.diary.photoURL == null) {
      return;
    }

    try {
      // index가 photoURL 리스트의 범위 내에 있는지 확인
      if (index >= 0 && index < widget.diary.photoURL!.length) {
        String imageUrl = widget.diary.photoURL![index];
        FirebaseStorage storage = FirebaseStorage.instance;

        // imagePath를 사용하여 이미지 삭제
        await storage.refFromURL(imageUrl).delete();

        // Firestore에서도 삭제 가능하다면 해당 로직 추가
        // await _diaryController.deleteImageFromFirestore(widget.diary, imageUrl);

        setState(() {
          // images 리스트에서 이미지 삭제
          images.removeAt(index);
        });

        print('이미지가 성공적으로 삭제되었습니다.');
      } else {
        print('인덱스가 photoURL 리스트의 범위를 벗어납니다.');
      }
    } catch (error) {
      print('이미지 삭제 오류: $error');
    }
  }

// 이미지 삭제
  void deleteImages(List<String>? imageUrls) {
    if (imageUrls != null && imageUrls.isNotEmpty) {
      for (String imageUrl in imageUrls) {
        int index = widget.diary.photoURL!.indexOf(imageUrl);

        if (index >= 0 && index < widget.diary.photoURL!.length) {
          // imagePath를 사용하여 이미지 삭제
          FirebaseStorage.instance.refFromURL(imageUrl).delete();

          // Firestore에서도 삭제 가능하다면 해당 로직 추가
          // _diaryController.deleteImageFromFirestore(diary, imageUrl);
        }
      }
    }
  }

  // String extractPathFromUrl(String imageUrl) {
  //   // 이미지 URL에서 파일 경로 추출
  //   Uri uri = Uri.parse(imageUrl);
  //   String path = uri.path;
  //   // token 제거
  //   path = path.split('?').first;
  //   // URL 디코딩
  //   path = Uri.decodeFull(path);
  //   return path;
  // }
}
