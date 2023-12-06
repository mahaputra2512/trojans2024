import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class TeaserPage extends StatefulWidget {
  const TeaserPage({Key? key}) : super(key: key);

  @override
  State<TeaserPage> createState() => _TeaserPageState();
}

class _TeaserPageState extends State<TeaserPage> {
  final YoutubePlayerController _ytbPlayerController = YoutubePlayerController(
    initialVideoId: "BIfiodooo7o",
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      autoPlay: false,
    ),
  );
  final YoutubePlayerController _ytbPlayerController2 = YoutubePlayerController(
    initialVideoId: "hjhLhqBtGDY",
    params: const YoutubePlayerParams(
      showFullscreenButton: true,
      autoPlay: false,
    ),
  );

  @override
  void initState() {
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
    return DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: scrh * 10),
                child: Text("Teaser",
                    style: TextStyle(
                        fontFamily: "Unifont",
                        fontSize: scrw * (smallVer ? 6 : 4.5),
                        color: Colors.redAccent.shade700)),
              ),
            ),
            Center(
              child: smallVer
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, scrh * 20, 0, 0),
                            child: YoutubePlayerIFrame(controller: _ytbPlayerController)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, scrh * 20, 0, 0),
                            child: YoutubePlayerIFrame(controller: _ytbPlayerController2)),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, scrh * 20, 0, 0),
                            child: SizedBox(
                              width: scrw * 30,
                              child: YoutubePlayerIFrame(
                                controller: _ytbPlayerController,
                                aspectRatio: 16 / 9,
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(0, scrh * 20, 0, 0),
                            child: SizedBox(
                              width: scrw * 30,
                              child: YoutubePlayerIFrame(
                                controller: _ytbPlayerController2,
                                aspectRatio: 16 / 9,
                              ),
                            )),
                      ],
                    ),
            ),
          ],
        ));
  }
}
