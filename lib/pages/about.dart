import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<dynamic> aboutData = [
    {
      "title": "TO Luring",
      "index": 0,
      "desc":
          "Tryout yang dilaksanakan secara luring di kampus Poltek SSN dengan tujuan untuk memberikan gambaran kepada calon peserta SPTB Poltek SSN mengenai bentuk soal, pengerjaan, serta informasi lain yang berkaitan dengan tes akademik SPTB Poltek SSN.",
      "image": "about0.jpg"
    },
    {
      "title": "TO Daring",
      "index": 1,
      "desc":
          "Tryout yang dilaksanakan secara daring dengan tujuan untuk memberikan gambaran kepada calon peserta SPTB Poltek SSN mengenai bentuk soal, pengerjaan, serta informasi lain yang berkaitan dengan tes akademik SPTB Poltek SSN.",
      "image": "about1.jpg"
    },
    {
      "title": "Live Hacking",
      "index": 2,
      "desc":
          "Live hacking merupakan demonstrasi secara langsung tentang bagaimana proses peretasan atau yang biasa disebut dengan hacking terjadi",
      "image": "about3.jpg"
    },
    {
      "title": "Campus Tour",
      "index": 3,
      "desc":
          "Campus tour adalah rangkaian acara dimana Peserta TROJANS 2024 berjalan mengelilingi kampus Poltek SSN sebagai gambaran nantinya bagaimana rasanya berkuliah di Poltek SSN",
      "image": "about4.jpg"
    },
    {
      "title": "Career Talk",
      "index": 4,
      "desc":
          "Merupakan rangkaian terakhir dari try out TROJANS 2024 yang mengundang pembicara dari alumni STSN atau Poltek SSN dan membicarakan tentang prospek karir setelah lulus dari Poltek SSN",
      "image": "about5.jpg"
    },
  ];

  int aboutShownIndex = 0;
  bool onHov = false;
  bool onTp = false;

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
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: scrh * (smallVer ? 10 : 10),
          ),
          Flex(
              direction: smallVer ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: aboutData.sublist(0, 3).map<Padding>((dynamic data) {
                return Padding(
                  padding: EdgeInsets.all(smallVer ? 5 : 10.0),
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        aboutShownIndex = data['index'];
                      });
                    },
                    onExit: (event) {
                      // setState(() {
                      //   aboutShownIndex = -1;
                      // });
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          aboutShownIndex = aboutShownIndex != data['index']
                              ? data['index']
                              : -1;
                        });
                      },
                      child: HoverAnimatedContainer(
                        decoration: data['index'] == aboutShownIndex
                            ? BoxDecoration(color: Colors.blueAccent.shade700)
                            : BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.black),
                        hoverDecoration:
                            BoxDecoration(color: Colors.blueAccent.shade400),
                        child: Padding(
                          padding: EdgeInsets.all(scrh * (smallVer ? 1 : 4)),
                          child: Text(data['title'],
                              style: TextStyle(
                                  fontSize: scrw * (smallVer ? 4 : 1.1),
                                  letterSpacing: 1.5,
                                  fontFamily: 'Unifont')),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
          Flex(
              direction: smallVer ? Axis.vertical : Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: aboutData.sublist(3, 5).map<Padding>((dynamic data) {
                return Padding(
                  padding: EdgeInsets.all(smallVer ? 5 : 10.0),
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        aboutShownIndex = data['index'];
                      });
                    },
                    onExit: (event) {
                      // setState(() {
                      //   aboutShownIndex = -1;
                      // });
                    },
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          aboutShownIndex = aboutShownIndex != data['index']
                              ? data['index']
                              : -1;
                        });
                      },
                      child: HoverAnimatedContainer(
                        decoration: data['index'] == aboutShownIndex
                            ? BoxDecoration(color: Colors.blueAccent.shade700)
                            : BoxDecoration(
                                border: Border.all(color: Colors.white),
                                color: Colors.black),
                        hoverDecoration:
                            BoxDecoration(color: Colors.blueAccent.shade400),
                        child: Padding(
                          padding: EdgeInsets.all(scrh * (smallVer ? 1 : 4)),
                          child: Text(data['title'],
                              style: TextStyle(
                                  fontSize: scrw * (smallVer ? 4 : 1.1),
                                  letterSpacing: 1.5,
                                  fontFamily: 'Unifont')),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList()),
          if (!smallVer) const Spacer(),
          if (aboutShownIndex != -1)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: HoverAnimatedContainer(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: Colors.black),
                child: Padding(
                  padding: EdgeInsets.all(scrh * 2),
                  child: smallVer
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "images/${aboutData[aboutShownIndex]['image']}",
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(aboutData[aboutShownIndex]['desc'],
                                  style: TextStyle(
                                      fontSize: scrw * (smallVer ? 3 : 1.1),
                                      letterSpacing: 1,
                                      fontFamily: 'Unifont')),
                            ),
                          ],
                        )
                      : aboutShownIndex % 2 == 0
                          ? Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        aboutData[aboutShownIndex]['desc'],
                                        style: TextStyle(
                                            fontSize: scrw * 1.1,
                                            letterSpacing: 1,
                                            fontFamily: 'Unifont'))),
                                SizedBox(
                                  width: scrw * 35,
                                  height: scrh * 35,
                                  child: Image.asset(
                                    "images/${aboutData[aboutShownIndex]['image']}",
                                  ),
                                )
                              ],
                            )
                          : Row(
                              children: [
                                SizedBox(
                                  width: scrw * 35,
                                  height: scrh * 35,
                                  child: Image.asset(
                                    "images/${aboutData[aboutShownIndex]['image']}",
                                  ),
                                ),
                                Expanded(
                                    child: Text(
                                        aboutData[aboutShownIndex]['desc'],
                                        style: TextStyle(
                                            fontSize: scrw * 1.1,
                                            letterSpacing: 1,
                                            fontFamily: 'Unifont'))),
                              ],
                            ),
                ),
              ),
            ),
          if (!smallVer) const Spacer(),
        ],
      ),
    );
  }
}
