import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //Property
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ColorsCollection _colors = ColorsCollection();
  final AuthController _authController = AuthController.instance;
  final FontSizeCollection _fontSizeCollection = FontSizeCollection();
  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Change Password",
                style: TextStyle(
                    fontSize: _fontSizeCollection.subjectFontSize,
                    color: _colors.textColor),
              ).tr(),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          labelText: tr('Current Password'),
                          hintText: tr('Please write the Current Password'),
                          labelStyle: TextStyle(color: _colors.textColor),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr('Current Password is required');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _newPassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          icon: const Icon(Icons.title),
                          labelText: tr('New Password'),
                          hintText: tr('Please write the New Password'),
                          labelStyle: TextStyle(color: _colors.textColor),
                        ),
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return tr('New Password is required');
                          }
                          return null;
                        },
                      ),
                    ],
                  )),
              Expanded(child: Container()),
              ChangePasswordConfirmButton(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: BannerAD(),
      ),
    );
  }

  Widget ChangePasswordConfirmButton() {
    String email = _authController.userData!['email'];

    return Container(
      height: 40,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _authController.changePassword(
              email, _currentPassword.text, _newPassword.text);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(_colors.stateIsIng),
        ),
        child: Text(
          "Change Password Confirm",
          style: TextStyle(
            fontSize: _fontSizeCollection.buttonFontSize,
            color: _colors.iconColor,
          ),
        ).tr(),
      ),
    );
  }
}
