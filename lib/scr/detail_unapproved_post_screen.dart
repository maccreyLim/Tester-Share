import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tester_share_app/model/board_firebase_model.dart';
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailUnapprovedPostScreen extends StatefulWidget {
  final BoardFirebaseModel boards;
  DetailUnapprovedPostScreen({Key? key, required this.boards})
      : super(key: key);

  @override
  State<DetailUnapprovedPostScreen> createState() =>
      _DetailUnapprovedPostScreenState();
}

class _DetailUnapprovedPostScreenState
    extends State<DetailUnapprovedPostScreen> {
  // List<BoardFirebaseModel> 대신 BoardFirebaseModel을 사용
  final ColorsCollection colors = ColorsCollection();

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
                Image.network(
                  widget.boards.iconImageUrl,
                  width: 120,
                  height: 120,
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
                  Text(
                    'Creation date: ${_formattedDate(widget.boards.createAt)}',
                    style: TextStyle(fontSize: 14, color: colors.textColor),
                  ),
                  if (widget.boards.updateAt != null)
                    Text(
                      'Modification date: ${_formattedDate(widget.boards.updateAt!)}',
                      style: TextStyle(fontSize: 14, color: colors.textColor),
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
                  ),
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
                                //Todo 메시지 보내기
                                print("Send the Message");
                              },
                              icon: Icon(Icons.message),
                            ),
                            Text(
                              "Send a message to the developer",
                              style: TextStyle(color: colors.importantMessage),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '-  Test App URL  -',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        final _url = Uri.tryParse(widget.boards.appSetupUrl);
                        if (_url != null) {
                          launchUrl(_url);
                        } else {
                          // Handle the case when the URL is invalid or null
                          print('Invalid URL: ${widget.boards.appSetupUrl}');
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
            const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '-  Supported Languages  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
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
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    color: colors.boxColor,
                    child: TextButton(
                      onPressed: () {
                        final url = Uri.tryParse(widget.boards.githubUrl);
                        if (url != null) {
                          launchUrl(url);
                        } else {
                          // Handle the case when the URL is invalid or null
                          print('Invalid URL: ${widget.boards.githubUrl}');
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:
                            colors.boxColor, // Set button color to black
                        elevation:
                            8, // Add some elevation for a raised appearance
                      ),
                      child: cardText(widget.boards.githubUrl, 20),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '-  App Image  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '-  Introduction  -',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
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
            SizedBox(height: 20),
            Divider(),
            SizedBox(height: 20),
            SizedBox(width: double.infinity, child: BannerAD()),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: widget.boards.isApproval
                      ? MaterialStateProperty.all<Color>(Colors.grey)
                      : MaterialStateProperty.all<Color>(Colors.red),
                ),
                onPressed: () {
                  InterstitialAd();
                  //Todo : firebase isApproval = true;
                  widget.boards.isApproval
                      ? updateBoard(widget.boards, false)
                      : updateBoard(widget.boards, true);
                  Get.back();
                },
                child: Text(
                  widget.boards.isApproval ? 'Unapproval' : 'Approval',
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
