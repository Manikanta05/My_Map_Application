import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';

void main() => runApp(MyApp());

const kGoogleApiKey = "AIzaSyD5vvzPN5jyt06dFAqXuGKyd7FpfXFieaU";

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Marker> allMarkers = [];
Position _currentPosition;
  GoogleMapController _controller;
  String searchAddr;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    }
  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId);
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;
      print(lat);
      print(lng);
      allMarkers.add(Marker(
          markerId: MarkerId('myMarker2'),
          position: LatLng(lat,lng)));
      GoogleMap( initialCameraPosition:
      CameraPosition(target: LatLng(lat,lng), zoom: 13.0),
          markers: Set.from(allMarkers),
          onMapCreated: mapCreated);
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat,lng),
            zoom: 13.0,
          )));
      setState(() {

      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Maps'),
      ),
      body: Stack(
          children: [Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: GoogleMap(
              initialCameraPosition:
              CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12.0),
              markers: Set.from(allMarkers),
              onMapCreated: mapCreated,
            ),
          ),

            Align(
              alignment: Alignment.centerRight,
              child: InkWell(

                onTap:(){
                  _getCurrentLocation();
                  GoogleMap(
                  markers: Set.from(allMarkers),
                  onMapCreated: mapCreated);
                   },

                child: Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.green
                  ),
                  child: Icon(Icons.my_location, color: Colors.white),

                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
                child: RaisedButton(
                  onPressed: _handlePressButton,
                  color: Colors.white,
                   child: Text("                     Search places here !                      ",
                     style: TextStyle(color: Color(0xff238c00))),
                   ),
                ),
          ]
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
/*Save locations using function
  movetoJSS() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(12.9029,77.5046), zoom: 20.0, bearing: 45.0, tilt: 45.0),
    ));
  }

 */
  movetoblr() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12.0, bearing: 45.0, tilt: 45.0),
    ));
  }
  _getCurrentLocation(){

    final Geolocator geolocator=Geolocator()..forceAndroidLocationManager;
    geolocator
    .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
    .then((Position position){
      setState(() {
        _currentPosition=position;
      });
      allMarkers.add(Marker(
          markerId: MarkerId('myMarker1'),

          position: LatLng(_currentPosition.latitude,_currentPosition.longitude)));

      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(_currentPosition.latitude,_currentPosition.longitude), zoom: 15.0, bearing: 45.0, tilt: 45.0),
      ));
    }).catchError((e){
      print(e);
    });
  }
  void onError(PlacesAutocompleteResponse response) {
    print(response.errorMessage);
  }
  Future<void> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
    );
    displayPrediction(p);
  }
}