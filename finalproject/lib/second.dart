import 'package:flutter/material.dart';
import 'package:finalproject/drawer.dart';

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Matches'),
      // ),
      drawer: getDrawer(context),
      body: Center(
        child: Container(
          height: 555.0,
          width: 444.0,
          color: Colors.grey[200],
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ElevatedButton(
                child: const Text('Go back!'),
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/');
                },
              ),]
          ),
        ),
      ),
    );
  }
}
