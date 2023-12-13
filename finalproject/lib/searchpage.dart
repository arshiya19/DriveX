import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.userSearch}) : super(key: key);

  final String userSearch;
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final searchController = TextEditingController();
  late LatLng picked;
  @override
  void initState() {
    super.initState();
    searchController.text = widget.userSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
            child: Column(
              children: <Widget>[
                       const SizedBox(height: 20),
                       placesAutoCompleteTextField(),
                Expanded(
                  child: Container(), // Add your main content here
                ),
                       Padding(padding: const EdgeInsets.all(16.0), // Adjust the padding as needed
                       child: Align(
                       alignment: Alignment.bottomCenter,
                       child: ElevatedButton(
                              onPressed:(){if(searchController.text.isEmpty){
                                Navigator.of(context).pop({'location': searchController.text, 'latLng': const LatLng(0.0,0.0)});}
                         else{Navigator.of(context).pop({'location': searchController.text, 'latLng': picked});}},
                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                       child: const Text("Search", style:TextStyle(color: Colors.black87))),
        ),
      )])
    ));
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 100.0), // Adjust the value as needed
            child: Align(alignment: Alignment.centerLeft, child: Text('Search')),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 100.0), // Adjust the value as needed
              child:Align(alignment: Alignment.centerRight,
            child: GestureDetector(
            onTap: () {
              searchController.clear();
            },
              child: const Text('Clear'),
          ),
         ))
        ],
      ),
    );
  }
//https://pub.dev/packages/google_places_flutter/example
  placesAutoCompleteTextField() {
    return
      Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // TextField(
      child:
        GooglePlaceAutoCompleteTextField(
        textEditingController: searchController,
        googleAPIKey: "AIzaSyC0VfkDfuJHQAFttjRzJ8za5ZJRbjkRYq4",
        inputDecoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search Location',
          contentPadding: EdgeInsets.all(8.0),
        ),
        debounceTime: 200,
        countries: const ["in", "us"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction){
          if (prediction.lat != null) {
            double latitude = double.tryParse(prediction.lat.toString()) ?? 0.0;
            double longitude = double.tryParse(prediction.lng.toString()) ?? 0.0;
            picked = LatLng(latitude, longitude);
          }
        },
        itemClick: (Prediction prediction){
          searchController.text = prediction.description ?? "";
          searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          FocusScope.of(context).requestFocus(FocusNode());
        },
        seperatedBuilder: const Divider(),
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(
                  width: 7,
                ),
                Expanded(child: Text(prediction.description??""))
              ],
            ),
          );
        },
        isCrossBtnShown: false,
        // default 600 ms ,
      ),
    );
  }
}
