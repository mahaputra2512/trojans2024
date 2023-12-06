import 'package:flutter/material.dart';
import 'package:trojans/pages/registerform.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  dynamic registrationData = [
    {
      "from": DateTime.parse("2022-11-13"),
      "to": DateTime.parse(
          "2022-11-29"), //add 1 to real date for comparation issue
      "batch": "early bird",
      "packageTitles": ["luring", "daring", "luxury"],
      "packages": {
        "luring": {
          "desc":
              "1x TryOut Luring dan Pembahasan\n2x kali paket latihan SPTB Poltek SSN 2023\nKiat Sukses SPTB Poltek SSN 2023\nLive Hacking\nCampus Tour\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor\nCyber and Crypto Stand\nVoucher 50% Bug Bounty Course Sekolah Siber\nFree Snack ",
          "price": 50000
        },
        "daring": {
          "desc":
              "1x TryOut Daring dan Pembahasan\n3x Paket Latihan SPTB Poltek SSN 2023\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor\nVoucher 50% Bug Bounty Course Sekolah Siber",
          "price": 40000
        },
        "luxury": {
          "desc":
              "1x TryOut Luring dan Pembahasan\n1x TryOut Daring dan Pembahasan\n5x Paket Latihan SPTB Poltek SSN 2023\nKiat Sukses SPTB Poltek SSN 2023\nLive Hacking\nCampus Tour\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor\nCyber and Crypto Stand\nVoucher 50% Bug Bounty Course Sekolah Siber\nFree Snack",
          "price": 75000
        }
      }
    },
    {
      "from": DateTime.parse("2022-12-04"),
      "to": DateTime.parse("2023-01-05"),
      "batch": "reguler",
      "packageTitles": ["luring", "daring", "luxury"],
      "packages": {
        "luring": {
          "desc":
              "1x TryOut Luring dan Pembahasan\n2x kali paket latihan SPTB Poltek SSN 2023\nKiat Sukses SPTB Poltek SSN 2023\nLive Hacking\nCampus Tour\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor\nCyber and Crypto Stand",
          "price": 60000
        },
        "daring": {
          "desc":
              "1x TryOut Daring dan Pembahasan\n3x Paket Latihan SPTB Poltek SSN 2023\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor",
          "price": 50000
        },
        "luxury": {
          "desc":
              "1x TryOut Luring dan Pembahasan\n1x TryOut Daring dan Pembahasan\n5x Paket Latihan SPTB Poltek SSN 2023\nKiat Sukses SPTB Poltek SSN 2023\nLive Hacking\nCampus Tour\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor\nCyber and Crypto Stand",
          "price": 85000
        }
      }
    },
    {
      "from": DateTime.parse("2023-01-05"),
      "to": DateTime.parse("2023-02-04"),
      "batch": "last chance",
      "packageTitles": ["daring"],
      "packages": {
        "daring": {
          "desc":
              "1x TryOut Daring dan Pembahasan\n3x Paket Latihan SPTB Poltek SSN 2023\nCareer Talk oleh alumni STSN dan Poltek SSN\nExclusive Group Discussion SPTB with Mentor",
          "price": 60000
        }
      }
    }
  ];

  late DateTime now;

  int dataIndex = -1;
  Future _setCountdown() async {
    // now = DateTime.parse('2023-01-06');
    now = DateTime.now();
    for (int i = 0; i < registrationData.length; i++) {
      if (now.isAfter(registrationData[i]['from']) &&
          now.isBefore(registrationData[i]['to'])) {
        dataIndex = i;
        return;
      }
    }
  }

  @override
  void initState() {
    _setCountdown();
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: scrh * 10),
        smallVer
            ? Column(
                children: [
                  Image.asset(
                    "images/logo.png",
                    width: scrw * 55,
                  ),
                  Image.asset(
                    "images/headline.png",
                    width: scrw * 65,
                  ),
                ],
              )
            : Image.asset(
                "images/logo_headline_merge.png",
                width: scrw * 65,
              ),
        SizedBox(height: scrh * (smallVer ? 1 : 3)),
        Flex(
          direction: smallVer ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
                primary: Colors.deepPurple,
                onSurface: Colors.deepPurple,
                side: const BorderSide(color: Colors.yellow, width: 1),
                elevation: 20,
                minimumSize:
                    smallVer ? Size(scrw * 60, scrh * 7) : const Size(150, 50),
                shape: BeveledRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255), width: 2),
                    borderRadius: BorderRadius.circular(15)),
              ),
              onPressed: () async {
                if (dataIndex == -1) {
                  showAlertDialog(
                      context,
                      scrw,
                      smallVer,
                      "Belum ada yang buka!",
                      "Harap tunggu sampai pendaftaran dibuka!",
                      false);
                } else {
                  await showDialog(
                      context: context,
                      builder: (BuildContext context) => RegisterForm(
                            batch: registrationData[dataIndex]['batch'],
                            packageTitles: registrationData[dataIndex]
                                ['packageTitles'],
                            packages: registrationData[dataIndex]['packages'],
                          ),
                      barrierDismissible: false);
                }
              },
              child: Padding(
                padding: EdgeInsets.all(smallVer ? scrw * 0.5 : 16.0),
                child: Text("REGISTER",
                    style: TextStyle(
                        fontSize: scrw * (smallVer ? 4 : 1.1),
                        letterSpacing: 2.0,
                        fontFamily: 'Unifont')),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class TitlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.purpleAccent.shade700
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    Path path = Path()
          ..moveTo(cornerSide, 0)
          ..quadraticBezierTo(0, 0, 0, cornerSide)
          // ..moveTo(0, sh - cornerSide)
          // ..quadraticBezierTo(0, sh, cornerSide, sh)
          ..moveTo(sw - cornerSide, sh)
          ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
        // ..moveTo(sw, cornerSide)
        // ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);
        ;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TitlePainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(TitlePainter oldDelegate) => false;
}
