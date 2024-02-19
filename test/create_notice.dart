import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi_diary/controller/auth_controller.dart';
import 'package:navi_diary/controller/notice_controller.dart';
import 'package:navi_diary/model/notice_model.dart';
import 'package:navi_diary/scr/notice_screen.dart';
import 'package:navi_diary/widget/show_toast.dart';
import 'package:tester_share_app/controller/notice_controller.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({Key? key}) : super(key: key);

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  //Property
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  final AuthController _authController = AuthController.instance;

//TextEditingController dispose
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentsController.dispose();
  }

//저장 버튼
  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 16.w, 0),
      child: SizedBox(
        width: 1000.w,
        height: 150.h,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
          ),
          onPressed: () async {
            NoticeFirebaseModel announcetList = NoticeFirebaseModel(
              uid: _authController.userData!['uid'],
              profileName: _authController.userData!['profileName'] ?? "",
              isLiked: false,
              likeCount: 0,
              title: titleController.text, // 입력 필드의 값 사용
              content: contentsController.text, // 입력 필드의 값 사용
              createdAt: DateTime.now(),
              id: "", // 문서 아이디
            );

            await NoticeController().createNotice(announcetList);

            showToast('게시물이 성공적으로 저장되었습니다.', 1);
            setState(() {
              Get.back();
            });
          },
          child: Text(
            'SAVE',
            style: TextStyle(fontSize: 60, color: Colors.white54),
          ),
        ),
      ),
    );
  }

//입력폼( 컨트롤러 , 텍스트필트 이름,텍스트필드 라인수)
  Widget inputText(TextEditingController name, String nametext, int line) {
    return Row(
      children: [
        Text(
          nametext,
          style: TextStyle(fontSize: 50.sp),
        ),
        SizedBox(
          width: 20.w,
        ),
        SizedBox(
          width: 840.w,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              hintText: "",
            ),
            keyboardType:
                TextInputType.multiline, // Use multiline keyboard type
            maxLines: line, // Allow multiple lines
            validator: (value) {
              if (value!.isEmpty) {
                return "$nametext을 입력해주세요";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple,
              Colors.blue,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 230.h,
              left: 15,
              child: Center(
                child: Container(
                  width: 1000.w,
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
                ),
              ),
            ),
            Positioned(
              top: 70.h,
              left: 50.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                ' Create',
                                style: GoogleFonts.pacifico(
                                  fontSize: 150.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 380.w,
                              ),
                              IconButton(
                                onPressed: () {
                                  // 뒤로가기
                                  Get.back();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(width: 180.w),
                              Text(
                                'Notice',
                                style: GoogleFonts.pacifico(
                                  fontSize: 150.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 100.h,
              left: 40.w,
              right: 20.w,
              top: 540.w,
              child: Column(
                children: [
                  Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          inputText(titleController, "제목", 1),
                          SizedBox(
                            height: 50.h,
                          ),
                          inputText(contentsController, "내용", 10),
                          SizedBox(height: 320.h),
                          SizedBox(
                              height: 150.h,
                              width: 1000.w,
                              child: saveButton()),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
