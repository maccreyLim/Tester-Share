import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/board_firebase_controller.dart';
import 'package:tester_share_app/controller/multi_image_firebase_controller.dart';
import 'package:tester_share_app/controller/single_image_firebase_controller.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/detail_unapproved_post_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class UnapprovedPostScreen extends StatefulWidget {
  UnapprovedPostScreen({super.key});

  @override
  State<UnapprovedPostScreen> createState() => _UnapprovedPostScreenState();
}

class _UnapprovedPostScreenState extends State<UnapprovedPostScreen> {
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _font = FontSizeCollection();
  final BoardFirebaseController _board = BoardFirebaseController();
  final InterstitialAdController adController = InterstitialAdController();
  final MultiImageFirebaseController _multiImageFirebaseController =
      MultiImageFirebaseController();
  final SingleImageFirebaseController _singleImageFirebaseController =
      SingleImageFirebaseController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "Unapproved post",
              style: TextStyle(color: _colors.textColor, fontSize: 16),
            ).tr(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: _colors.background,
          actions: [
            IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.close,
                color: _colors.iconColor,
              ),
            )
          ],
        ),
        backgroundColor: _colors.background,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<BoardFirebaseModel>>(
            stream: _board.boardStream(),
            builder:
                (context, AsyncSnapshot<List<BoardFirebaseModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                print('Data from Firestore: ${snapshot.data}');
                return Center(
                  child: Text(
                    "The post does not exist",
                    style: TextStyle(color: _colors.textColor, fontSize: 22),
                  ).tr(),
                );
              }

              List<BoardFirebaseModel> boards = snapshot.data!;
              boards.sort((a, b) {
                if (a.testerRequest > a.testerParticipation &&
                    b.testerRequest <= b.testerParticipation) {
                  return -1; // a를 b보다 앞으로 배치
                } else if (a.testerRequest <= a.testerParticipation &&
                    b.testerRequest > b.testerParticipation) {
                  return 1; // b를 a보다 앞으로 배치
                } else {
                  // testerRequest와 testerParticipation이 같거나 모두 크거나 작을 경우 createAt으로 비교
                  return b.createAt.compareTo(a.createAt);
                }
              });

              return ListView.builder(
                itemCount: boards.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(() =>
                          DetailUnapprovedPostScreen(boards: boards[index]));
                    },
                    child: Card(
                      color: _colors.cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  boards[index].iconImageUrl,
                                  width: 80,
                                  height: 80,
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    cardText(boards[index].title, 20),
                                    const SizedBox(width: 10),
                                    cardText(
                                        '[${boards[index].testerParticipation}/${boards[index].testerRequest}]',
                                        20),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Creation date',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _colors.textColor),
                                      ).tr(),
                                      Text(
                                        ': ${_formattedDate(boards[index].createAt)}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: _colors.textColor),
                                      ),
                                    ],
                                  ),
                                  if (boards[index].updateAt != null)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Modification date',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: _colors.textColor),
                                        ).tr(),
                                        Text(
                                          ': ${_formattedDate(boards[index].updateAt!)}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: _colors.textColor),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),
                            Text(boards[index].introductionText,
                                overflow:
                                    TextOverflow.ellipsis, // 초과되면 생략 부호 표시
                                maxLines: 1,
                                style: TextStyle(
                                    color: _colors.textColor,
                                    fontSize: 20)), // 표시할 최대 라인 수),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 120,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      // 버튼의 배경색을 상태에 따라 동적으로 변경하는 설정입니다.
                                      backgroundColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                          // "진행중" 상태에 따라 배경색을 설정합니다.
                                          if (boards[index].isApproval) {
                                            return _colors
                                                .stateIsIng; // 상태가 "진행중"일 때의 배경색
                                          } else {
                                            // 다른 상태에는 기본 배경색을 설정합니다.
                                            return _colors.stateIsClose;
                                          }
                                        },
                                      ),
                                    ),
                                    onPressed: () {
                                      adController.loadAndShowAd();
                                      //Todo : firebase isApproval = true;
                                      boards[index].isApproval
                                          ? updateBoard(boards[index], false)
                                          : updateBoard(boards[index], true);
                                      //testerParticipation의 값을 하나 증가시킴

                                      setState(() {});
                                    },
                                    child: Text(
                                      boards[index].isApproval
                                          ? tr('Approval')
                                          : tr("Disapproval"),
                                      style: TextStyle(
                                          color: _colors.iconColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ).tr(),
                                  ),
                                ),
                                cardText(
                                    'Developer: ${boards[index].developer}',
                                    14),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 4),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: 220,
                                    height: 26,
                                    child: !(boards[index].isApproval)
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.red),
                                            ),
                                            onPressed: () async {
                                              //리워드광고
                                              adController.loadAndShowAd();
                                              // Multi image 삭제
                                              await _multiImageFirebaseController
                                                  .deleteImagesUrlFromStorage(
                                                      boards[index]
                                                          .appImagesUrl);
                                              print(
                                                  "멀티이미지가 삭제되었습니다.\n${boards[index].appImagesUrl}");
                                              // Single image 삭제
                                              await _singleImageFirebaseController
                                                  .deleteImageUrl(boards[index]
                                                      .iconImageUrl);
                                              print(
                                                  "싱글이미지가 삭제되었습니다.\n${boards[index].iconImageUrl}");
                                              // 삭제 구현
                                              _board.deleteBoard(
                                                  boards[index].docid);
                                              print(
                                                  "게시판데이타가 삭제되었습니다.\n${boards[index].docid}");
                                            },
                                            child: Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: _colors.iconColor,
                                                fontSize: _font.buttonFontSize,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ).tr(),
                                          )
                                        : Text(
                                            "Inapproved projects cannot be deleted or modified",
                                            style: TextStyle(
                                                color: _colors.textColor,
                                                fontSize: 10),
                                          ).tr(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: BannerAD(),
        ));
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: _colors.textColor, fontSize: size),
    );
  }

  Future<void> updateBoard(BoardFirebaseModel board, bool isApproval) async {
    try {
      await FirebaseFirestore.instance
          .collection('boards')
          .doc(board.docid)
          .update({'isApproval': isApproval});
    } catch (e) {
      print('Error updating board: $e');
    }
  }
}
