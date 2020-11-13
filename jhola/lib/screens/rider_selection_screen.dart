import 'package:flutter/material.dart';
import 'package:jhola/provider/current_location.dart';
import 'package:jhola/provider/names.dart';
import './../provider/rider.dart';
import 'package:provider/provider.dart';

class RiderSelectScreen extends StatefulWidget {
  RiderSelectScreen({Key key}) : super(key: key);

  static const routeName = "/route_name";

  @override
  _RiderSelectScreenState createState() => _RiderSelectScreenState();
}

class _RiderSelectScreenState extends State<RiderSelectScreen> {
  List<RiderItem> rider;
  String userId;
  bool _loading = false;

  double userLat;
  double userLng;

  double riderLat;
  double riderLng;

  // @override
  // void initState() {
  //   super.initState();
  //   Provider.of<Rider>(context, listen: false).fetchAndSetRider();
  // }

  @override
  void didChangeDependencies() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<Rider>(context, listen: false).fetchAndSetRider();
    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    userLat = Provider.of<CurrentLocation>(context, listen: false).latitude;
    userLng = Provider.of<CurrentLocation>(context, listen: false).logitude;
    rider = Provider.of<Rider>(context, listen: false).getRider;
    print(rider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Rider"),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rider.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Provider.of<Rider>(context, listen: false)
                          .selectingRider(rider[index].riderId);
                      Navigator.of(context).pop();
                    },
                    title: Text(
                      rider[index].riderName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(rider[index].riderPhoneNo),
                    trailing: Text(
                        '${Provider.of<Names>(context).calculateDistance(userLat, userLng, rider[index].riderLat, rider[index].riderLng).toStringAsFixed(0)}km'),
                  );
                },
              ),
            ),
    );
  }
}
