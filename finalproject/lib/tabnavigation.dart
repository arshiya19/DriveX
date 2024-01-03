import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'search.dart';
import 'drive.dart';
import 'trips.dart';
import 'profile.dart';
//https://github.com/Kickbykick/Persistent-Bottom-Navigation-Bar/blob/master/lib/app.dart
class TabNavigator extends StatelessWidget {
  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
    required this.loaded,
    required this.position
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  final bool loaded;
  final LatLng position;

  @override
  Widget build(BuildContext context) {

    late Widget child ;
    if(tabItem == "Search") {
      //https://docs.flutter.dev/cookbook/effects/nested-nav
       child = Search(setupPageRoute: '/', loaded: loaded, position: position);}
    else if(tabItem == "Drive"){
      child = const Drivepage();}
    else if(tabItem == "Inbox"){
      child = const Inbox();}
    else if(tabItem == "Trips"){
      child = const Tripspage();}
    else if(tabItem == "Profile"){
      child = const Profilepage();}

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child,
        );
      },
    );
  }
}

class Drive extends StatelessWidget {
  const Drive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("DriveX Drive Tab",style:TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);

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

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String input = "";
  bool password = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Inbox",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                contentPadding: const EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Image.asset('assets/Inboxpage.png'),
          ],
        ),
      ),
    );
  }
}

class Trips extends StatelessWidget {
  const Trips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("DriveX Trips Tab",style:TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

// class Profile extends StatelessWidget {
//   const Profile({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text("DriveX Profile Tab",style:TextStyle(fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
// }