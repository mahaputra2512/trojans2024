//login form
//not yet edited

import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:trojans/pages/dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    // Buat koneksi ke database MySQL
    var settings = new ConnectionSettings(
      host: 'localhost',
      port: 3306,
      user: 'trojans',
      password: 'password',
      db: 'users',
    );

    var conn = await MySqlConnection.connect(settings);

    // Buat query untuk mengambil data user
    try {
      var results = await conn.query(
        "SELECT * FROM users WHERE email = '?' AND password = '?'",
        [_usernameController.text, _passwordController.text],
      );

      if (results.isNotEmpty) {
        for (var row in results) {
          print('email: ${row[0]}, password: ${row[1]}');
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        // User tidak ditemukan, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Username atau password salah'),
          ),
        );
      }
    } on Exception catch (_) {
      // make it explicit that this function can throw exceptions
      rethrow;
    }

    // Tutup koneksi database
    await conn.close();

    // Cek hasil query

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: Text(_isLoading ? 'Loading...' : 'Login'),
            ),
          ],
        ),
      ),
    );
  }
}
