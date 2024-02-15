import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:lottie/lottie.dart';

class PrizePage extends StatefulWidget {
  const PrizePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PrizePageState createState() => _PrizePageState();
}

class _PrizePageState extends State<PrizePage> {
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
      style: const TextStyle(color: Colors.white, fontFamily: 'Unifont'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //prize
          Padding(
            padding: EdgeInsets.only(
                top: smallVer ? scrh * 10 : 10, bottom: scrh * 6),
            child: Text("Win our prizes!",
                style: TextStyle(
                    fontFamily: "Unifont",
                    fontSize: scrw * (smallVer ? 6 : 4.5),
                    color: Colors.blueAccent.shade700)),
          ),
          smallVer
              ? Column(
                  children: [
                    BoxMobilePrizes(
                      title: "#1",
                      image:
                          Image.asset("images/coin_gold.png", width: scrw * 45),
                      description: const [
                        "Rp1.000.000,00 ",
                        "Piagam Penghargaan ",
                        "Merchandise"
                      ],
                      width: scrw * 60,
                    ),
                    SizedBox(
                      height: scrh,
                    ),
                    BoxMobilePrizes(
                      title: "#2",
                      image: Image.asset("images/coin_silver.png",
                          width: scrw * 45),
                      description: const [
                        "Rp750.000,00 ",
                        "Piagam Penghargaan ",
                        "Merchandise"
                      ],
                      width: scrw * 60,
                    ),
                    SizedBox(
                      height: scrh,
                    ),
                    BoxMobilePrizes(
                      title: "#3",
                      image: Image.asset("images/coin_bronze.png",
                          width: scrw * 45),
                      description: const [
                        "Rp500.000,00 ",
                        "Piagam Penghargaan ",
                        "Merchandise"
                      ],
                      width: scrw * 60,
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxPrizes(
                        title: "#2",
                        image: Lottie.asset("lotties/coin_silver.json",
                            width: scrw * 10),
                        description: const [
                          "Rp750.000,00 ",
                          "Piagam Penghargaan ",
                          "Merchandise"
                        ],
                        width: scrw * 15,
                        height: scrh * 50),
                    SizedBox(
                      width: scrw * 5,
                    ),
                    BoxPrizes(
                        title: "#1",
                        image: Lottie.asset("lotties/coin_gold.json",
                            width: scrw * 12),
                        description: const [
                          "Rp1.000.000,00 ",
                          "Piagam Penghargaan ",
                          "Merchandise"
                        ],
                        width: scrw * 15,
                        height: scrh * 55),
                    SizedBox(
                      width: scrw * 5,
                    ),
                    BoxPrizes(
                        title: "#3",
                        image: Lottie.asset("lotties/coin_bronze.json",
                            width: scrw * 9),
                        description: const [
                          "Rp500.000,00 ",
                          "Piagam Penghargaan ",
                          "Merchandise"
                        ],
                        width: scrw * 15,
                        height: scrh * 45),
                  ],
                ),
          Padding(
            padding: EdgeInsets.only(
                top: smallVer ? scrh * 15 : 50, bottom: scrh * 3),
            child: Text(
              "There are prizes for offline session!",
              style: TextStyle(
                  backgroundColor: Colors.white,
                  fontFamily: "Unifont",
                  fontSize: scrw * (smallVer ? 4 : 2),
                  color: Colors.blueAccent.shade700),
            ),
          ),
        ],
      ),
    );
  }
}

class BoxPrizes extends StatelessWidget {
  const BoxPrizes(
      {Key? key,
      required this.description,
      required this.image,
      this.width = 400,
      this.height = 500,
      this.useImage = true,
      required this.title,
      this.titleSize = 30})
      : super(key: key);

  final LottieBuilder image;
  final List<String> description;
  final double width;
  final double height;
  final bool useImage;
  final String title;
  final double titleSize;
  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return HoverAnimatedContainer(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 3, color: Colors.blue),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900,
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
            SizedBox(height: scrh * 3),
            Text(
              title,
              style:
                  TextStyle(fontSize: titleSize, fontWeight: FontWeight.w900),
            ),
            useImage ? image : const SizedBox(),
            SizedBox(height: useImage ? scrh * 3 : scrh),
            Text(
              description[0],
              style:
                  TextStyle(fontSize: scrw * 1.1, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(description[1], style: TextStyle(fontSize: scrw * 0.9)),
            Text(description[2], style: TextStyle(fontSize: scrw * 0.9)),
          ],
        ),
      ),
    );
  }
}

class BoxMobilePrizes extends StatelessWidget {
  const BoxMobilePrizes(
      {Key? key,
      required this.description,
      required this.image,
      this.width = 400,
      this.useImage = true,
      required this.title,
      this.titleSize = 30})
      : super(key: key);

  final Image image;
  final List<String> description;
  final double width;
  final bool useImage;
  final String title;
  final double titleSize;
  @override
  Widget build(BuildContext context) {
    double scrw = MediaQuery.of(context).size.width / 100;
    double scrh = MediaQuery.of(context).size.height / 100;
    return HoverAnimatedContainer(
      width: width,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(width: 3, color: Colors.blue),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5), // changes position of shadow
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style:
                  TextStyle(fontSize: titleSize, fontWeight: FontWeight.w900),
            ),
            useImage ? image : const SizedBox(),
            SizedBox(height: useImage ? scrh * 3 : scrh),
            Text(
              description[0],
              style: TextStyle(fontSize: scrw * 4, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(description[1], style: TextStyle(fontSize: scrw * 3)),
            Text(description[2], style: TextStyle(fontSize: scrw * 3)),
          ],
        ),
      ),
    );
  }
}
