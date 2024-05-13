import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presence_app/pages/admin/add_employee_page.dart';
import 'package:presence_app/pages/admin/employee_detail_page.dart';
import 'package:presence_app/pages/main_pages.dart';
import 'package:presence_app/pages/presence_history_page.dart';
import 'package:presence_app/pages/presence_page.dart';
import 'package:presence_app/pages/setting_page.dart';

import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: MainPage.routeName,
      routes: {
        MainPage.routeName: (context) => const MainPage(),
        PresenceHistoryPage.routeName: (context) => const PresenceHistoryPage(),
        SettingPage.routeName: (context) => const SettingPage(),
        PresencePage.routeName: (context) => const PresencePage(),
        AddEmployeePage.routeName: (context) => const AddEmployeePage(),
        EmployeeDetailPage.routeName: (context) => const EmployeeDetailPage()
      },
      //home: const MainPage(),
    );
  }
}

