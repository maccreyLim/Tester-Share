import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/bugtodo_firebase_controller.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class CreateBugTodoScreen extends StatefulWidget {
  const CreateBugTodoScreen({Key? key});

  @override
  State<CreateBugTodoScreen> createState() => _CreateBugTodoScreenState();
}

class _CreateBugTodoScreenState extends State<CreateBugTodoScreen> {
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController authController = AuthController.instance;
  final BugTodoFirebaseController _bugTodoFirebaseController =
      BugTodoFirebaseController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contectsController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();

  late int level = 2;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    contectsController.dispose();
    projectNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    projectNameController.text = "BASIC Project";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드에 의해 화면 자동 조정 방지
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: projectNameController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.folder),
                          labelText: tr('Project Name'),
                          hintText: tr('Please write the Project Name'),
                          labelStyle: TextStyle(color: colors.textColor),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr('Project Name is required');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "P r i o r i t y",
                        style: TextStyle(
                            fontSize: _fontSizeCollection.buttonFontSize,
                            color: colors.textColor,
                            fontWeight: FontWeight.bold),
                      ).tr(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                level = 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(120, 30), // 최소 너비와 높이 설정
                                backgroundColor: level == 1
                                    ? Colors.red
                                    : Colors.grey // 버튼의 배경색 설정
                                ),
                            child: Text(
                              "High",
                              style: TextStyle(
                                  fontSize: _fontSizeCollection.buttonFontSize,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                level = 2;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize:
                                    const Size(120, 30), // 최소 너비와 높이 설정
                                backgroundColor: level == 2
                                    ? Colors.yellow
                                    : Colors.grey // 버튼의 배경색 설정
                                ),
                            child: Text(
                              "Middle",
                              style: TextStyle(
                                  fontSize: _fontSizeCollection.buttonFontSize,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                level = 3;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(120, 30), // 최소 너비와 높이 설정
                              backgroundColor: level == 3
                                  ? Colors.blue
                                  : Colors.grey, // 버튼의 배경색 설정
                            ),
                            child: Text(
                              "Low",
                              style: TextStyle(
                                  fontSize: _fontSizeCollection.buttonFontSize,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold),
                            ).tr(),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          labelText: tr('Title'),
                          hintText: tr('Please write the title'),
                          labelStyle: TextStyle(color: colors.textColor),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr('Title is required');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        maxLines: 5,
                        controller: contectsController,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.note_outlined),
                          labelText: tr('Content'),
                          hintText: tr('Please write the Contents'),
                          labelStyle: TextStyle(color: colors.textColor),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr('Content is required');
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 160,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        barrierDismissible:
                            false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
                      );
                      //Todo : 할일생성 구현
                      BugTodoFirebaseModel bugtodata = BugTodoFirebaseModel(
                          createUid: authController.userData!['uid'],
                          createAt: DateTime.now(),
                          title: titleController.text,
                          contents: contectsController.text,
                          projectName: projectNameController.text,
                          level: level,
                          isDone: false);
                      _bugTodoFirebaseController.createBugTodo(
                          authController.userData!['uid'],
                          projectNameController.text,
                          bugtodata);
                      Get.back();
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(320, 40), // 최소 너비와 높이 설정
                    backgroundColor: Colors.blue, // 버튼의 배경색 설정
                  ),
                  child: Text(
                    "Create Todo",
                    style: TextStyle(
                        fontSize: _fontSizeCollection.buttonFontSize,
                        color: Colors.white),
                  ).tr(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
