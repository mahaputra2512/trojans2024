import 'dart:ui';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trojans/pages/leaderboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:trojans/pages/about.dart';
import 'package:trojans/pages/prize.dart';
import 'package:trojans/pages/register.dart';
import 'package:trojans/pages/timeline.dart';
import 'package:trojans/widgets/coolgreeter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> faqQuestions = [
    {
      "question": "Webnya tidak bekerja dengan baik",
      "answer":
          "Silahkan hard refresh dengan ctrl + f5 atau clear cache. Kendala lebih lanjut bisa dilaporkan kepada panitia melalui contact person atau social media yang tersedia."
    },
    {
      "question": "Bagaimana saya menghubungi panitia Trojans?",
      "answer":
          "Silahkan direct message akun instagram pada ikon di bawah. Atau hubungi kami melalui whatsapp di 0896-1871-0082 (Biru) dan telegram @trojans_id"
    },
  ];

  int faqShownIndex = -1;

  late Object homeScaffoldKey;

  CarouselController buttonCarouselController = CarouselController();

  bool isRegister = true;

  late dynamic coolGreeter = CoolGreeter();

  @override
  void initState() {
    homeScaffoldKey = Object();
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
      key: ValueKey<Object>(homeScaffoldKey),
      drawer: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Drawer(
          backgroundColor: Colors.black,
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.purpleAccent.shade700))),
            child: ListView(
              children: [
                DrawerHeader(
                  child: SizedBox(
                    height: scrh * 5,
                    child: const Center(
                      child: Text(
                        'FAQ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Unifont',
                            fontSize: 36,
                            color: Colors.white,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                ),
                LiveList(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: faqQuestions.length,
                  // reAnimateOnVisibility: true,
                  itemBuilder: (BuildContext context, int index, Animation<double> animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  faqShownIndex = (faqShownIndex == index) ? -1 : index;
                                });
                              },
                              child: DefaultTextStyle(
                                style: const TextStyle(fontFamily: 'Unifont', fontSize: 18, color: Colors.white),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(faqQuestions[index]['question'])),
                                    Icon(
                                      (faqShownIndex == index) ? Icons.close : Icons.chevron_right,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (faqShownIndex == index)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                                child: Text(faqQuestions[index]['answer'],
                                    style: const TextStyle(fontFamily: 'Unifont', fontSize: 14, color: Colors.white)),
                              ),
                            const Divider(
                              thickness: 1,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black87,
      body: MouseRegion(
        onHover: (PointerHoverEvent event) {
          coolGreeter.setMousePos(event.position.dx, event.position.dy);
        },
        child: DefaultTextStyle(
          style: const TextStyle(fontFamily: 'Unifont'),
          child: Stack(children: [
            Align(
                alignment: Alignment.bottomCenter,
                child: Image.asset("images/footer.png",
                    color: Colors.purple.withOpacity(0.5), colorBlendMode: BlendMode.modulate)),
            Align(
                alignment: Alignment.topCenter,
                child: Image.asset("images/header.png",
                    color: Colors.purple.withOpacity(0.5), colorBlendMode: BlendMode.modulate)),
            smallVer
                ? ListView(shrinkWrap: true, children: [
                    SizedBox(
                      height: scrh * 30,
                    ),
                    const RegisterPage(),
                    const AboutPage(),
                    const TimelinePage(),
                    const PrizePage(),
                    const TimelinePage(),
                    const LeaderboardPage(),
                    SizedBox(
                      height: scrh * 20,
                    ),
                  ])
                : Align(
                    alignment: Alignment.center,
                    child: Column(children: [
                      SizedBox(
                          height: scrh * 90,
                          child: CarouselSlider(
                            items: const [
                              RegisterPage(),
                              AboutPage(),
                              TimelinePage(),
                              PrizePage(),
                              TimelinePage(),
                              LeaderboardPage(),
                            ],
                            carouselController: buttonCarouselController,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                initialPage: 0,
                                autoPlayInterval: const Duration(seconds: 10)),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => buttonCarouselController.previousPage(
                                duration: const Duration(milliseconds: 300), curve: Curves.linear),
                            // child: Icon(Icons.navigate_before),
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text("<",
                                  style: TextStyle(
                                      fontSize: 32, letterSpacing: 0.1, fontFamily: 'Unifont', color: Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: scrw * 2,
                          ),
                          GestureDetector(
                            onTap: () => buttonCarouselController.nextPage(
                                duration: const Duration(milliseconds: 300), curve: Curves.linear),
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(">",
                                  style: TextStyle(
                                      fontSize: 32, letterSpacing: 0.1, fontFamily: 'Unifont', color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    ])),
            Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            _launchUrl(Uri.parse('https://www.youtube.com/c/KorpsTarunaPOLTEKSSN'));
                          },
                          icon: FaIcon(FontAwesomeIcons.youtube,
                              color: Colors.purpleAccent.shade700, size: scrw * (smallVer ? 6 : 1.5))),
                      Padding(
                        padding: smallVer ? const EdgeInsets.all(0) : const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: IconButton(
                            onPressed: () {
                              _launchUrl(Uri.parse('https://www.instagram.com/trojans_id'));
                            },
                            icon: FaIcon(FontAwesomeIcons.instagram,
                                color: Colors.purpleAccent.shade700, size: scrw * (smallVer ? 6 : 1.5))),
                      ),
                      IconButton(
                          onPressed: () {
                            _launchUrl(Uri.parse('https://twitter.com/trojans_id'));
                          },
                          icon: FaIcon(FontAwesomeIcons.twitter,
                              color: Colors.purpleAccent.shade700, size: scrw * (smallVer ? 6 : 1.5)))
                    ],
                  ),
                )),
            Align(alignment: Alignment.topRight, child: coolGreeter),
          ]),
        ),
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}

showAlertDialog(BuildContext context, double scrw, bool smallVer) {
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
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Coming soon!",
        style: TextStyle(
            fontSize: scrw * (smallVer ? 5 : 2), letterSpacing: 0.1, fontFamily: 'Unifont', color: Colors.purple)),
    content: Text("This feature will come up soon! Stay tune~",
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

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.07; // desirable value for corners side

    Paint paint = Paint()
      ..color = Colors.purpleAccent.shade700
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    Path path = Path()
      ..moveTo(cornerSide, 0)
      ..quadraticBezierTo(0, 0, 0, cornerSide)
      ..moveTo(0, sh - cornerSide)
      ..quadraticBezierTo(0, sh, cornerSide, sh)
      ..moveTo(sw - cornerSide, sh)
      ..quadraticBezierTo(sw, sh, sw, sh - cornerSide)
      ..moveTo(sw, cornerSide)
      ..quadraticBezierTo(sw, 0, sw - cornerSide, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
