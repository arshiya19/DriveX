/*

1. Referred this blog https://www.freecodecamp.org/news/build-a-chat-app-ui-with-flutter/

*/


import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                IconButton(onPressed: () {Navigator.pop(context);},
                  icon: const Icon(Icons.arrow_back, color: Colors.black),),
                const SizedBox(width: 2),
                const CircleAvatar(backgroundImage: AssetImage('assets/profile.jpg'),maxRadius: 20,),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Charan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text("Online", style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children:[
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
              height: 60,
              color: Colors.white,
              child: Row(
                children: [
                  const SizedBox(width: 15,),
                  const Expanded(
                    child: TextField(decoration: InputDecoration(hintText: "Write message...",),),
                  ),
                  const SizedBox(width: 15,),
                  FloatingActionButton(
                    onPressed: (){},
                    child: const Icon(Icons.arrow_circle_right_outlined,size: 28,),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}