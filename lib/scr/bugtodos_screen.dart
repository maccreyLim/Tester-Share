import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/bugtodo_firebase_controller.dart';
import 'package:tester_share_app/model/bugtodo_firebase_model.dart';
import 'package:tester_share_app/scr/bugtodo_reply_message_Screen.dart';
import 'package:tester_share_app/scr/create_bugtodos_screen.dart';
import 'package:tester_share_app/scr/update_bugtodos_screen.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';
import 'package:tester_share_app/widget/w.interstitle_ad.dart';

class BugTodosScreen extends StatefulWidget {
  const BugTodosScreen({Key? key}) : super(key: key);

  @override
  State<BugTodosScreen> createState() => _BugTodosScreenState();
}

class _BugTodosScreenState extends State<BugTodosScreen> {
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController _authController = AuthController.instance;
  final BugTodoFirebaseController _bugTodoFirebaseController =
      BugTodoFirebaseController();
  final InterstitialAdController adController = InterstitialAdController();
  late String uid; // uid 변수를 선언

  @override
  void initState() {
    uid = _authController.userData!['uid']; // initState에서 uid를 초기화합니다.
    super.initState();
  }

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
      body: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
            height: 540,
            child: StreamBuilder<List<BugTodoFirebaseModel>>(
              stream: _bugTodoFirebaseController.getAllBugTodos(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  final todoData = snapshot.data ?? [];
                  print("snapshot.data : ${snapshot.data}"); // 데이터 확인
                  return ListView.builder(
                    itemCount: todoData.length,
                    itemBuilder: (context, index) {
                      final BugTodoFirebaseModel bugTodo = todoData[index];
                      return ExpansionTile(
                        title: Text(
                          bugTodo.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: bugTodo.isDone
                                ? const Color.fromARGB(255, 47, 47, 47)
                                : bugTodo.isDone
                                    ? Colors.grey
                                    : bugTodo.level == 1
                                        ? Colors.red
                                        : bugTodo.level == 2
                                            ? Colors.yellow
                                            : Colors.blue,
                          ),
                        ),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: bugTodo.isDone
                                ? Colors.grey
                                : bugTodo.level == 1
                                    ? Colors.red
                                    : bugTodo.level == 2
                                        ? Colors.yellow
                                        : bugTodo.level == 3
                                            ? Colors.blue
                                            : Colors.purpleAccent,
                          ),
                          child: Center(
                            child: Text(
                              bugTodo.isDone
                                  ? "Done"
                                  : bugTodo.level == 1
                                      ? "High"
                                      : bugTodo.level == 2
                                          ? "Middle"
                                          : bugTodo.level == 3
                                              ? "Low"
                                              : "Repot",
                              style: bugTodo.isDone
                                  ? const TextStyle(color: Colors.black)
                                  : const TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        trailing: IconButton(
                          icon: bugTodo.isDone
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                          onPressed: () {
                            _bugTodoFirebaseController.updateBugTodoIsDone(
                              uid,
                              bugTodo.docid.toString(),
                              !bugTodo.isDone,
                            );
                          },
                        ),
                        children: [
                          ListTile(
                            title: bugTodo.updateAt == null
                                ? Text(
                                    '${bugTodo.createAt.year}-${bugTodo.createAt.month}-${bugTodo.createAt.day} ${bugTodo.createAt.hour}:${bugTodo.createAt.minute}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: bugTodo.isDone
                                          ? const Color.fromARGB(
                                              255, 47, 47, 47)
                                          : colors.textColor,
                                    ),
                                  )
                                : Text(
                                    '${bugTodo.updateAt!.year}-${bugTodo.updateAt!.month}-${bugTodo.updateAt!.day} ${bugTodo.updateAt!.hour}:${bugTodo.updateAt!.minute}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: bugTodo.isDone
                                          ? const Color.fromARGB(
                                              255, 47, 47, 47)
                                          : colors.textColor,
                                    ),
                                  ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  bugTodo.contents,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: bugTodo.isDone
                                        ? const Color.fromARGB(255, 47, 47, 47)
                                        : colors.textColor,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                bugTodo.level == 4
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "The person who reported the bug",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: bugTodo.isDone
                                                  ? const Color.fromARGB(
                                                      255, 47, 47, 47)
                                                  : colors.textColor,
                                            ),
                                          ).tr(),
                                          TextButton(
                                              onPressed: () {
                                                //Todo: 버그리포팅한 사람에게 메시지 보내기

                                                Get.to(
                                                    BugtodoReplyMessageScreen(
                                                  receiverUid:
                                                      bugTodo.createUid,
                                                  senderUid: _authController
                                                      .userData!['uid'],
                                                  reportProfile: bugTodo
                                                      .reportprofileName
                                                      .toString(),
                                                ));
                                              },
                                              child: Row(
                                                children: [
                                                  Text(
                                                    " : ${bugTodo.reportprofileName}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: bugTodo.isDone
                                                          ? const Color
                                                              .fromARGB(
                                                              255, 47, 47, 47)
                                                          : colors.textColor,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  const Icon(
                                                    Icons.send,
                                                    color: Colors.blue,
                                                  )
                                                ],
                                              )),
                                        ],
                                      )
                                    : Container(),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        adController
                                            .loadAndShowAd(); //Todo :삭제로직 구현
                                        _bugTodoFirebaseController
                                            .deleteBugTodo(
                                                uid,
                                                bugTodo.projectName,
                                                bugTodo.docid.toString());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(120, 30), // 최소 너비와 높이 설정
                                        backgroundColor:
                                            Colors.red, // 버튼의 배경색 설정
                                      ),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(
                                            fontSize: _fontSizeCollection
                                                .buttonFontSize,
                                            color: Colors.white),
                                      ).tr(),
                                    ),
                                    const SizedBox(width: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        //Todo : 수정 구현
                                        Get.to(() => UpdateBugTodoScreen(
                                            bugTodo: bugTodo));

                                        print("수정버튼");
                                      },
                                      style: ElevatedButton.styleFrom(
                                        minimumSize:
                                            const Size(120, 30), // 최소 너비와 높이 설정
                                        backgroundColor:
                                            Colors.blue, // 버튼의 배경색 설정
                                      ),
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            fontSize: _fontSizeCollection
                                                .buttonFontSize,
                                            color: Colors.white),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                print("생성 버튼");
                Get.to(() => const CreateBugTodoScreen());
              },
              child: const Icon(Icons.add),
            ),
          )
        ],
      ),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
