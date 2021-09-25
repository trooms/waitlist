import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'size_config.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SoundMind',
        theme: ThemeData(
          splashColor: Colors.black,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'AcPlus',
          primaryColor: Colors.black,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.black,
            selectionColor: Colors.black,
            selectionHandleColor: Colors.black,
          ),
        ),
        home: const Scaffold(
          body: MyHomePage(title: 'SoundMind'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, Image> images = {};
  Image blankImg = Image.asset('blankimg.png');
  late double backdropWidth;
  late double backdropHeight;

  String hint1 = "Forgot your password?";
  String hint2 = "What comes after Sound?";
  late String hintShow;
  bool okHover = false;
  bool desktop = false;

  late TextEditingController myController;

  void addImage(String name) {
    images[name] = Image.asset('images/' + name + '.png');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    images.forEach((key, value) {
      precacheImage(value.image, context);
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    addImage('backdrop');
    addImage('lines');
    addImage('rectBorder');
    addImage('icon');
    addImage('smallRect');
    addImage('smallRectFilled');
    addImage('apple');
    backdropWidth = 800.0;
    backdropHeight = 600.0;
    myController = TextEditingController();
    hintShow = hint1;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    if (700.0 > SizeConfig.screenWidth) {
      backdropWidth = SizeConfig.screenWidth - 20;
      backdropHeight = 700;
    } else {
      backdropWidth = 700.0;
      backdropHeight = 500.0;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: SizedBox(
            width: backdropWidth,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                height: backdropHeight,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: getImg('backdrop'),
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                ),
                child: desktop == true
                    ? const SizedBox.shrink()
                    : Center(child: login())),
          ),
        ),
      ],
    );
  }

  ImageProvider<Object> getImg(String name) {
    return images[name]?.image ?? blankImg.image;
  }

  Widget getImage(String name) {
    return images[name] ?? const SizedBox.shrink();
  }

  Widget desktopWidgets() {
    return Stack(
      children: [
        ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
            ),
            child: Material(
                color: Colors.white,
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1.5, color: Colors.black)),
                  ),
                  height: 30,
                  width: 10000,
                  child: FittedBox(
                    child: getImage('lines'),
                    fit: BoxFit.fill,
                  ),
                ),),),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 6.5),
            SizedBox(
              height: 27,
              child: getImage('apple'),
            ),
            const SizedBox(width: 6.5),
            const Text('File'),
            const SizedBox(width: 10),
            const Text('Edit'),
            const SizedBox(width: 10),
            const Text('Special'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            SizedBox(
              height: 27,
            ),
            Text('Soundmind Release Nov 22. '),
            Text('Mon.')
          ],
        )
      ],
    );
  }

  Widget login() {
    return Container(
      height: 340.0,
      width: 480.0,
      color: Colors.white,
      child: Stack(
        children: [
          ClipRect(
            child: Transform.scale(
              scale: 0.96,
              child: getImage('rectBorder'),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 70,
                  child: getImage('icon'),
                ),
                const SizedBox(height: 5),
                Transform.scale(
                  scale: 1.6,
                  child: const Text('Soundmind'),
                ),
                const SizedBox(height: 25),
                Transform.scale(
                  scale: 1.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      Text('        Password'),
                      SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 150),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text('Copyright © Soundmind Corp. All Rights Reserved'),
                    SizedBox(width: 180),
                  ],
                ),
              ],
            ),
          ),
          ClipRect(
            child: Center(
              child: Transform.scale(
                scale: 1.5,
                child: getImage('lines'),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 160),
                SizedBox(
                  width: 200,
                  height: 20,
                  child: TextField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.black, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1.5,
                          ),
                        ),
                        isDense: true, // Added this
                        contentPadding: EdgeInsets.all(8)),
                    controller: myController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: () {
                    setState(() {
                      hintShow = hintShow == hint1 ? hint2 : hint1;
                    });
                  },
                  child: Text(
                    hintShow,
                    textScaleFactor: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.5,
                      child: getImage('smallRect'),
                    ),
                    Transform.scale(
                      scale: 0.35,
                      child: InkWell(
                        onTap: () {
                          if (myController.text.toLowerCase() == "mind") {
                            setState(() {
                              desktop = true;
                            });
                          }
                        },
                        onHover: (hover) {
                          setState(() {
                            okHover = hover;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (okHover)
                              getImage('smallRectFilled')
                            else
                              getImage('smallRect'),
                            Text('OK',
                                textScaleFactor: 5.0,
                                style: TextStyle(
                                    color: okHover == true
                                        ? Colors.white
                                        : Colors.black),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class MyDesktop extends StatefulWidget {
// const MyDesktop({Key? key}) : super(key: key);
// @override
// State<MyDesktop> createState() => _MyDesktopState();
// }

// class _MyDesktopState extends State<MyDesktop> {
// late String backdrop;
// String newBackdrop = "images/backdropColored.png";
// String header = "images/header2.png";

// @override
// void initState() {
// super.initState();
// }

// // @override
// // Widget build(BuildContext context) {
// // SizeConfig(context);
// // // return;
// // }
// }
