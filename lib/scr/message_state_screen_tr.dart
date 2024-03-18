import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/scr/received_message_screen_tr.dart'
    as ReceivedScreen;
import 'package:tester_share_app/scr/send_Message_screen_tr.dart' as SendScreen;
import 'package:tester_share_app/scr/massage_create_screen_tr.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class MessageStateScreen extends StatefulWidget {
  const MessageStateScreen({super.key});

  @override
  State<MessageStateScreen> createState() => _MessageStateScreenState();
}

class _MessageStateScreenState extends State<MessageStateScreen> {
  //Property
  ColorsCollection _colors = ColorsCollection();
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    ReceivedScreen.ReceivedMessageScreen(), // 받은 쪽지함 화면
    SendScreen.SendMessageScreen(), // 보낸 쪽지함 화면
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _colors.background,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mail,
                color: _selectedIndex == 0 ? Colors.blue : _colors.iconColor),
            label: tr("Received Messages"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send,
                color: _selectedIndex == 1 ? Colors.blue : _colors.iconColor),
            label: tr("Sent Messages"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue, // 선택된 아이템의 색상
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(MessageCreateScreen());
        },
      ),
    );
  }
}
