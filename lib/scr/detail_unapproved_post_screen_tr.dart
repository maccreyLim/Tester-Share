import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/developer_message_create_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

import 'package:url_launcher/url_launcher.dart';

class DetailUnapprovedPostScreen extends StatefulWidget {
  final BoardFirebaseModel boards;
  const DetailUnapprovedPostScreen({Key? key, required this.boards})
      : super(key: key);

  @override
  State<DetailUnapprovedPostScreen> createState() =>
      _DetailUnapprovedPostScreenState();
}

class _DetailUnapprovedPostScreenState
    extends State<DetailUnapprovedPostScreen> {
  // List<BoardFirebaseModel> 대신 BoardFirebaseModel을 사용
  final ColorsCollection colors = ColorsCollection();
  final InterstitialAdController adController = InterstitialAdController();

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
        child: ListView(
          children: [
            Row(
              children: [
                widget.boards.iconImageUrl == ""
                    ? Image.asset(
                        "assets/images/no-image.png",
                        width: 80,
                        height: 80,
                      )
                    : Image.network(
                        widget.boards.iconImageUrl,
                        width: 80,
                        height: 80,
                      ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cardText(widget.boards.title, 20),
                    cardText(
                        '[${widget.boards.testerRequest}/${widget.boards.testerParticipation}]',
                        16),
                    const SizedBox(height: 10),
                  ],
                ),
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
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ).tr(),
                      Text(
                        ': ${_formattedDate(widget.boards.createAt)}',
                        style: TextStyle(fontSize: 14, color: colors.textColor),
                      ),
                    ],
                  ),
                  if (widget.boards.updateAt != null)
                    Row(
                      children: [
                        Text(
                          'Modification date',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ).tr(),
                        Text(
                          ': ${_formattedDate(widget.boards.updateAt!)}',
                          style:
                              TextStyle(fontSize: 14, color: colors.textColor),
                        ),
                      ],
                    )
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const Text(
                    '-  Developer  -',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        cardText(widget.boards.developer, 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                // 메시지 보내기 기능 추가
                                Get.to(DeveloperMessageCreateScreen(
                                    receiverUid: widget.boards.createUid,
                                    developer: widget.boards.developer,
                                    boards: widget.boards,
                                    func: false));
                              },
                              icon: Icon(Icons.message),
                            ),
                            Text(
                              "Send a message",
                              style: TextStyle(color: colors.importantMessage),
                            ).tr(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '-  Test App URL  -',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ).tr(),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        try {
                          final inputUrl = widget.boards.appSetupUrl;

                          // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                          final hasProtocol = inputUrl.startsWith('http://') ||
                              inputUrl.startsWith('https://');

                          // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                          final urlWithProtocol =
                              hasProtocol ? inputUrl : 'https://$inputUrl';

                          // URL을 Uri 객체로 변환
                          final _url = Uri.parse(urlWithProtocol);

                          // 생성된 Uri를 사용하여 브라우저 열기
                          launchUrl(_url);
                        } catch (e) {
                          // URL이 유효하지 않거나 열 수 없는 경우 처리
                          print('URL 열기 오류: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.boxColor,

                        elevation:
                            8, // Add some elevation for a raised appearance
                      ),
                      child: cardText(widget.boards.appSetupUrl, 20),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '-  Supported Languages  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                const SizedBox(height: 20),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                color: colors.boxColor,
                width: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.boards.language!.length,
                  itemBuilder: (context, index) => Container(
                    margin: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.task_alt,
                          color: colors.iconColor,
                          size: 20,
                        ),
                        const SizedBox(width: 20),
                        cardText(
                          widget.boards.language![index],
                          20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const Text(
                  '-  Github URL  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: widget.boards.githubUrl != null
                          ? () {
                              try {
                                final inputUrl = widget.boards.githubUrl!;

                                // 입력된 URL이 이미 'http://' 또는 'https://'로 시작하는지 확인
                                final hasProtocol =
                                    inputUrl.startsWith('http://') ||
                                        inputUrl.startsWith('https://');

                                // 프로토콜이 없는 경우 'https://'를 추가하여 안전하게 URL 생성
                                final urlWithProtocol = hasProtocol
                                    ? inputUrl
                                    : 'https://$inputUrl';

                                // URL을 Uri 객체로 변환
                                final url = Uri.parse(urlWithProtocol);

                                // 생성된 Uri를 사용하여 브라우저 열기
                                launchUrl(url);
                              } catch (e) {
                                // URL이 유효하지 않거나 열 수 없는 경우 처리
                                print('URL 열기 오류: $e');
                              }
                            }
                          : null,
                      style: TextButton.styleFrom(
                        backgroundColor: colors.boxColor,
                        elevation: 8,
                      ),
                      child: cardText(widget.boards.githubUrl ?? '', 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  App Image  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 300,
                width: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.boards.appImagesUrl.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(widget.boards.appImagesUrl[index],
                          width: 150, height: 300, fit: BoxFit.fill),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '-  Introduction  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ).tr(),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                  color: colors.boxColor,
                  child: cardText(widget.boards.introductionText, 16)),
            ),
            const SizedBox(height: 50),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: BannerAD()),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: widget.boards.isApproval
                      ? WidgetStateProperty.all<Color>(Colors.grey)
                      : WidgetStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  adController.loadAndShowAd();
                  //Todo : firebase isApproval = true;
                  widget.boards.isApproval
                      ? updateBoard(widget.boards, false)
                      : updateBoard(widget.boards, true);
                  Get.back();
                },
                child: Text(
                  widget.boards.isApproval ? tr("Unapporoal") : tr('Approval'),
                  style: TextStyle(fontSize: 20, color: colors.iconColor),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget cardText(String text, double size) {
    return Text(
      text,
      style: TextStyle(color: colors.textColor, fontSize: size),
    );
  }

  // DateFormat 함수 추가
  String _formattedDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
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
