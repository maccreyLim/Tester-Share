import 'package:flutter/material.dart';

class LanguageSelectionWidget extends StatefulWidget {
  const LanguageSelectionWidget({super.key});

  @override
  LanguageSelectionWidgetState createState() => LanguageSelectionWidgetState();
}

class LanguageSelectionWidgetState extends State<LanguageSelectionWidget> {
  List<String> availableLanguages = [
    "English",
    "Spanish",
    "French",
    "German",
    "Chinese",
    "Japanese"
  ];

  List<String> selectedLanguages = [];

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text("Choose Language"),
      children: [
        Column(
          children: availableLanguages.map((language) {
            bool isSelected = selectedLanguages.contains(language);
            return CheckboxListTile(
              title: Text(language),
              value: isSelected,
              onChanged: (value) {
                setState(() {
                  if (value!) {
                    selectedLanguages.add(language);
                  } else {
                    selectedLanguages.remove(language);
                  }
                });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            );
          }).toList(),
        ),
      ],
    );
  }
}
