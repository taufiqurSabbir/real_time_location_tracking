import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() {
  runApp(const Map_location());
}

class Map_location extends StatelessWidget {
  const Map_location({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  LocationData? inilocation;
  LocationData? currentlocation;
  LocationData? cbtroad;

  Future<void> mycurrentlocation() async {
    inilocation = await Location.instance.getLocation();
    if (mounted) {
      setState(() {});
    }
  }
  List <LocationData> locations=[];

  void livelocationchage() {
    Location.instance.onLocationChanged.listen((location) {
      currentlocation = location;
      locations.add(location);
      if (mounted) {
        setState(() {});
      }
    });
  }


  @override
  void initState() {
    mycurrentlocation();
    livelocationchage();
    if (inilocation == null) {
      mycurrentlocation();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for(var location in locations){
      cbtroad=location;
    }
    return Scaffold(

      appBar: AppBar(
        title: Text('Real-Time Location Tracker'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 15,
          target: LatLng(inilocation!.latitude!, inilocation!.longitude!),

        ),
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: true,

        markers: <Marker>{
          Marker(

              markerId: MarkerId('mark_1'),
              position: LatLng(inilocation!.latitude!, inilocation!.longitude!)),

          inilocation  != currentlocation ?


            Marker(
                infoWindow: InfoWindow(title: 'Current Location'),
                markerId: MarkerId('mark_2'),
                position: LatLng(currentlocation!.latitude!, currentlocation!.longitude!))




              :  Marker(
              markerId: MarkerId('mark_1'),
              position: LatLng(inilocation!.latitude!, inilocation!.longitude!)),
        },
        polylines: <Polyline>{
          Polyline(
              polylineId: PolylineId('polyline_1'),
              color: Colors.lightBlue,
              jointType: JointType.round,
              width: 7,
              onTap: () {
                print('tapped on polyline');
              },
              points: [
                LatLng(inilocation!.latitude!, inilocation!.longitude!),
                LatLng(cbtroad!.latitude!, cbtroad!.longitude!),
                LatLng(currentlocation!.latitude!, currentlocation!.longitude!),
              ])
        },
      ),
    );
  }
}
