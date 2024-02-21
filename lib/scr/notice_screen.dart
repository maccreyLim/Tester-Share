import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';
import 'package:tester_share_app/scr/create_notice_screen.dart';
import 'package:tester_share_app/scr/detail_notice_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class NoticeScreen extends StatelessWidget {
  final ColorsCollection colors = ColorsCollection();
  final AuthController authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  // Firestore 쿼리 실행을 위한 변수 선언
  final Query query = FirebaseFirestore.instance.collection('notice');
  NoticeScreen({super.key});

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
      body: Container(
        height: double.infinity,
        child: Column(
          children: [
            Text(
              "Notice",
              style: TextStyle(
                fontSize: _fontSizeCollection.settinFontSize,
                color: colors.textColor,
              ),
            ),
            Expanded(
              child: noticeStreenBuilder(),
            ),
            SizedBox(width: 30),
            Align(
              alignment: Alignment.bottomRight,
              child: createFloatingButton(),
            ),
            SizedBox(height: 10),
            SizedBox(width: double.infinity, child: BannerAD()),
          ],
        ),
      ),
    );
  }

  Widget createFloatingButton() {
    if (authController.userData?['isAdmin'] ?? false) {
      return Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {
            print('Click');
            Get.to(() => CreateNoticeScreen());
          },
          child: const Icon(
            Icons.add,
            size: 40,
            color: Colors.white60,
          ),
        ),
      );
    } else {
      // 어떤 위젯을 반환할지에 대한 처리 추가
      return Container(); // 예시로 빈 컨테이너를 반환하도록 수정
    }
  }

  Widget noticeStreenBuilder() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Text('공지사항 데이터를 가져오는 중 오류가 발생했습니다.');
          }

          final querySnapshot = snapshot.data;
          if (querySnapshot == null || querySnapshot.docs.isEmpty) {
            return const Text('공지사항이 없습니다.');
          }

          final announcementList = querySnapshot.docs
              .map((doc) => NoticeFirebaseModel.fromMap(
                  doc.data() as Map<String, dynamic>))
              .toList();
          announcementList
              .sort((a, b) => b.createdAt.compareTo(a.createdAt)); // 내림차순 정렬
          return SingleChildScrollView(
            child: buildCommentListView(announcementList),
          );
        },
      ),
    );
  }

  //공지사항 리스트뷰빌더로 구현
  Widget buildCommentListView(List<NoticeFirebaseModel> announcementList) {
    final now = DateTime.now();

    return Container(
      child: SizedBox(
        height: 200,
        width: double.infinity,
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
              leading: Icon(Icons.circle, size: 14, color: colors.iconColor),
              title: Text(
                "${comment.title} ($formattedDate)",
                maxLines: 1, // 최대 줄 수를 1로 설정
                overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)),
                style: TextStyle(color: colors.iconColor),
              ),
              subtitle: Text(
                comment.content,
                maxLines: 2, // 최대 줄 수를 1로 설정
                overflow: TextOverflow.ellipsis, // 오버플로우 처리 설정 (생략 부호 사용)
                style: TextStyle(color: colors.textColor),
              ),
              onTap: () {
                Get.to(() => DetailNoticeScreen(notice: comment));
              },
            );
          },
        ),
      ),
    );
  }
}
