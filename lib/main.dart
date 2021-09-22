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
          scaffoldBackgroundColor: Colors.white,
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

  String loadingIcon = 'images/loading.png';
  String backdrop = 'images/backdrop.png';
  String login = 'images/login.png';
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

  @override
  void initState() {
    super.initState();
    pointerIcon = loadingIcon;
    Timer.periodic(const Duration(milliseconds: 100), changeBackdrop);
    Timer.periodic(const Duration(seconds: 1), (_) {
      ++timerCount;
    });
    _controller = TextEditingController();
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
                                image: Image.asset(backdrop).image)),
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
                                      fit: BoxFit.cover,
                                      image: Image.asset(login).image)),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: 1125,
                                    height: 2436,
                                    child: Center(
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: 380,
                                            height: 97,
                                            child: TextField(
                                              obscureText: true,
                                              controller: _controller,
                                              focusNode: myFocusNode,
                                              style: const TextStyle(color: Colors.black, fontSize: 30,  ),
                                              decoration: null,
                                              cursorColor: Colors.black,
                                            )
                                          ),
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Center(
                                              child: Container(
                                                width: 300,
                                                height: 30,
                                                decoration: BoxDecoration(border: Border.all())
                                              )
                                              )
                                            ]
                                          )
                                        ]
                                      )
                                    )
                                  )
                              )
                          ),
                        ),
                      if (flicker)
                        Container(
                          width: SizeConfig.screenWidth,
                          height: SizeConfig.screenHeight,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: Image.asset(flickerImg).image)),
                        ),
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
