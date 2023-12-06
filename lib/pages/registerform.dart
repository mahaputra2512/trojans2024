// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:group_radio_button/group_radio_button.dart';

import '../utils.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key, required this.batch, required this.packageTitles, required this.packages})
      : super(key: key);

  final String batch;
  final List<String> packageTitles;
  final dynamic packages;

  @override
  // ignore: no_logic_in_create_state
  State<RegisterForm> createState() => _RegisterCTFState(
        batch: batch,
        packageTitles: packageTitles,
        packages: packages,
      );
}

class _RegisterCTFState extends State<RegisterForm> {
  _RegisterCTFState({required this.batch, required this.packageTitles, required this.packages});
  final _formKey = GlobalKey<FormState>();

  PlatformFile? followProofFile; //bukti follow
  PlatformFile? transferProofFile;
  PlatformFile? commentProofFile;
  String followProofId = ""; //bukti follow
  String transferProofId = "";
  String commentProofId = "";

  final String batch;
  final List<String> packageTitles;
  final dynamic packages;

  late String _packageValue;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  Future _postRegisCTF() async {
    Utils(context).startLoading();
    var body = {
      'name': nameController.text,
      'email': emailTextController.text,
      'phone': phoneNumberTextController.text,
      'package': _packageValue,
      'batch': batch,
      'followProofId': followProofId,
      'transferProofId': transferProofId,
      'commentProofId': commentProofId //not yet get on server
    };
    var data = await http
        .post(Uri.parse("https://korpstar-poltekssn.org:8444/api/register"), body: body)
        .timeout(const Duration(seconds: 7), onTimeout: () {
      return http.Response({}.toString(), 408);
    });
    var response = json.decode(data.body);
    if (data.statusCode == 200) {
      setState(() {
        Utils(context).stopLoading();
        Navigator.of(context).pop();
        showAlertDialog(context, MediaQuery.of(context).size.width / 100, false, "Registrasi Suskes!",
            "Kamu telah berhasil mendaftar Trojans 2023. Silahkan cek e-mail untuk informasi lebih lanjut.", true);
      });
    } else {
      setState(() {
        Utils(context).stopLoading();
        showAlertDialog(
            context,
            MediaQuery.of(context).size.width / 100,
            false,
            "Registrasi Gagal!",
            "Waduh ada yang salah nih. Silahkan hubungi panitia untuk informasi lebih lanjut.\n\nError code: ${response['message']}",
            false);
      });
    }
  }

  Future getFollowFile(ImageSource media) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png']);
    if (result != null) {
      if (result.files.first.size > 2048000) {
        setState(() {
          showAlertDialog(context, MediaQuery.of(context).size.width / 100, false, "Filenya kegedean!",
              "Ukuran maksimal file registrasi CTF 2 MB ya", false);
        });
        return;
      }
      followProofFile = result.files.first;
      _uploadFollowFile(followProofFile!.name, followProofFile!.bytes);
    } else {
      // User canceled the picker
    }
  } //bukti follow

  Future getTransferFile(ImageSource media) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png']);
    if (result != null) {
      if (result.files.first.size > 2048000) {
        setState(() {
          showAlertDialog(context, MediaQuery.of(context).size.width / 100, false, "Filenya kegedean!",
              "Ukuran maksimal file registrasi CTF 2 MB ya", false);
        });
        return;
      }
      transferProofFile = result.files.first;
      _uploadTransferFile(transferProofFile!.name, transferProofFile!.bytes);
    } else {
      // User canceled the picker
    }
  }

  Future getCommentFile(ImageSource media) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png']);
    if (result != null) {
      if (result.files.first.size > 2048000) {
        setState(() {
          showAlertDialog(context, MediaQuery.of(context).size.width / 100, false, "Filenya kegedean!",
              "Ukuran maksimal file registrasi CTF 2 MB ya", false);
        });
        return;
      }
      commentProofFile = result.files.first;
      _uploadCommentFile(commentProofFile!.name, commentProofFile!.bytes);
    } else {
      // User canceled the picker
    }
  }

  Future _uploadFollowFile(filename, fileByte) async {
    Utils(context).startLoading();
    var request = http.MultipartRequest("POST", Uri.parse("https://korpstar-poltekssn.org:8444/api/files"));
    request.files.add(http.MultipartFile.fromBytes('file', fileByte,
        filename: path.basename(filename), contentType: MediaType('image', 'png')));

    var response = await request.send().timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      dynamic result = await response.stream.bytesToString();
      result = json.decode(result);
      followProofId = result['fileId'];
    }
    setState(() {
      Utils(context).stopLoading();
    });
  }

  Future _uploadTransferFile(filename, fileByte) async {
    Utils(context).startLoading();
    var request = http.MultipartRequest("POST", Uri.parse("https://korpstar-poltekssn.org:8444/api/files"));
    request.files.add(http.MultipartFile.fromBytes('file', fileByte,
        filename: path.basename(filename), contentType: MediaType('image', 'png')));

    var response = await request.send().timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      dynamic result = await response.stream.bytesToString();
      result = json.decode(result);
      transferProofId = result['fileId'];
    }
    setState(() {
      Utils(context).stopLoading();
    });
  }

  Future _uploadCommentFile(filename, fileByte) async {
    Utils(context).startLoading();
    var request = http.MultipartRequest("POST", Uri.parse("https://korpstar-poltekssn.org:8444/api/files"));
    request.files.add(http.MultipartFile.fromBytes('file', fileByte,
        filename: path.basename(filename), contentType: MediaType('image', 'png')));

    var response = await request.send().timeout(const Duration(seconds: 15));
    if (response.statusCode == 200) {
      dynamic result = await response.stream.bytesToString();
      result = json.decode(result);
      commentProofId = result['fileId'];
    }
    setState(() {
      Utils(context).stopLoading();
    });
  }

  @override
  void initState() {
    _packageValue = packageTitles[0];
    super.initState();
  }

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
            Text("${toBeginningOfSentenceCase(batch)} Registration",
                style: TextStyle(
                    fontFamily: "Unifont", fontSize: scrw * (smallVer ? 6 : 4.5), color: Colors.purpleAccent.shade700)),
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
                      border: Border.all(width: 3, color: Colors.purple),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.shade900,
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(5, 5), // changes position of shadow
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
                        const Text(
                          "Isi form dibawah ini dengan benar",
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                          textAlign: TextAlign.center,
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: nameController,
                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Nama",
                                      labelStyle: TextStyle(fontFamily: 'Unifont', color: Colors.white),
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
                                      errorStyle: TextStyle(fontFamily: 'Unifont', color: Colors.purple),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Nama tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailTextController,
                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Email",
                                      labelStyle: TextStyle(fontFamily: 'Unifont', color: Colors.white),
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
                                      errorStyle: TextStyle(fontFamily: 'Unifont', color: Colors.purple),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: phoneNumberTextController,
                                    keyboardType: TextInputType.phone,
                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: "Nomor Telegram",
                                      labelStyle: TextStyle(fontFamily: 'Unifont', color: Colors.white),
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
                                      errorStyle: TextStyle(fontFamily: 'Unifont', color: Colors.purple),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Nomor Telegram tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: scrh * 2),
                                Row(
                                  children: [
                                    Text("Choose your package: ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: scrw * (smallVer ? 4 : 1.1),
                                            letterSpacing: 2.0,
                                            fontFamily: 'Unifont')),
                                  ],
                                ),
                                Theme(
                                  data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RadioGroup<String>.builder(
                                      direction: Axis.horizontal,
                                      horizontalAlignment: MainAxisAlignment.start,
                                      groupValue: _packageValue,
                                      onChanged: (value) => setState(() {
                                        _packageValue = value!;
                                      }),
                                      items: packageTitles,
                                      itemBuilder: (item) => RadioButtonBuilder(
                                        item,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: HoverAnimatedContainer(
                                    decoration:
                                        BoxDecoration(border: Border.all(color: Colors.white), color: Colors.black),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          Text(packages[_packageValue]['desc'],
                                              textAlign: TextAlign.justify,
                                              style: const TextStyle(
                                                  color: Colors.white, letterSpacing: 1, fontFamily: 'Unifont')),
                                          SizedBox(
                                            height: scrh * 2,
                                          ),
                                          Text(
                                              NumberFormat.currency(locale: 'in_ID', symbol: 'Rp. ', decimalDigits: 0)
                                                  .format(packages[_packageValue]['price']),
                                              style: const TextStyle(fontSize: 20))
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: scrh * 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: smallVer
                                      ? Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getFollowFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(height: scrh),
                                            followProofFile != null
                                                ? Text(followProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti follow instagram ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getFollowFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(width: scrw),
                                            followProofFile != null
                                                ? Text(followProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti follow instagram ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                ),
                                SizedBox(height: scrh * 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: smallVer
                                      ? Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getCommentFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(height: scrh),
                                            commentProofFile != null
                                                ? Text(commentProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti comment dan tag teman kamu ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getCommentFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(width: scrw),
                                            commentProofFile != null
                                                ? Text(commentProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti comment dan tag teman kamu ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                ),

                                SizedBox(height: scrh * 2),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: smallVer
                                      ? Column(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getTransferFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(height: scrh),
                                            transferProofFile != null
                                                ? Text(transferProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti pembayaran ke rekening sesuai ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                onPrimary: Colors.white,
                                                primary: Colors.purple[900],
                                                onSurface: Colors.grey,
                                                side: const BorderSide(color: Colors.transparent, width: 1),
                                                elevation: 20,
                                                minimumSize: smallVer ? Size(scrw * 30, scrh * 3) : const Size(100, 25),
                                              ),
                                              onPressed: () {
                                                getTransferFile(ImageSource.gallery);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(smallVer ? scrw * 0.25 : 8.0),
                                                child: Text("UPLOAD",
                                                    style: TextStyle(
                                                        fontSize: scrw * (smallVer ? 3 : 0.7),
                                                        letterSpacing: 1.0,
                                                        fontFamily: 'Unifont')),
                                              ),
                                            ),
                                            SizedBox(width: scrw),
                                            transferProofFile != null
                                                ? Text(transferProofFile!.name,
                                                    style: const TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                    textAlign: TextAlign.center)
                                                : Wrap(
                                                    children: [
                                                      const Text("Unggah bukti pembayaran ke rekening sesuai ",
                                                          style: TextStyle(fontFamily: 'Unifont', color: Colors.white),
                                                          textAlign: TextAlign.center),
                                                      InkWell(
                                                        child: const Text('panduan terlampir',
                                                            style: TextStyle(
                                                                fontFamily: 'Unifont',
                                                                color: Colors.white,
                                                                decoration: TextDecoration.underline),
                                                            textAlign: TextAlign.center),
                                                        onTap: () =>
                                                            launchUrl(Uri.parse('https://trojans.id/GuideBook')),
                                                      ),
                                                    ],
                                                  )
                                          ],
                                        ),
                                ),

                                SizedBox(height: scrh * 3),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.white,
                                    primary: Colors.deepPurple,
                                    onSurface: Colors.grey,
                                    side: const BorderSide(color: Colors.transparent, width: 1),
                                    elevation: 20,
                                    minimumSize: smallVer ? Size(scrw * 60, scrh * 7) : const Size(150, 50),
                                    shape: BeveledRectangleBorder(
                                        side: const BorderSide(color: Colors.deepPurple, width: 2),
                                        borderRadius: BorderRadius.circular(15)),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      if (followProofFile == null) {
                                        showAlertDialog(context, scrw, smallVer, "Bukti follownya belum!",
                                            "Upload bukti follow story terlebih dahulu!", false);
                                        return;
                                      }
                                      if (transferProofFile == null) {
                                        showAlertDialog(context, scrw, smallVer, "Bukti transfernya belum!",
                                            "Upload bukti pembayaran terlebih dahulu!", false);
                                        return;
                                      }
                                      _postRegisCTF();
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(smallVer ? scrw * 0.5 : 16.0),
                                    child: Text("SUBMIT",
                                        style: TextStyle(
                                            fontSize: scrw * (smallVer ? 4 : 1.1),
                                            letterSpacing: 2.0,
                                            fontFamily: 'Unifont')),
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

// showAlertDialogCTF(BuildContext context, double scrw, bool smallVer) {
//   Widget okButton = TextButton(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
//       child: Text("OK",
//           style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: scrw * 1.5,
//               letterSpacing: 0.5,
//               fontFamily: 'Unifont',
//               color: Colors.purple)),
//     ),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );

//   AlertDialog alert = AlertDialog(
//     title: Text("CTF's Agreements",
//         style: TextStyle(
//             fontSize: scrw * (smallVer ? 5 : 2), letterSpacing: 0.1, fontFamily: 'Unifont', color: Colors.purple)),
//     content: Text("""1. Peserta mengisi data dengan sesuai dan benar pada tahap registrasi WRECK-IT 3.0.
// 2. Peserta adalah Warga Negara Indonesia dan dapat dibuktikan kewarganegaraannya dengan hasil pindai kartu identitas (KTP/KTM/SIM).
// 3. Peserta melengkapi berkas pendaftaran dengan data yang benar dan legal secara hukum.
// 4. Peserta bukan merupakan panitia WRECK-IT 3.0. atau pun author soal.
// 5. Setiap peserta hanya boleh terdaftar pada satu tim yang terdiri dari minimal satu orang dan paling banyak tiga orang peserta.
// 6. Peserta yang tidak memenuhi persyaratan dan terbukti melanggar ketentuan, akan didiskualifikasi dan dilarang mengikuti perlombaan.
// 7. Tim yang telah terverifikasi pada tahap registrasi tidak diperbolehkan mengubah data ataupun mengganti susunan tim.
// 8. Tim wajib melakukan registrasi ulang sebelum kompetisi dimulai.
// 9. Peserta yang tidak mengkonfirmasi kehadiran baik ketika babak penyisihan dan babak final akan didiskualifikasi.
// 10. Terdapat beberapa larangan selama pelaksanaan CTF berlangsung, yaitu:
//     • Melakukan DDoS terhadap server.
//     • Menimbulkan gangguan kepada peserta lainnya ataupun panitia dalam bentuk apapun.
//     • Melakukan kerjasama dengan pihak yang tidak terdaftar sebagai peserta.
//     • Peserta memberikan akun kepada pihak-pihak di luar tim,
//     • Peserta bekerjasama dengan peserta lain seperti berbagi flag atau melakukan tindakan-tindakan kecurangan lainnya.
// 11. Peserta yang menjadi finalis lomba CTF WRECK-IT 3.0 wajib menghadiri kegiatan webinar sesi II dan awarding session yang diselenggarakan secara daring.
// 12. Penilaian merupakan hasil koordinasi panitia dengan dewan juri.
// 13. Keputusan yang ditetapkan bersifat mutlak dan tidak dapat diganggu gugat.
// 14. Panitia berhak mencabut gelar juara dan mengambil kembali hadiah yang telah diberikan apabila terbukti tim yang bersangkutan melakukan kecurangan atau pelanggaran lain ketika kompetisi berlangsung.""",
//         style: TextStyle(
//             fontSize: scrw * (smallVer ? 4 : 1), letterSpacing: 0.5, fontFamily: 'Unifont', color: Colors.purple)),
//     actions: [
//       okButton,
//     ],
//     backgroundColor: Colors.white,
//   );

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return SingleChildScrollView(child: alert);
//     },
//   );
// }

showAlertDialog(BuildContext context, double scrw, bool smallVer, String title, String content, bool suksesGa) {
  Widget okButton = TextButton(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Text("OK",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: scrw * 1.5,
              letterSpacing: 0.5,
              fontFamily: 'Unifont',
              color: Colors.purple)),
    ),
    onPressed: () {
      Navigator.of(context).pop();
      suksesGa ? Navigator.of(context).pop() : null;
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text(title,
        style: TextStyle(
            fontSize: scrw * (smallVer ? 5 : 2), letterSpacing: 0.1, fontFamily: 'Unifont', color: Colors.purple)),
    content: Text(content,
        style: TextStyle(
            fontSize: scrw * (smallVer ? 4 : 1.5), letterSpacing: 0.5, fontFamily: 'Unifont', color: Colors.purple)),
    actions: [
      okButton,
    ],
    backgroundColor: Colors.white,
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
