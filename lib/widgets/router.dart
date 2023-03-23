import 'package:flutter/material.dart';
import 'package:fluttertest/auth/login_screen.dart';
import 'package:fluttertest/auth/register_screen.dart';
import 'package:fluttertest/pages/chat_page.dart';
import 'package:fluttertest/pages/group_info.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/pages/profile_page.dart';
import 'package:fluttertest/pages/search_page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case RegisterPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      );
    case HomePage.routeName:
      return MaterialPageRoute(
        builder: (context) => const HomePage(),
      );
    case ProfilePage.routeName:
      return MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      );
    case SearchPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const SearchPage(),
      );
    // case ChatPage.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => const ChatPage(),
    //   );
    // case GroupInfo.routeName:
    //   return MaterialPageRoute(
    //     builder: (context) => GroupInfo(),
    //   );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text("error")),
        ),
      );
  }
}
