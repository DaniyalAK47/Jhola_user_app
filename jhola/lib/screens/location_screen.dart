import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jhola/provider/courier_location.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:provider/provider.dart';
import './../provider/current_location.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key key}) : super(key: key);

  static const routeName = '/location_screen';

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  var _loadingData = false;
  String currentLat;
  String currentLong;
  double markerLat;
  double markerLong;
  String screenType;

  @override
  void didChangeDependencies() {
    if (!_loadingData) {
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      currentLat = routeArgs['lat'];
      currentLong = routeArgs['long'];
      markerLat = double.parse(routeArgs['lat']);
      markerLong = double.parse(routeArgs['long']);
      screenType = routeArgs['screen'];
      print(currentLong);
      print(currentLat);
      _loadingData = true;
    }
    super.didChangeDependencies();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    setState(() {
      _markers.add(
        Marker(
          draggable: true,
          position: LatLng(double.parse(currentLat), double.parse(currentLong)),
          markerId: MarkerId('0'),
        ),
      );
    });
  }

  void _updatePosition(CameraPosition _position) {
    Position newMarkerPosition = Position(
      latitude: _position.target.latitude,
      longitude: _position.target.longitude,
    );
    Marker marker = _markers.elementAt(0);
    markerLat = newMarkerPosition.latitude;
    markerLong = newMarkerPosition.longitude;

    setState(() {
      Marker markerNew = marker.copyWith(
        positionParam:
            LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude),
      );
      _markers.clear();
      _markers.add(markerNew);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onCameraMove: (_position) {
              _updatePosition(_position);
            },
            markers: _markers,
            myLocationEnabled: true,
            onMapCreated: (controller) {
              _onMapCreated(controller);
            },
            initialCameraPosition: CameraPosition(
              target:
                  LatLng(double.parse(currentLat), double.parse(currentLong)),
              zoom: 15,
            ),
          ),
          Positioned(
            bottom: 15,
            left: 150,
            child: Column(
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Map<String, double> selectedLocation = {
                      'lat': markerLat,
                      'long': markerLong
                    };
                    if (screenType == "signup") {
                      Provider.of<CurrentLocation>(context, listen: false)
                          .updateLocation(selectedLocation);
                      Navigator.of(context).pop();
                    }
                    if (screenType == "pickup") {
                      print("helooo from pickup if");
                      Provider.of<CourierLocation>(context, listen: false)
                          .setPickUp(selectedLocation["lat"].toString(),
                              selectedLocation["long"].toString());
                      Navigator.of(context).pop();
                    }
                    if (screenType == 'delivery') {
                      Provider.of<CourierLocation>(context, listen: false)
                          .setDelivery(selectedLocation["lat"].toString(),
                              selectedLocation["long"].toString());
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Select'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
