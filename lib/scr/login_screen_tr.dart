import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tester_share_app/controller/auth_controlloer.dart';
import 'package:tester_share_app/scr/find_password_secreen_tr.dart';
import 'package:tester_share_app/scr/join_screen_tr.dart';
import 'package:tester_share_app/widget/w.banner_ad.dart';
import 'package:tester_share_app/widget/w.colors_collection.dart';
import 'package:tester_share_app/widget/w.font_size_collection.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = AuthController();
  final ColorsCollection colors = ColorsCollection();
  final FontSizeCollection fontsize = FontSizeCollection();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 포커스를 다른 곳으로 이동하여 키보드를 내립니다.
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors.background,
        ),
        backgroundColor: colors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/images/TesterShare_Logo.png",
                      width: 120.0, // 원하는 너비로 설정
                      height: 120.0, // 원하는 높이로 설정
                      fit: BoxFit.cover, // 이미지가 컨테이너를 채우도록 설정
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const SizedBox(height: 50),
                  EmailInput(controller: _emailController, colors: colors),
                  const SizedBox(height: 20),
                  PasswordInput(
                      controller: _passwordController, colors: colors),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.search,
                        color: colors.textColor,
                      ),
                      TextButton(
                        onPressed: () {
                          //Todo: 파이어베이스 Password찾기 구현
                          Get.to(() => const FindPasswordScreen());
                        },
                        child: const Text(
                          'Find Your Password',
                          style: TextStyle(color: Colors.white54),
                        ).tr(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                  LogInButton(
                    onPressed: () async {
                      // 로그아웃 및 로그인 페이지로 이동
                      if (_formKey.currentState!.validate()) {
                        await _authController.signIn(
                          _emailController.text,
                          _passwordController.text,
                        );
                        print(_authController.userData);
                      }
                    },
                    colors: colors,
                    fontsize: fontsize,
                  ),
                  const SizedBox(height: 6),
                  CreateButton(
                    onPressed: () {
                      // 회원가입
                      Get.to(() => const JoinScreen());
                    },
                    colors: colors,
                    fontsize: fontsize,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: double.infinity,
          child: BannerAD(),
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const EmailInput({super.key, required this.controller, required this.colors});

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

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const PasswordInput(
      {Key? key, required this.controller, required this.colors})
      : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      obscureText: _obscureText,
      decoration: InputDecoration(
        icon: const Icon(Icons.key),
        labelText: tr('Password'),
        hintText: tr('Please enter your Password'),
        suffixIcon: Semantics(
          label:
              _obscureText ? tr('Show password') : tr('Covering the password'),
          child: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: widget.colors.textColor,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        labelStyle: TextStyle(color: widget.colors.textColor),
      ),
      style: TextStyle(color: widget.colors.iconColor),
      validator: (value) {
        return null;
      },
    );
  }
}

class LogInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ColorsCollection colors;
  final FontSizeCollection fontsize;

  const LogInButton(
      {super.key,
      required this.onPressed,
      required this.colors,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color?>(Colors.blue),
          ),
          onPressed: onPressed,
          child: Text(
            'LogIn',
            style: TextStyle(
              color: colors.iconColor,
              fontSize: fontsize.buttonFontSize,
            ),
          ).tr(),
        ));
  }
}

class CreateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final ColorsCollection colors;
  final FontSizeCollection fontsize;

  const CreateButton(
      {super.key,
      required this.onPressed,
      required this.colors,
      required this.fontsize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color?>(Colors.grey),
        ),
        onPressed: onPressed,
        child: Text(
          'Create an Account',
          style: TextStyle(
            color: colors.iconColor,
            fontSize: fontsize.buttonFontSize,
          ),
        ).tr(),
      ),
    );
  }
}
