//login form
//not yet edited

import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
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
    // await conn.close();

    // Cek hasil query

    setState(() {
      _isLoading = false;
    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Login'),
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         children: [
  //           TextField(
  //             controller: _usernameController,
  //             decoration: InputDecoration(
  //               labelText: 'Username',
  //             ),
  //           ),
  //           SizedBox(height: 16.0),
  //           TextField(
  //             controller: _passwordController,
  //             obscureText: true,
  //             decoration: InputDecoration(
  //               labelText: 'Password',
  //             ),
  //           ),
  //           SizedBox(height: 16.0),
  //           ElevatedButton(
  //             onPressed: _isLoading ? null : _login,
  //             child: Text(_isLoading ? 'Loading...' : 'Login'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var smallVer = false;
    double scrh = MediaQuery.of(context).size.height / 100;
    double scrw = MediaQuery.of(context).size.width / 100;
    if (scrh + (.2 * scrh) > scrw) {
      smallVer = true;
    } else {
      smallVer = false;
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DefaultTextStyle(
        style: const TextStyle(color: Colors.white, fontFamily: 'Unifont'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("LOGIN",
                style: TextStyle(
                    fontFamily: "Unifont",
                    fontSize: scrw * (smallVer ? 6 : 4.5),
                    color: Colors.blueAccent.shade700)),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(scrw * 63, 0, 0, scrh),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Colors.white)),
                    ),
                  ],
                ),
                HoverAnimatedContainer(
                  width: (smallVer) ? scrw * 85 : scrw * 65,
                  height: (smallVer) ? scrh * 75 : scrh * 50,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(width: 3, color: Colors.blue),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade900,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset:
                              const Offset(5, 5), // changes position of shadow
                        ),
                      ]),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: scrh * 3,
                        ),
                        // const Text(
                        //   "Isi form dibawah ini dengan benar",
                        //   style: TextStyle(
                        //       fontSize: 30, fontWeight: FontWeight.w900),
                        //   textAlign: TextAlign.center,
                        // ),
                        Form(
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    style: const TextStyle(
                                        fontFamily: 'Unifont',
                                        color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Username",
                                      labelStyle: TextStyle(
                                          fontFamily: 'Unifont',
                                          color: Colors.white),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                          fontFamily: 'Unifont',
                                          color: Colors.blue),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Username tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _passwordController,
                                    style: const TextStyle(
                                        fontFamily: 'Unifont',
                                        color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Password",
                                      labelStyle: TextStyle(
                                          fontFamily: 'Unifont',
                                          color: Colors.white),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorStyle: TextStyle(
                                          fontFamily: 'Unifont',
                                          color: Colors.blue),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Password tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: scrh * 3),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.blue.shade800,
                                    onSurface: Colors.grey,
                                    side: const BorderSide(
                                        color: Colors.transparent, width: 1),
                                    elevation: 20,
                                    minimumSize: smallVer
                                        ? Size(scrw * 60, scrh * 7)
                                        : const Size(150, 50),
                                    shape: BeveledRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.blue.shade800,
                                            width: 2),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  onPressed: () {
                                    _isLoading ? null : _login;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                        smallVer ? scrw * 0.5 : 16.0),
                                    child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          fontSize: scrw * (smallVer ? 4 : 1.1),
                                          letterSpacing: 2.0,
                                          fontFamily: 'Unifont'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
