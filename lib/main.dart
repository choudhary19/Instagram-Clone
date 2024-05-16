import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Responsive/Responsive_layout_screen.dart';
import 'package:instagramclone/Responsive/mobile_screen_layout.dart';
import 'package:instagramclone/Responsive/web_screen_layout.dart';
import 'package:instagramclone/utils/color.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print("FireBase Added");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      title: 'Instagram Clone',
      home: const ResponsiveLayout(mobileScreenLayout: MobileScreenLayout(),webScreenLayout : WebScreenLayout(),),
    );
  }
}