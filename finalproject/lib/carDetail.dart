/*
  1. Adjusted paddings with Chatgpt
  2. For code syntax took help from Chatgpt
*
*/


import 'drive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'message.dart';
import 'list.dart';

class Cardetails extends StatelessWidget {
  const Cardetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan),
      ),
      home: const MyHomePage(title: 'DriveX'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final String coming = "";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String input = "";
  bool password = false;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CarListPage()));
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Honda CR-V",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/drivecar.png'),
                  // fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Trip Dates',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            Container(
              margin: const EdgeInsets.all(9),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Pick Up :             00:00:00',
                      textAlign: TextAlign.start,
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(9),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Drop off :            00:00:00',
                      textAlign: TextAlign.start,
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(9),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Price :         \$ 0.0',
                      textAlign: TextAlign.start,
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const Divider(color: Colors.black),
            const Text(
              'Hosted By :  ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  child: const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ' Charan ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        ' 20 trips . Joined Aug 2021 ',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Image.asset('assets/inbox.png'),
                  iconSize: 50,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return const ChatDetailPage();
                        }));
                  },
                )
              ],
            ),
            const Text(
              'Total Amount :  ',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Drivepage(),
                  ),
                );
              },
              child: const Text('BOOK'),
            ),
          ],
        ),
      ),
    );
  }
}