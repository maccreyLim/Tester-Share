import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/notice_controller.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class UpdateNoticeScreen extends StatefulWidget {
  final NoticeFirebaseModel notice; // 수정할 게시물 데이터를 받아올 변수

  const UpdateNoticeScreen({required this.notice, Key? key}) : super(key: key);

  @override
  State<UpdateNoticeScreen> createState() => _UpdateNoticeScreenState();
}

class _UpdateNoticeScreenState extends State<UpdateNoticeScreen> {
  // Property
  final _formkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentsController = TextEditingController();
  final ColorsCollection _colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();

  @override
  void initState() {
    super.initState();
    // 기존 게시물 데이터로 초기화
    titleController.text = widget.notice.title;
    contentsController.text = widget.notice.content;
  }

  // TextEditingController dispose
  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _colors.background,
      appBar: AppBar(
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
      body: Column(
        children: [
          Align(alignment: Alignment.bottomCenter, child: inputForm())
        ],
      ),
    );
  }

  Widget updateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
        ),
        onPressed: () async {
          if (_formkey.currentState!.validate()) {
            // 폼 검증 성공 시 업데이트 수행
            NoticeFirebaseModel updatedNotice = NoticeFirebaseModel(
              uid: widget.notice.uid,
              profileName: widget.notice.profileName,
              isLiked: widget.notice.isLiked,
              likeCount: widget.notice.likeCount,
              title: titleController.text,
              content: contentsController.text,
              createdAt: widget.notice.createdAt,
              id: widget.notice.id,
            );

            await NoticeController().updateNotice(updatedNotice);

            showToast(tr("The post has been successfully updated"), 1);
            Get.back(); // 화면 닫기
            Get.back();
          }
        },
        child: Text(
          'UPDATE',
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              color: _colors.iconColor),
        ),
      ),
    );
  }

  Widget inputForm() {
    return Form(
      key: _formkey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            inputText(titleController, tr("Title"), 1, 60),
            SizedBox(
              height: 50,
            ),
            inputText(contentsController, tr("Content"), 16, 420),
            SizedBox(height: 100),
            SizedBox(height: 50, width: double.infinity, child: updateButton()),
          ],
        ),
      ),
    );
  }

  // 입력폼(컨트롤러, 텍스트필드 이름, 텍스트필드 라인수)
  Widget inputText(
      TextEditingController name, String nametext, int line, double intheight) {
    return Row(
      children: [
        Text(
          nametext,
          style: TextStyle(
              fontSize: _fontSizeCollection.buttonFontSize,
              color: _colors.iconColor),
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          height: intheight,
          width: 300,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: name,
            style: const TextStyle(
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              hintText: "",
            ),
            keyboardType: TextInputType.multiline,
            maxLines: line,
            validator: (value) {
              if (value!.isEmpty) {
                return tr("Please enter $nametext");
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
