import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/controller/auth_controller.dart';
import 'package:fluttertest/pages/home_page.dart';
import 'package:fluttertest/shared/constants.dart';
import 'package:fluttertest/widgets/router.dart';

import 'auth/login_screen.dart';
import 'commom/error.dart';
import 'commom/loader.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb || Platform.isWindows || Platform.isLinux) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId)); // For Web and desktop
  } else {
    await Firebase.initializeApp(); // android and ios
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: "Chat App",
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataProvider).when(
            data: (user) {
              if (user == null) {
                return const LoginPage();
              }
              return const HomePage();
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
