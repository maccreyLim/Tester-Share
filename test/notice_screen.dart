import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi_diary/controller/auth_controller.dart';
import 'package:navi_diary/model/notice_model.dart';
import 'package:navi_diary/scr/create_notice.dart';
import 'package:navi_diary/scr/home_screen.dart';
import 'package:navi_diary/scr/notice_detail_screen.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({super.key});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  //Property
  //AuthController의 인스턴스를 얻기
  final AuthController _authController = AuthController.instance;
// Firebase Firestore로부터 공지사항을 가져오기 위한 쿼리
  final Query query = FirebaseFirestore.instance.collection('notice');
  //공지사항 리스트뷰빌더로 구현
  Widget buildCommentListView(List<NoticeModel> announcementList) {
    final now = DateTime.now();

    return Container(
      child: SizedBox(
        height: 1800.h,
        width: 1000.w,
        child: ListView.builder(
          itemCount: announcementList.length,
          itemBuilder: (context, index) {
            final comment = announcementList[index];
            //작성시간과 얼마나 지났는지 표시를 위한 함수 구현
            final DateTime created = comment.createdAt;
            final Duration difference = now.difference(created);

            String formattedDate;

            if (difference.inHours > 0) {
              formattedDate = '${difference.inHours}시간 전';
            } else if (difference.inMinutes > 0) {
              formattedDate = '${difference.inMinutes}분 전';
            } else {
              formattedDate = '방금 전';
            }
            //리스트 타이틀로 구현
            return ListTile(
              leading: const Icon(Icons.circle, size: 14, color: Colors.grey),
              title: Text(
                "${comment.title} ($formattedDate)",
                maxLines: 1, // 최대 줄 수를 1로 설정
                overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)),
              ),
              subtitle: Text(
                comment.content,
                maxLines: 3, // 최대 줄 수를 1로 설정
                overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)
              ),
              onTap: () {
                Get.to(() => NoticeDetailScreen(notice: comment));
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              top: 220.h,
              left: 20.w,
              child: Center(
                child: Container(
                  width: 1040.w,
                  height: 1900.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // 그림자의 색상과 투명도
                        spreadRadius: 5, // 그림자의 확산 범위
                        blurRadius: 7, // 그림자의 흐림 정도
                        offset: const Offset(0, 3), // 그림자의 위치 조정 (가로, 세로)
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
              left: 50.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Notice',
                        style: GoogleFonts.pacifico(
                          fontSize: 150.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 440.w,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.to(() => const HomeScreen());
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //화면구성
            Positioned(
              bottom: 152.h,
              left: 40.w,
              right: 40.w,
              child: Column(
                children: [
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: query.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Text('공지사항 데이터를 가져오는 중 오류가 발생했습니다.');
                        }

                        final querySnapshot = snapshot.data;
                        if (querySnapshot == null ||
                            querySnapshot.docs.isEmpty) {
                          return const Text('공지사항이 없습니다.');
                        }

                        final announcementList = querySnapshot.docs
                            .map((doc) => NoticeModel.fromMap(
                                doc.data() as Map<String, dynamic>))
                            .toList();
                        announcementList.sort((a, b) =>
                            b.createdAt.compareTo(a.createdAt)); // 내림차순 정렬
                        return SingleChildScrollView(
                            child: buildCommentListView(announcementList));
                      },
                    ),
                  ),
                ],
              ),
            ),
            //FloatingActionButton 구현
            if (_authController.userData?['isAdmin'] ?? false)
              Positioned(
                bottom: 120.h,
                right: 40.w,
                child: FloatingActionButton(
                  backgroundColor: Colors.pink,
                  onPressed: () {
                    print('Click');
                    Get.to(() => const CreateNoticeScreen());
                  },
                  child: const Icon(
                    Icons.add,
                    size: 40,
                    color: Colors.white60,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
