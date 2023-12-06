import 'package:flutter/material.dart';

class MediaPartnerPage extends StatefulWidget {
  const MediaPartnerPage({Key? key}) : super(key: key);

  @override
  State<MediaPartnerPage> createState() => _MediaPartnerPageState();
}

class _MediaPartnerPageState extends State<MediaPartnerPage> {
  @override
  Widget build(BuildContext context) {
    // var smallVer = false;
    double scrh = MediaQuery.of(context).size.height / 100;
    double scrw = MediaQuery.of(context).size.width / 100;
    // if (scrh + (.2 * scrh) > scrw) {
    //   smallVer = true;
    // } else {
    //   smallVer = false;
    // }
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: scrh * 2, horizontal: scrw * 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset("images/med1.png", height: scrh * 30),
            Image.asset("images/med3.png", height: scrh * 20),
            Image.asset("images/med2.png", height: scrh * 15),
          ],
        ),
      ),
    );
  }
}
