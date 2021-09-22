import 'package:flutter/material.dart';
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
        title: 'waitlist',
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          scaffoldBackgroundColor: Colors.black,
        ),
        home: const Scaffold(
          body: MyHomePage(title: 'waitlist'),
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
  Offset pointer = Offset.zero;

  late String pointerIcon;
  late TextEditingController _controller;
  late ImageProvider<Object> login;

  String loadingIcon = 'images/loading.png';
  String backdrop = 'images/backdrop.png';
  ImageProvider<Object> loginMain = Image.asset(
    'images/login.png',
    gaplessPlayback: true,
  ).image;
  ImageProvider<Object> loginHint =
      Image.asset('images/loginHint.png', gaplessPlayback: true).image;
  ImageProvider<Object> okHover =
      Image.asset('images/okHover.png', gaplessPlayback: true).image;
  String flickerImg = 'images/flicker.png';

  FocusNode myFocusNode = FocusNode();
  late int timerCount = 0;

  bool flicker = false;

  void changeBackdrop(Timer t) async {
    setState(() {
      flicker = !flicker;
      myFocusNode.requestFocus();
    });
  }

  void checkLogin() {
    if (_controller.text.toLowerCase() == 'mind') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyDesktop()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    pointerIcon = loadingIcon;
    login = loginMain;
    Timer.periodic(const Duration(milliseconds: 100), changeBackdrop);
    Timer.periodic(const Duration(seconds: 1), (_) {
      ++timerCount;
    });
    _controller = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(loginHint, context);
    precacheImage(loginMain, context);
    precacheImage(okHover, context);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return ConstrainedBox(
        constraints: BoxConstraints.tight(
            Size(SizeConfig.screenWidth, SizeConfig.screenHeight)),
        child: MouseRegion(
            onHover: (eve) {
              setState(() {
                pointer = eve.position;
              });
            },
            child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    Center(
                        child: Stack(children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image:
                                    Image.asset(backdrop, gaplessPlayback: true)
                                        .image)),
                      ),
                      if (timerCount > 2)
                        Center(
                          child: Container(
                              margin: EdgeInsets.only(
                                  top: SizeConfig.screenHeight * 0.075),
                              width: SizeConfig.screenHeight,
                              height: SizeConfig.screenHeight,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover, image: login)),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                      width: 1125,
                                      height: 2436,
                                      child: Center(
                                          child: Stack(children: [
                                        Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 380,
                                                  height: 40,
                                                  child: TextField(
                                                    autofocus: true,
                                                    obscureText: true,
                                                    controller: _controller,
                                                    focusNode: myFocusNode,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 30,
                                                    ),
                                                    decoration: null,
                                                    cursorColor: Colors.black,
                                                  )),
                                              Center(
                                                  child: SizedBox(
                                                width: 255,
                                                height: 35,
                                                child: Material(
                                                    color: Colors.transparent,
                                                    child: InkWell(
                                                      onTap: () {},
                                                      onHover: (isHovering) {
                                                        if (isHovering) {
                                                          setState(() {
                                                            login = loginHint;
                                                          });
                                                        } else if (login ==
                                                            loginHint) {
                                                          setState(() {
                                                            login = loginMain;
                                                          });
                                                        }
                                                      },
                                                    )),
                                              )),
                                              const SizedBox(height: 20),
                                            ]),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 205,
                                            ),
                                            Center(
                                                child: SizedBox(
                                              width: 180,
                                              height: 45,
                                              child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      checkLogin();
                                                    },
                                                    onHover: (isHovering) {
                                                      if (isHovering) {
                                                        setState(() {
                                                          login = okHover;
                                                        });
                                                      } else if (login ==
                                                          okHover) {
                                                        setState(() {
                                                          login = loginMain;
                                                        });
                                                      }
                                                    },
                                                  )),
                                            ))
                                          ],
                                        )
                                      ]))))),
                        ),
                      //if (flicker)
                      //Container(
                      //width: SizeConfig.screenWidth,
                      //height: SizeConfig.screenHeight,
                      //decoration: BoxDecoration(
                      //image: DecorationImage(
                      //fit: BoxFit.fill,
                      //image: Image.asset(flickerImg).image)),
                      //),
                    ])),
                    if (timerCount < 2)
                      Positioned(
                          left: pointer.dx,
                          top: pointer.dy,
                          child: Image.asset(pointerIcon)),
                  ],
                ))));
  }
}

class MyDesktop extends StatefulWidget {
  const MyDesktop({Key? key}) : super(key: key);
  @override
  State<MyDesktop> createState() => _MyDesktopState();
}

class _MyDesktopState extends State<MyDesktop> {
  late String backdrop;
  String newBackdrop = "desktopFilled.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConstrainedBox(
        constraints: BoxConstraints.tight(
            Size(SizeConfig.screenWidth, SizeConfig.screenHeight)),
        child: Container(
            color: Colors.white,
            child: Stack(
              children: [
                Center(
                    child: Stack(children: [
                  Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.screenHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.asset(newBackdrop, gaplessPlayback: true)
                                .image)),
                  ), const Text("test")
                  //Center(
                    //child: Container(
                        //margin: EdgeInsets.only(
                            //top: SizeConfig.screenHeight * 0.075),
                        //width: SizeConfig.screenHeight,
                        //height: SizeConfig.screenHeight,
                        //decoration: BoxDecoration(
                            //image: DecorationImage(
                                //fit: BoxFit.cover, image: login
                            //)
                        //),
                    
                //))
                ],
            ))]))));
  }
}
