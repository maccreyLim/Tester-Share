import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/bugtodo_firebase_controller.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class UpdateBugTodoScreen extends StatefulWidget {
  final BugTodoFirebaseModel bugTodo;

  const UpdateBugTodoScreen({Key? key, required this.bugTodo})
      : super(key: key);

  @override
  State<UpdateBugTodoScreen> createState() => _EditBugTodoScreenState();
}

class _EditBugTodoScreenState extends State<UpdateBugTodoScreen> {
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController authController = AuthController.instance;
  final BugTodoFirebaseController _bugTodoFirebaseController =
      BugTodoFirebaseController();
  final InterstitialAdController adController = InterstitialAdController();
  TextEditingController titleController = TextEditingController();
  TextEditingController contectsController = TextEditingController();
  TextEditingController projectNameController = TextEditingController();

  late int level;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.bugTodo.title;
    contectsController.text = widget.bugTodo.contents;
    projectNameController.text = widget.bugTodo.projectName;
    level = widget.bugTodo.level;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 키보드에 의해 화면 자동 조정 방지
      backgroundColor: colors.background,
      appBar: AppBar(
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
                                minimumSize: const Size(60, 30), // 최소 너비와 높이 설정
                                backgroundColor: level == 1
                                    ? Colors.red
                                    : Colors.grey // 버튼의 배경색 설정
                                ),
                            child: const Text(
                              "High",
                              style: TextStyle(
                                  fontSize: 12,
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
                                minimumSize: const Size(60, 30), // 최소 너비와 높이 설정
                                backgroundColor: level == 2
                                    ? Colors.yellow
                                    : Colors.grey // 버튼의 배경색 설정
                                ),
                            child: const Text(
                              "Middle",
                              style: TextStyle(
                                  fontSize: 12,
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
                              minimumSize: const Size(60, 30), // 최소 너비와 높이 설정
                              backgroundColor: level == 3
                                  ? Colors.blue
                                  : Colors.grey, // 버튼의 배경색 설정
                            ),
                            child: const Text(
                              "Low",
                              style: TextStyle(
                                  fontSize: 12,
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
                      adController.loadAndShowAd();
                      Get.dialog(
                        const Center(
                          child: CircularProgressIndicator(),
                        ),
                        barrierDismissible:
                            false, // 사용자가 다이얼로그 외부를 탭하여 닫을 수 없도록 설정
                      );
                      // Update Bug Todo
                      BugTodoFirebaseModel updatedBugTodo =
                          BugTodoFirebaseModel(
                        docid: widget.bugTodo.docid,
                        createUid: authController.userData!['uid'],
                        projectName: projectNameController.text,
                        createAt: widget.bugTodo.createAt,
                        updateAt: DateTime.now(),
                        title: titleController.text,
                        contents: contectsController.text,
                        isDone: widget.bugTodo.isDone,
                        level: level,
                      );
                      _bugTodoFirebaseController.updateBugTodo(
                          authController.userData!['uid'],
                          projectNameController.text,
                          widget.bugTodo.docid.toString(),
                          updatedBugTodo);
                      Get.back();
                    }
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(320, 40), // 최소 너비와 높이 설정
                    backgroundColor: Colors.blue, // 버튼의 배경색 설정
                  ),
                  child: Text(
                    "Update Todo",
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
