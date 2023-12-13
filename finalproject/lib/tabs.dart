import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tabnavigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

//https://github.com/Kickbykick/Persistent-Bottom-Navigation-Bar/blob/master/lib/app.dart
class HomePage extends StatefulWidget {
  HomePage({super.key, required this.loaded, required this.position, this.googleUser1});
  GoogleSignInAccount? googleUser1;

  final bool loaded;
  final LatLng position;

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  bool typing = false;
  String _currentPage = "Search";
  List<String> pageKeys = ["Search", "Drive", "Inbox", "Trips", "Profile"];
  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "Search": GlobalKey<NavigatorState>(),
    "Drive": GlobalKey<NavigatorState>(),
    "Inbox": GlobalKey<NavigatorState>(),
    "Trips": GlobalKey<NavigatorState>(),
    "Profile": GlobalKey<NavigatorState>(),
  };
  int _selectedIndex = 0;

  void _selectTab(String tabItem, int index){
    if(tabItem == _currentPage ){
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    }else {
      setState(() {
        _currentPage = pageKeys[index];
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.grey[200],
      ),
      home: Scaffold(
          body: Center(
            child: Stack(
              children: <Widget>[
                _buildOffstageNavigator("Search"),
                _buildOffstageNavigator("Drive"),
                _buildOffstageNavigator("Inbox"),
                _buildOffstageNavigator("Trips"),
                _buildOffstageNavigator("Profile")
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: (int index) { _selectTab(pageKeys[index], index); },
            currentIndex: _selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.key),
                label: 'Drive',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: 'Trips',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile',
              ),
            ],
            selectedItemColor: Colors.pink,
            unselectedItemColor : Colors.blueGrey,
            showUnselectedLabels: true,
            elevation: 0.5,
            // onTap: _onItemTapped,
          )
      ),
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
          navigatorKey: _navigatorKeys[tabItem]!,
          tabItem: tabItem,
          loaded: widget.loaded,
          position: widget.position
      ),
    );
  }
}