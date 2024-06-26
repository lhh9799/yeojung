import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:front/const/colors/Colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart' as lottie;
import '../../repository/api/ApiMyPage.dart';

class GroupMap extends StatefulWidget {
  final String description;
  final int groupId;

  const GroupMap({
    required this.description,
    required this.groupId,
    super.key,
  });

  @override
  State<GroupMap> createState() => _GroupMapState();
}

class _GroupMapState extends State<GroupMap> {
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  bool isLocationLoaded = false;
  final Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getGroupMap();
  }

  void getGroupMap() async {
    try {
      Response res = await getGroupLocationList(widget.groupId);
      print(res.data);
      List<dynamic> locations = res.data;
      List<LatLng> polylineCoordinates = [];

      for (var locationMap in locations) {
        String location = locationMap['location'];
        List<Location> geolocations = await locationFromAddress(location);
        if (geolocations.isNotEmpty) {
          LatLng latLng = LatLng(geolocations.first.latitude, geolocations.first.longitude);
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId(location),
                position: latLng,
                infoWindow: InfoWindow(title: locationMap['storeName']),
              ),
            );
            polylineCoordinates.add(latLng);
          });
        }
      }

      setState(() {
        if (polylineCoordinates.isNotEmpty) {
          polylines.add(Polyline(
            polylineId: PolylineId('group_map_polyline'),
            points: polylineCoordinates,
            color: PRIMARY_COLOR,
            width: 5,
          ));
        }
        isLocationLoaded = true;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.description}"),
      ),
      body: isLocationLoaded
          ? GoogleMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: CameraPosition(
                target: markers.isNotEmpty ? markers.first.position : LatLng(35.202740932924, 126.80713293526),
                zoom: 15.0,
              ),
              markers: markers,
              polylines: polylines,
            )
          : Center(child: lottie.Lottie.asset('assets/lotties/orangewalking.json')),
    );
  }
}
