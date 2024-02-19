import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/notice_controller.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/model/notice_firebase_model.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.show_toast.dart';

class CreateNoticeScreen extends StatefulWidget {
  const CreateNoticeScreen({super.key});

  @override
  State<CreateNoticeScreen> createState() => _CreateNoticeScreenState();
}

class _CreateNoticeScreenState extends State<CreateNoticeScreen> {
  //Property
  final _formkey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();

  TextEditingController contentsController = TextEditingController();

  final ColorsCollection _colors = ColorsCollection();

  final AuthController _authController = AuthController.instance;

  final FontSizeCollection _fontSizeCollection = FontSizeCollection();

  //TextEditingController dispose
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
      body: Column(
        children: [
          Align(alignment: Alignment.bottomCenter, child: inputForm())
        ],
      ),
    );
  }

  Widget saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
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
            inputText(titleController, "제목", 1, 60),
            SizedBox(
              height: 50,
            ),
            inputText(contentsController, "내용", 16, 420),
            SizedBox(height: 100),
            SizedBox(height: 40, width: double.infinity, child: saveButton()),
          ],
        ),
      ),
    );
  }

  //입력폼( 컨트롤러 , 텍스트필트 이름,텍스트필드 라인수)
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
        SizedBox(
          width: 20,
        ),
        SizedBox(
          height: intheight,
          width: 300,
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            controller: name,
            style: TextStyle(
              color: Colors.white, // 입력된 텍스트의 색상을 흰색으로 변경
            ),
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
}
