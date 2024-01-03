import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MinimalPage extends StatefulWidget {
  const MinimalPage({super.key});

  @override
  State<MinimalPage> createState() => _MinimalPageState();
}

class _MinimalPageState extends State<MinimalPage> {

  final searchController = TextEditingController();
  late LatLng picked;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Center(
            child: Column(
                children: <Widget>[
                  TextField(decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.near_me_rounded, size: 40,),
                    prefixIconColor: Colors.greenAccent,
                    hintText: '      Now . Nearby',
                    hintStyle: TextStyle(fontSize: 20)),
                    readOnly: true,
                    onTap:(){FocusScope.of(context).requestFocus(FocusNode());}
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40.0), // Adjust the value as needed
                    child: Divider()),
                  Stack(
                    children: <Widget>[
                      TextField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.watch_later_outlined, size: 40, color: Colors.greenAccent),
                          hintText: '      Recent',
                          hintStyle: TextStyle(fontSize: 20),
                          suffixIcon: Icon(Icons.chevron_right, size:40),
                        ),
                        readOnly: true,
                        onTap:(){FocusScope.of(context).requestFocus(FocusNode());},
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 80.0, top: 40.0),  // Adjust the padding as needed
                        child: Text('Recent Search', style: TextStyle(fontSize: 15)),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 30.0), // Adjust the value as needed
                    child: Divider()),
                  TextField(decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search_outlined, size:40),
                      prefixIconColor: Colors.greenAccent,
                      hintText: '      Select location and time',
                      hintStyle: TextStyle(fontSize: 20),
                      suffixIcon: Icon(Icons.chevron_right, size:40))
                      ,readOnly: true,
                      onTap:(){FocusScope.of(context).requestFocus(FocusNode());}),
                ])
        ));
  }


  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title:
      const Padding(padding: EdgeInsets.only(left: 0.0),
        child: Align(alignment: Alignment.centerLeft, child: Text('Find a Zipcar')),
          ),
      elevation: 0.0,
      );
  }

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
