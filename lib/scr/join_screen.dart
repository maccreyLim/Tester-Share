import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class JoinScreen extends StatefulWidget {
  const JoinScreen({Key? key}) : super(key: key);

  @override
  JoinScreenState createState() => JoinScreenState();
}

class JoinScreenState extends State<JoinScreen> {
  bool signUpSuccess = false;
  final AuthController _authController = AuthController.instance;
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection fontsize = FontSizeCollection();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _deployedController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _profileNameController.dispose();
    _deployedController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colors.background,
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: colors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const SizedBox(height: 80),
                  EmailInput(controller: _emailController, colors: colors),
                  const SizedBox(height: 20),
                  PasswordInput(
                      controller: _passwordController, colors: colors),
                  const SizedBox(height: 20),
                  ProfileNameInput(
                      controller: _profileNameController, colors: colors),
                  const SizedBox(height: 20),
                  DeployedInput(
                      controller: _deployedController, colors: colors),
                  const SizedBox(height: 200),
                  SignUpButton(
                    onPressed: () async {
                      try {
                        // 유효성 검사를 수행합니다.
                        if (_formKey.currentState!.validate()) {
                          // FirebaseAuth를 사용하여 사용자 등록
                          await _authController.signUp(
                            _emailController.text,
                            _passwordController.text,
                            _profileNameController.text,
                            int.parse(_deployedController.text),
                          );
                        }
                      } catch (e) {
                        // 앱 출시 횟수를 정수로 변환할 때 오류가 발생하면 처리
                        // 예: 올바른 형식의 숫자를 입력하도록 사용자에게 메시지 표시
                        print(
                            'Please enter the app launch count in the correct format');
                      }
                    },
                    colors: colors,
                    fontsize: fontsize,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const EmailInput({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        icon: const Icon(Icons.email),
        labelText: tr('Google Play Store ID'),
        hintText: tr('Please enter your Google Play Store ID'),
        labelStyle: TextStyle(color: colors.textColor),
      ),
      style: TextStyle(color: colors.iconColor),
      validator: (value) {
        return null;
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const PasswordInput({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      obscureText: true,
      decoration: InputDecoration(
        icon: const Icon(Icons.password),
        labelText: tr('Password'),
        hintText: tr('Please enter your Password'),
        labelStyle: TextStyle(color: colors.textColor),
      ),
      style: TextStyle(color: colors.iconColor),
      validator: (value) {
        return null;
      },
    );
  }
}

class ProfileNameInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const ProfileNameInput({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        icon: const Icon(Icons.password),
        labelText: tr('Profile Name'),
        hintText: tr('Please enter ProfileName'),
        labelStyle: TextStyle(color: colors.textColor),
      ),
      style: TextStyle(color: colors.iconColor),
      validator: (value) {
        return null;
      },
    );
  }
}

class DeployedInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const DeployedInput({required this.controller, required this.colors});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        icon: const Icon(Icons.password),
        labelText: tr('Number of App Launch Experiences'),
        hintText:
            tr('Please enter the number of experiences when launching the app'),
        labelStyle: TextStyle(color: colors.textColor),
      ),
      style: TextStyle(color: colors.iconColor),
      validator: (value) {
        return null;
      },
    );
  }
}

class SignUpButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ColorsCollection colors;
  final FontSizeCollection fontsize;

  const SignUpButton(
      {required this.onPressed, required this.colors, required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color?>(Colors.blue),
        ),
        onPressed: onPressed,
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: colors.iconColor,
            fontSize: fontsize.buttonFontSize,
          ),
        ).tr(),
      ),
    );
  }
}
