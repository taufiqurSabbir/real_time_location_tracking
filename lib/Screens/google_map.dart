
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  final location = Location.instance;
   late LatLng inilocation;
  LatLng Updatelocation = LatLng(0, 0);
  List<LatLng> polylinesco=[];
  GoogleMapController? _mapController;

  Future<void> getinilocation() async {
    LocationData loc = await location.getLocation();
    inilocation = LatLng(loc.latitude!, loc.longitude!);
    polylinesco.add(LatLng(loc.latitude!, loc.longitude!));
    locationupdate();
    if(mounted){
      setState(() {});
    }
  }

  void locationupdate(){
    location.onLocationChanged.listen((location) {
      Updatelocation = LatLng(location.latitude!, location.longitude!);
      print(Updatelocation);
      polylinesco.add(Updatelocation);
      location_time_update();
      if(mounted){
        setState(() {});
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapController!.animateCamera(CameraUpdate.newLatLng(inilocation));

  }

  void location_time_update() async{
    if(await location.serviceEnabled()){
      location.changeSettings(
          interval: 10000
      );
    }else{
      location.requestPermission();
    }

  }

  @override
  void initState() {
    getinilocation();
    super.initState();
    getinilocation();
  }


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        onMapCreated:_onMapCreated ,
        initialCameraPosition: CameraPosition(

      target: inilocation,
      zoom: 15
    ),

    markers: <Marker>{
     Marker(
       markerId: MarkerId('mark_1'),
       position: inilocation,
     ),
      inilocation!=Updatelocation ?  Marker(
          markerId: MarkerId('mark_2'),
          position: Updatelocation,
          infoWindow: InfoWindow(
              title: 'My current location',
              snippet: 'Lat: ${Updatelocation.latitude}, Lng: ${Updatelocation.longitude}'
          )
      ) :  Marker(
          markerId: MarkerId('mark_2'),
          visible: false,
          position: Updatelocation,
          infoWindow: InfoWindow(
              title: 'My current location',
              snippet: 'Lat: ${inilocation.latitude}, Lng: ${inilocation.longitude}'
          )
      )
    },

    polylines: <Polyline>{
          Polyline(
            polylineId: PolylineId('poli_1'),
            points: polylinesco,
            color: Colors.blue,
            width: 7,
          )
    },

      circles: <Circle>{
          Circle(
            circleId: CircleId('circle_1'),
            center: Updatelocation,
            fillColor: Colors.blue.shade100,
            radius: 180,
            strokeColor:Colors.blue.shade100
          )
      },
    );
  }
}
