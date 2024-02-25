import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/message_firebase_controller.dart';
import 'package:tester_share_app/model/massage_firebase_model.dart';
import 'package:tester_share_app/scr/message_state_screen.dart';

class ReplayMessageCreateScreen extends StatefulWidget {
  final MessageModel message;

  ReplayMessageCreateScreen({required this.message});

  @override
  _ReplayMessageCreateScreenState createState() =>
      _ReplayMessageCreateScreenState();
}

class _ReplayMessageCreateScreenState extends State<ReplayMessageCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  MassageFirebaseController messageService = MassageFirebaseController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Replay Message'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '받을 사람 :  ${widget.message.senderNickname}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
                SizedBox(height: 30),
                Text(
                  '원본메시지',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                Divider(),
                SizedBox(height: 6),
                Text(
                  '${widget.message.contents}',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 60),
                TextFormField(
                  style: TextStyle(fontSize: 16),
                  cursorHeight: 20,
                  maxLines: 10,
                  maxLength: 100,
                  controller: messageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: "답장 내용",
                  ),
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "답장 내용을 입력해주세요";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      MessageModel replyMessage = MessageModel(
                        senderUid: widget.message.receiverUid,
                        receiverUid: widget.message.senderUid,
                        contents: messageController.text,
                        timestamp: DateTime.now(),
                      );
                      // MessageFirebase에서 답장 메시지 등록
                      MassageFirebaseController().createMessage(
                          replyMessage, widget.message.receiverNickname);
                      Get.off(MessageStateScreen());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 1,
                      48,
                    ),
                  ),
                  child: Text('답장 보내기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
