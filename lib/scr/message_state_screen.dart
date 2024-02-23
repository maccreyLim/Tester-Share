import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/received_screen.dart' as ReceivedScreen;
import 'package:tester_share_app/scr/send_screen.dart' as SendScreen;
import 'package:tester_share_app/scr/home_screen.dart';
import 'package:tester_share_app/scr/massage_create_screen.dart';

class MessageStateScreen extends StatefulWidget {
  const MessageStateScreen({super.key});

  @override
  State<MessageStateScreen> createState() => _MessageStateScreenState();
}

class _MessageStateScreenState extends State<MessageStateScreen> {
  //Property
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    ReceivedScreen.ReceivedScreen(), // 받은 쪽지함 화면
    SendScreen.SendScreen(), // 보낸 쪽지함 화면
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 이 속성을 false로 설정하면 뒤로가기 버튼이 제거됩니다
        title: const Text('쪽지함'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(HomeScreen());
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: '받은 쪽지함',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: '보낸 쪽지함',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 선택된 아이템의 색상
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(MessageCreateScrren());
        },
      ),
    ));
  }
}
