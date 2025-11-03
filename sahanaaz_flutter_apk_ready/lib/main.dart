import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/db.dart';
import 'package:sahanaaz_enterprises/pages/dashboard.dart';
import 'package:sahanaaz_enterprises/pages/login.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await AppDatabase.init();
  runApp(MyApp(db: db));
}

class MyApp extends StatelessWidget {
  final AppDatabase db;
  MyApp({required this.db});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(db),
      child: MaterialApp(
        title: 'Sahanaaz Enterprises',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
        routes: {
          '/dashboard': (_) => DashboardPage(),
        },
      ),
    );
  }
}
