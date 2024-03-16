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
  bool _isProfileNameAvailable = false;
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
                    controller: _profileNameController,
                    colors: colors,
                    authController: _authController,
                    isProfileNameAvailable: _isProfileNameAvailable,
                    setIsProfileNameAvailable: (bool value) {
                      // 상태 변경 함수 추가
                      setState(() {
                        _isProfileNameAvailable = value;
                      });
                    },
                  ),
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
                    isProfileNameAvailable: _isProfileNameAvailable,
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

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final ColorsCollection colors;

  const PasswordInput(
      {super.key, required this.controller, required this.colors});

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

class ProfileNameInput extends StatefulWidget {
  final TextEditingController controller;
  final ColorsCollection colors;
  final AuthController authController; // AuthController 추가
  final bool isProfileNameAvailable;
  final Function(bool)
      setIsProfileNameAvailable; // setIsProfileNameAvailable 매개변수 추가

  const ProfileNameInput({
    Key? key,
    required this.controller,
    required this.colors,
    required this.authController,
    required this.isProfileNameAvailable,
    required this.setIsProfileNameAvailable, // 매개변수 추가
  }) : super(key: key); // key 매개변수 추가

  @override
  _ProfileNameInputState createState() => _ProfileNameInputState();
}

class _ProfileNameInputState extends State<ProfileNameInput> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              icon: const Icon(Icons.person),
              labelText: tr('Profile Name'),
              hintText: tr('Please enter ProfileName'),
              labelStyle: TextStyle(color: widget.colors.textColor),
            ),
            style: TextStyle(color: widget.colors.iconColor),
            validator: (value) {
              return null;
            },
          ),
        ),
        IconButton(
          onPressed: () async {
            // 프로필 이름 중복 확인
            final profileName = widget.controller.text;
            final isAvailable =
                await widget.authController.isProfileNameAvailable(profileName);
            widget.setIsProfileNameAvailable(
                isAvailable); // setIsProfileNameAvailable 함수 호출하여 상태 변경
          },
          icon: Row(
            // Using Row directly in the icon parameter
            children: [
              Icon(Icons.check),
              SizedBox(width: 8.0),
              Text(
                tr('Check Availability'), // 중복 확인을 나타내는 텍스트
                style: TextStyle(
                  color: widget.colors.textColor, // 텍스트 색상
                  fontSize: 14.0, // 텍스트 크기
                ),
              ),
            ],
          ),
          color: widget.isProfileNameAvailable ? Colors.green : Colors.red,
          tooltip: widget.isProfileNameAvailable
              ? tr('Available')
              : tr('Unavailable'), // 중복 확인을 나타내는 툴팁 추가
        ),
      ],
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
  final bool isProfileNameAvailable; // 프로필 이름 사용 가능 여부

  const SignUpButton({
    required this.onPressed,
    required this.colors,
    required this.fontsize,
    required this.isProfileNameAvailable,
  });

  @override
  Widget build(BuildContext context) {
    // 프로필 이름이 사용 가능하지 않은 경우 에러 메시지를 표시
    if (!isProfileNameAvailable) {
      return Text(
        tr("Please verify the availability of the profile name"), // 에러 메시지
        style: TextStyle(
          color: Colors.red, // 에러 메시지 색상
        ),
      );
    }
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
