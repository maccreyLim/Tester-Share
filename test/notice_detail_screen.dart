import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi_diary/model/notice_model.dart';
import 'package:navi_diary/scr/notice_screen.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';

class NoticeDetailScreen extends StatelessWidget {
  //Property
  final NoticeFirebaseModel notice;
  const NoticeDetailScreen({super.key, required this.notice});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          //바탕화면
          Container(
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
            //반투명 폼
            Positioned(
              top: 340.h,
              left: 20.w,
              child: Center(
                child: Container(
                  width: 1040.w,
                  height: 1700.h,
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
            //네이밍
            Positioned(
              top: 70.h,
              left: 40.w,
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
                                ' Notice',
                                style: GoogleFonts.pacifico(
                                  fontSize: 120.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                width: 500.w,
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
                              SizedBox(width: 220.w),
                              Text(
                                ' Detail',
                                style: GoogleFonts.pacifico(
                                  fontSize: 120.sp,
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
            //화면구성
            Positioned(
              top: 450.h,
              left: 80.w,
              right: 80.w,
              bottom: 380.h,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    Text(
                      notice.title,
                      style: TextStyle(
                        fontSize: 70.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 120.h),
                    Text(
                      notice.content,
                      style: TextStyle(
                        fontSize: 50.sp,
                        color: Colors.white,
                      ),
                    ),
                    // 원하는 다른 위젯 추가
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 110.h,
              left: 80.w,
              child: Container(
                height: 150.h,
                width: 920.w,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const NoticeScreen());
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.indigo),
                  ),
                  child: Text(
                    "확   인",
                    style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white54),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
