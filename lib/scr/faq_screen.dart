import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final ColorsCollection colors = ColorsCollection();

  final List<Map<String, String>> qaData = [
    {
      'question': tr("What does Tester Share do?"),
      'answer': tr(
          "After November 13, 2023, if you create a new developer account, you will need more than 20 testers to participate in private testing for 14 days in order to register a new app on Google Play.\nAs a result, new developers are facing a difficult situation of recruiting 20 testers for two weeks.\nIn response to this, developers have deployed Tester Share, where they form mutually secure relationships and become testers for each other to help and receive help.\nThrough this method, developers collaborate to test each other's apps with the aim of fulfilling the mandatory requirements for publishing apps on Google Play.")
    },
    {
      'question':
          tr("What are the app testing requirements for developer accounts?"),
      'answer': tr(
          "After November 13, 2023, new registrants to Google Console must meet specific testing requirements for 20 testers over a two-week period in order to publish an app on Google Play.\nIt's important to note that for each new app registration, testers must be recruited to meet these requirements.")
    },
    {
      'question':
          tr("I have met the app tester requirements. What should I do next?"),
      'answer': tr(
          "If you have met the app tester requirements, you can proceed with options such as production (Release > Production), or pre-registration (Release > Testing > Pre-registration).")
    },
    {
      'question': tr("What is internal testing?"),
      'answer': tr(
          "Before completing app setup, you can quickly deploy builds to a trusted small-scale tester group. This allows you to identify issues and receive feedback early.\nBuilds added to Play Console are typically provided to testers within seconds.\nInternal testing is optional, but it's a good practice to start with internal testing.")
    },
    // 다른 질문과 답변들을 여기에 추가할 수 있습니다.
  ];

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
      body: ListView.builder(
        itemCount: qaData.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
              qaData[index]['question']!,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  qaData[index]['answer']!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: colors.iconColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
