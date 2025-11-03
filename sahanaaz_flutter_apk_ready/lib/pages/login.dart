import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sahanaaz_enterprises/models/app_state.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  String error = '';

  void _login() {
    if (_email.text=='admin@example.com' && _password.text=='admin123') {
      Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      setState((){ error='Invalid credentials. Use admin@example.com / admin123'; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal:24),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('Sahanaaz Enterprises', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
              SizedBox(height:8),
              TextField(controller: _email, decoration: InputDecoration(labelText: 'Email')),
              TextField(controller: _password, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
              SizedBox(height:12),
              ElevatedButton(onPressed: _login, child: Text('Login')),
              if (error.isNotEmpty) Padding(padding:EdgeInsets.only(top:8), child: Text(error, style: TextStyle(color:Colors.red))),
            ]),
          ),
        ),
      ),
    );
  }
}
