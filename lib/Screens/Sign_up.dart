import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/resources/auth_methods.dart';
import 'package:instagramclone/responsive/mobile_screen_layout.dart';
import 'package:instagramclone/responsive/responsive_layout_screen.dart';
import 'package:instagramclone/responsive/web_screen_layout.dart';
import 'package:instagramclone/screens/login_screen.dart';
import 'package:instagramclone/utils/color.dart';
import 'package:instagramclone/utils/utils.dart';
import 'package:instagramclone/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void signUpUser() async {
    // Validate if all fields are filled
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _bioController.text.isEmpty ||
        _image == null) {
      showSnackBar(context, 'Please fill all fields and select an image.');
      return;
    }

    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethods
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    // if string returned is success, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });

      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });

      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Ensure keyboard is dismissed when tapping outside of text fields
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  SvgPicture.asset(
                    'assets/ic_instagram.svg',
                    color: primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 32),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                        backgroundColor: Colors.red,
                      )
                          : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://i.stack.imgur.com/l60Hf.png'),
                        backgroundColor: Colors.red,
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    hintText: 'Enter your username',
                    textInputType: TextInputType.text,
                    textEditingController: _usernameController,
                    icon: Icons.person, // Add this line
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    icon: Icons.email, // Add this line
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    isPass: true,
                    icon: Icons.lock, // Add this line
                  ),
                  const SizedBox(height: 16),
                  TextFieldInput(
                    hintText: 'Enter your bio',
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                    icon: Icons.info, // Add this line
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100), // Set a higher value for more rounded corners
                        color: blueColor,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: primaryColor,
                      )
                          : const Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 70),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: const Text(
                          ' Login.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
