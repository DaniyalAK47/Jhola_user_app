import 'dart:collection';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/provider/order.dart';
import 'package:provider/provider.dart';
import './../provider/current_location.dart';

class TrackingOrderScreen extends StatefulWidget {
  const TrackingOrderScreen({Key key}) : super(key: key);

  static const routeName = '/tracking_order_screen';

  @override
  _TrackingOrderScreenState createState() => _TrackingOrderScreenState();
}

class _TrackingOrderScreenState extends State<TrackingOrderScreen> {
  GoogleMapController _mapController;
  Set<Marker> _markers = HashSet<Marker>();
  // var _loadingData = false;
  String userLat;
  String userLong;
  // double markerLat;
  // double markerLong;
  String riderLat;
  // = '33.4961809';
  String riderLong;
  // = '73.0856454';
  String assignTo;
  String orderId;
  bool initData = true;
  bool _loading = false;

  @override
  void initState() {
    var userLocation = Provider.of<CurrentLocation>(context, listen: false);
    userLat = userLocation.latitude.toString();
    userLong = userLocation.logitude.toString();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (initData) {
      setState(() {
        _loading = true;
      });
      final routeArgs =
          ModalRoute.of(context).settings.arguments as Map<String, String>;
      orderId = routeArgs['orderId'];
      assignTo =
          await Provider.of<Order>(context, listen: false).getAssignTo(orderId);
      print(assignTo);
      if (assignTo != "null") {
        print("i am not suppose to be here");
        Map<String, String> riderLocation =
            await Provider.of<CurrentLocation>(context, listen: false)
                .getRiderLocation(assignTo);

        riderLat = riderLocation['riderLat'].toString();
        riderLong = riderLocation['riderLong'].toString();
        print(riderLat);
        print(riderLong);
      } else {
        riderLat = userLat;
        riderLong = userLong;
      }
      setState(() {
        _loading = false;
      });
    }
    initData = false;

    super.didChangeDependencies();
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController = controller;

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/rider_map.png', 100);

    setState(() {
      _markers.add(
        Marker(
          draggable: false,
          position: LatLng(double.parse(userLat), double.parse(userLong)),
          markerId: MarkerId('0'),
        ),
      );

      _markers.add(
        Marker(
          draggable: false,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position: LatLng(double.parse(riderLat), double.parse(riderLong)),
          markerId: MarkerId('1'),
        ),
      );
    });
  }

  Future<Map<String, String>> gettingValue() async {
    Map<String, String> riderLocation =
        await Provider.of<CurrentLocation>(context, listen: false)
            .getRiderLocation(assignTo);

    return riderLocation;
  }

  Future<void> _updatePosition() async {
    Map<String, String> riderLocation = await gettingValue();

    Position newMarkerPosition = Position(
      latitude: double.parse(riderLocation['riderLat']),
      longitude: double.parse(riderLocation['riderLong']),
    );
    print(riderLocation['riderLat']);
    print(riderLocation['riderLong']);

    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/rider_map.png', 100);

    _markers.removeWhere((element) => element.markerId == MarkerId('1'));

    setState(() {
      _markers.add(
        Marker(
          draggable: false,
          icon: BitmapDescriptor.fromBytes(markerIcon),
          position:
              LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude),
          markerId: MarkerId('1'),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : assignTo == "null"
              ? Center(
                  child: Text("A rider is not assigned to you..."),
                )
              : GoogleMap(
                  onTap: (argument) {
                    _updatePosition();
                  },
                  markers: _markers,
                  myLocationEnabled: true,
                  onMapCreated: (controller) {
                    _onMapCreated(controller);
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                        LatLng(double.parse(riderLat), double.parse(riderLong)),
                    zoom: 15,
                  ),
                ),
    );
  }
}
