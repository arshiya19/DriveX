/*
  Took reference from Geekforgeeks https://www.geeksforgeeks.org/splash-screen-in-flutter/
*/


import 'dart:async';
import 'package:finalproject/login.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const login(); // Default to FirstRoute if the route is unknown.
            },
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const Offset begin = Offset(0.0, 0.0);
              const Offset end = Offset(0.0,0.0);
              // const Offset end = Offset(0.0,0.0);
              const Curve curve = Curves.ease;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child : Center(
            child: Image.asset(
                'assets/dx logo.png',
                height:MediaQuery.of(context).size.height)
        ));
  }
}