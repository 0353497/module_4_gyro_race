import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/route_manager.dart';
import 'package:module_4/pages/homepage.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Gamepage extends StatefulWidget {
  const Gamepage({super.key, required this.car});
  final String car;

  @override
  State<Gamepage> createState() => _GamepageState();
}

class _GamepageState extends State<Gamepage>
    with SingleTickerProviderStateMixin {
  bool isPaused = false;
  Rect carRect = Rect.fromLTWH(75, 700, 100, 200);
  Rect startRecht = Rect.fromLTWH(0, 600, Get.width, Get.height / 2);
  Rect trackRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
  Rect trackRect2 = Rect.fromLTWH(0, Get.height / 2, Get.width, Get.height / 2);
  Rect grassRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
  int collectedStars = 0;
  int countDown = 3;
  bool showStart = true;
  Rect obstacleRect = Rect.fromLTWH(240, 0, 50, 50);
  Rect starRect = Rect.fromLTWH(70, 0, 50, 50);
  Duration lastSinceStar = Duration.zero;
  bool showObstacle = false;
  bool showStar = true;
  bool showFinal = false;
  final Duration gameDur = const Duration(seconds: 20);
  bool showGrass = false;
  late Ticker _ticker;
  bool finished = false;
  double angle = pi * 2;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((dur) => update(dur));
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        countDown--;
      });
      if (countDown < 0) {
        timer.cancel();
        _ticker.start();
      }
    });

    gyroscopeEventStream().listen((data) {
      setState(() {
        if (data.y > 3) {
          carRect = Rect.fromLTWH(
            250,
            carRect.top,
            carRect.width,
            carRect.height,
          );
        } else if (data.y < -3) {
          carRect = Rect.fromLTWH(
            100,
            carRect.top,
            carRect.width,
            carRect.height,
          );
        }
      });
      angle = data.y;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fromRect(
            rect: trackRect2,
            child: Image.asset(
              "assets/images/track.png",
              fit: BoxFit.contain,
              repeat: ImageRepeat.repeatY,
            ),
          ),
          Positioned.fromRect(
            rect: trackRect,
            child: Transform.scale(
              scaleY: 3,
              child: Image.asset(
                "assets/images/track.png",
                fit: BoxFit.contain,
                repeat: ImageRepeat.repeatY,
              ),
            ),
          ),
          if (showFinal)
            Positioned.fromRect(
              rect: trackRect,
              child: Image.asset(
                "assets/images/end-track.png",
                fit: BoxFit.cover,
                repeat: ImageRepeat.repeatY,
              ),
            ),
          if (showStart)
            Positioned.fromRect(
              rect: startRecht,
              child: Image.asset("assets/images/start.png", fit: BoxFit.cover),
            ),

          if (showGrass)
            Positioned.fromRect(
              rect: grassRect,
              child: Container(
                color: Colors.green,
                width: Get.width,
                height: Get.height / 2,
              ),
            ),
          Positioned(
            top: 32,
            left: 32,
            child: SizedBox(
              width: 300,
              child: Stack(
                children: [
                  Positioned(
                    left: 50,
                    top: 10,
                    child: Container(
                      width: 150,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(10, 20),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "$collectedStars",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Image.asset("assets/images/star.png", width: 80),
                ],
              ),
            ),
          ),
          if (showObstacle)
            Positioned.fromRect(
              rect: obstacleRect,
              child: Image.asset("assets/images/pylon.png"),
            ),
          if (showStar)
            Positioned.fromRect(
              rect: starRect,
              child: Image.asset("assets/images/star.png"),
            ),

          Positioned.fromRect(
            rect: carRect,
            child: Transform.rotate(
              angle: angle,
              child: Image.asset("assets/images/${widget.car}-car.png"),
            ),
          ),

          if (isPaused)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    "Pauzed",
                    style: TextStyle(color: Colors.white, fontSize: 64),
                  ),
                ),
              ),
            ),
          if (countDown > 0)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Text(
                    "$countDown",
                    style: TextStyle(color: Colors.white, fontSize: 64),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 16,
            top: 16,
            child: IconButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onPressed: () {
                setState(() {
                  if (isPaused) {
                    print("play");
                    _ticker.start();
                  } else {
                    _ticker.stop();
                  }
                  isPaused = !isPaused;
                });
              },
              icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
            ),
          ),
        ],
      ),
    );
  }

  void update(Duration dur) {
    if (startRecht.top > Get.height - 100) {
      setState(() {
        showStart = false;
      });
    }
    double acceleration = ((dur.inMilliseconds + 1) / 1000);

    if (acceleration > 12) acceleration = 12;
    if (dur.inSeconds > gameDur.inSeconds) {
      acceleration -= (dur.inMilliseconds - gameDur.inMilliseconds) * .002;
      print((dur.inMilliseconds - gameDur.inMilliseconds) * .002);
    }
    if (acceleration < 0) {
      finished = true;
      _ticker.stop();
      showDialog(
        context: context,
        builder: (context) {
          return finishedDialog();
        },
      );
    }

    if ((trackRect.top + trackRect.height) > Get.height) {
      trackRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
    }
    if ((trackRect2.top + trackRect2.height) > Get.height + Get.height / 2) {
      trackRect2 = Rect.fromLTWH(
        0,
        Get.height - 300,
        Get.width,
        Get.height / 2,
      );
    }
    if (obstacleRect.bottom > Get.height) {
      obstacleRect = Rect.fromLTWH(70, 0, 50, 50);
      showObstacle = true;
      int rnd = Random().nextInt(2);
      if (rnd == 1) {
        obstacleRect = Rect.fromLTWH(
          240,
          obstacleRect.top,
          obstacleRect.width,
          obstacleRect.height,
        );
      } else {
        obstacleRect = Rect.fromLTWH(
          60,
          obstacleRect.top,
          obstacleRect.width,
          obstacleRect.height,
        );
      }
    }
    if (obstacleRect.overlaps(carRect)) {
      showObstacle = false;
    }

    if (dur.inSeconds > 10 && dur.inSeconds < 16) {
      setState(() {
        showGrass = true;
      });
    } else {
      showGrass = false;
    }

    if (carRect.overlaps(grassRect) &&
        dur.inSeconds > 10 &&
        dur.inSeconds < 16) {
      acceleration = acceleration * .4;
    }

    if (grassRect.bottom > Get.height) {
      grassRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
    }

    if (starRect.bottom > Get.height) {
      starRect = Rect.fromLTWH(70, 0, 50, 50);
      showStar = true;
      int rnd = Random().nextInt(2);
      if (rnd == 1) {
        starRect = Rect.fromLTWH(
          240,
          starRect.top,
          starRect.width,
          starRect.height,
        );
      } else {
        starRect = Rect.fromLTWH(
          60,
          starRect.top,
          starRect.width,
          starRect.height,
        );
      }
    }

    if (obstacleRect.overlaps(carRect)) {
      _ticker.stop();
      showDialog(
        context: context,
        builder: (context) {
          return crashDialog(context);
        },
      );
    }

    if (starRect.overlaps(carRect) &&
        (lastSinceStar.inMilliseconds - dur.inMilliseconds) < -1500) {
      showStar = false;
      print(lastSinceStar.inMilliseconds - dur.inMilliseconds);
      collectedStars++;
      lastSinceStar = dur;
    }

    if (dur.inSeconds > gameDur.inSeconds) {
      showFinal = true;
    }

    setState(() {
      obstacleRect = obstacleRect.shift(Offset(0, acceleration));
      starRect = starRect.shift(Offset(0, acceleration));
      startRecht = startRecht.shift(Offset(0, acceleration));
      trackRect = trackRect.shift(Offset(0, acceleration));
      trackRect2 = trackRect2.shift(Offset(0, acceleration));
      grassRect = grassRect.shift(Offset(0, acceleration));
    });
  }

  Dialog crashDialog(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => Homepage());
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              "Crashed!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 70,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff76b92c)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _resetGame();
                },
                child: Text(
                  "Again",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Dialog finishedDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => Homepage());
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              "Finished!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 70,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Color(0xff76b92c)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  _resetGame();
                },
                child: Text(
                  "Again",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetGame() {
    setState(() {
      isPaused = false;
      carRect = Rect.fromLTWH(75, 700, 100, 200);
      startRecht = Rect.fromLTWH(0, 600, Get.width, Get.height / 2);
      trackRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
      trackRect2 = Rect.fromLTWH(0, Get.height / 2, Get.width, Get.height / 2);
      grassRect = Rect.fromLTWH(0, 0, Get.width, Get.height / 2);
      collectedStars = 0;
      countDown = 0;
      showStart = true;
      obstacleRect = Rect.fromLTWH(70, 0, 50, 50);
      starRect = Rect.fromLTWH(70, 0, 50, 50);
      lastSinceStar = Duration.zero;
      showObstacle = false;
      showStar = true;
      showFinal = false;
      showGrass = false;
      finished = false;
      _ticker.start();
    });
  }
}
