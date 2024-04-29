import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/controller/bugtodo_firebase_controller.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class BugTodosScreen extends StatelessWidget {
  BugTodosScreen({Key? key}) : super(key: key);
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final AuthController _authController = AuthController.instance;
  final BugTodoFirebaseController _bugTodoFirebaseController =
      BugTodoFirebaseController();

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
      body: Column(children: [
        const SizedBox(height: 20),
        Container(
          height: 550,
          child: StreamBuilder<List<String>>(
            stream: _bugTodoFirebaseController
                .getProjectCollections(_authController.userData!['uid']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final projectNames = snapshot.data ?? [];
                print("projectNames : $snapshot.data");
                return ListView.builder(
                  itemCount: projectNames.length,
                  itemBuilder: (context, index) {
                    final projectName = projectNames[index];
                    return ListTile(
                      title: Text(
                        projectName,
                        style: TextStyle(color: Colors.red),
                      ),
                      subtitle: _authController.userData!['uid'],
                      onTap: () {
                        // 선택한 프로젝트에 대한 작업 실행
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        // const SizedBox(height: 10),
        Text(_authController.userData!['uid']),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () {
              // 테스터 쉐어 추가
              // Get.to(() => const CreateBoardScreen());
            },
            child: const Icon(Icons.add),
          ),
        )
      ]),
      floatingActionButton: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }
}
