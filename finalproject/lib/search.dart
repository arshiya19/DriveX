import 'dart:async';
import 'searchpage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'list.dart';
import 'carDetail.dart';
//https://docs.flutter.dev/cookbook/effects/nested-nav
class Search extends StatefulWidget {
  static SearchState of(BuildContext context) {
    return context.findAncestorStateOfType<SearchState>()!;
  }
  const Search({super.key,required this.setupPageRoute, required this.loaded, required this.position});

  final String setupPageRoute;
  final bool loaded;
  final LatLng position;
  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  bool _isTapped = false, isSearched = false, _isLoading = true;
  final  _controller = TextEditingController();
  late Map<String, dynamic> place;
  // final LatLng _searchedPosition = const LatLng(39.7278851, -121.845067);
  late LatLng _currentPosition ,_searchedPosition;

  @override
  void initState() {
    super.initState();
    _isLoading = widget.loaded;
    _currentPosition = widget.position;
  }

  void _onListSelected(){
    if(!_isTapped){
      setState(() {
        _isTapped = !_isTapped;
        _navigatorKey.currentState!.pushNamed('/list');
      });}
    else{
      setState(() {
        _isTapped = !_isTapped;
        _navigatorKey.currentState!.pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: widget.setupPageRoute,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }
  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    if (settings.name == '/') {
      if(isSearched==true){
        page = Googlemap(loaded: _isLoading, position: _searchedPosition, searched: isSearched,
                         onListSelected: _onListSelected);
      }else{
        page = Googlemap(loaded: _isLoading, position: _currentPosition, searched: isSearched,
                         onListSelected: _onListSelected);}
    }
    if (settings.name == '/list') {
      page = const CarListPage();

      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        settings: settings, // Pass the settings to the PageRouteBuilder
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset(0.0,0.0);
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(position: offsetAnimation, child: child);
        },
      );

    }

    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      settings: settings, // Pass the settings to the PageRouteBuilder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );

  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      title: Row(
        children: [
          SizedBox(
            width: 298,
            height: 34,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                filled: true,
                fillColor: Colors.white,
                hintText: 'Choose Location',
                contentPadding: EdgeInsets.all(8.0),
              ),
              readOnly: true,
              onTap: ()  async {
                //https://docs.flutter.dev/cookbook/navigation/returning-data
                  place = await Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SearchPage(userSearch: _controller.text); // Default to FirstRoute if the route is unknown.
                    },
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      const Offset begin = Offset(1.0, 0.0);
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
                );
                  if (place.containsKey('location') && place.containsKey('latLng')) {
                    _controller.text = place['location'];
                    if(_controller.text.isNotEmpty){
                      setState(() {
                        isSearched = true;
                        _searchedPosition = place['latLng'];
                        _navigatorKey.currentState!.pushNamed('/');
                      });
                    }else{setState(() {
                      isSearched = false;
                      _navigatorKey.currentState!.pushNamed('/');});}
                }
              }
            ),
          ),
          GestureDetector(
            onTap: _onListSelected,
            child: Padding(
              padding:  const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(_isTapped ? 'Map' : 'List',
                style:  const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

//https://codelabs.developers.google.com/codelabs/google-maps-in-flutter#0
class Googlemap extends StatefulWidget {
  const Googlemap({super.key, required this.loaded, required this.position,
                   required this.searched, required this.onListSelected,
  });

  final void Function() onListSelected;

  final bool loaded, searched ;
  final LatLng position;

  @override
  State<Googlemap> createState() => Googlemapstate();
}

class Googlemapstate extends State<Googlemap>{

  Completer<GoogleMapController> mapController = Completer();
  final geo = GeoFlutterFire();
  late Set<Marker> _markers = {};
  bool _isLoading = false, _isSearched = false;
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _isSearched = widget.searched;
    _isLoading = widget.loaded;
    _currentPosition = widget.position;
  }

//https://pub.dev/packages/geoflutterfire2 and GPT
  Future<List<GeoFirePoint>> getNearbyLocations() async {
    CollectionReference geoCollection = FirebaseFirestore.instance.collection('geoCollection');
    List<GeoFirePoint> geoPoints = [];

    try {
      QuerySnapshot querySnapshot = await geoCollection.get();

      for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

        GeoPoint latlng = data['latlng'];

        GeoFirePoint geoFirePoint = GeoFirePoint(latlng.latitude, latlng.longitude);
        geoPoints.add(geoFirePoint);

        print("Document ID: ${documentSnapshot.id}");
        print("Latitude : ${latlng.latitude}, Longitude : ${latlng.longitude}");
      }
    } catch (e) {
      print("Error getting documents: $e");
    }

    return geoPoints;
  }



    void setInitialLocation() {
    mapController.future.then((controller) {
      controller.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    });
    }


  void updateMarkers(LatLng currentPosition) async {
    List<GeoFirePoint> nearbyLocations = await getNearbyLocations();
    Set<Marker> markers = nearbyLocations.map((GeoFirePoint geoPoint) {
      return Marker(
        markerId: MarkerId(geoPoint.hash),
        position: LatLng(geoPoint.latitude, geoPoint.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        // Customize the marker as needed.
      );
    }).toSet();

    setState(() {
      _markers = markers;
      final pickedLocatation = Marker(
        markerId: const MarkerId("1"),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            widget.onListSelected();
          }
      );
      _markers.add(pickedLocatation);
    });
  }


  void _onMapCreated(GoogleMapController controller){

    mapController.complete(controller);
    if(_isSearched){
      updateMarkers(_currentPosition);
    }
    else{
    final userLocation = Marker(
      markerId: const MarkerId("1"),
      position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      onTap: () {
            widget.onListSelected();
      }
    );
    setState(() {
      _markers.add(userLocation);
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Stack(
          children: <Widget>[
            _buildGoogleMap(),
            _buildLocationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGoogleMap() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        :
    GoogleMap(
      mapType: MapType.normal,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 16.0,
      ),
      markers: _markers,
      zoomControlsEnabled: false,
    );
  }


  Widget _buildLocationButton() {
    if (!_isLoading) {
      return Align(
        alignment: Alignment.topRight,
        child: Container(
          height: 60,
          width: 60,
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: 'recenter',
            onPressed: setInitialLocation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Color(0xFFECEDF1)),
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.grey,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
