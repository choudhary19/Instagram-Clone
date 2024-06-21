import 'package:flutter/material.dart';
import 'package:instagramclone/resources/auth_methods.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout_screen.dart';
import 'package:instagramclone/responsive/web_screen_layout.dart';
import 'package:instagramclone/screens/Sign_up.dart';
import 'package:instagramclone/utils/color.dart';
import 'package:instagramclone/utils/global_variable.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
              (route) => false,
        );

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss the keyboard when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
                  : const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 180),
                  Text(
                    '𝖎𝖓𝖘𝖙𝖆𝖌𝖗𝖆𝖒',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 64),
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    icon: Icons.email, // Add this line
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                    icon: Icons.lock, // Add this line
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), // Set a higher value for more rounded corners
                        color: blueColor,
                      ),
                      child: !_isLoading
                          ? const Text('Log in', style: TextStyle(color: Colors.white))
                          : const CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        ),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
