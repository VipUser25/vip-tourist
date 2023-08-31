import 'package:flutter/material.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';

import '../../../logic/utility/constants.dart';

class MeetingPointScreen extends StatefulWidget {
  const MeetingPointScreen(
      {Key? key, required this.latLng, required this.tourName})
      : super(key: key);
  final LatLng latLng;
  final String tourName;

  @override
  _MeetingPointScreenState createState() => _MeetingPointScreenState();
}

class _MeetingPointScreenState extends State<MeetingPointScreen> {
  Completer<GoogleMapController> _controller = Completer();
  bool notUsed = true;
  bool loaded = false;
  String? country;
  String? area;
  String? street;
  String? placeName;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (notUsed) {
      loadAddress();
      notUsed = false;
    }
    print("LAT LONG CHECKING BELLO!");
    print(widget.latLng.latitude);
    print(widget.latLng.longitude);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).meetingPoint,
        ),
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          elevation: 2,
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: GREEN_BLACK,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 1.719,
            width: double.maxFinite,
            child: Scaffold(
              body: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                initialCameraPosition:
                    CameraPosition(target: widget.latLng, zoom: 14.4746),
                mapType: MapType.normal,
                markers: {
                  Marker(
                    markerId: MarkerId("currentMarket"),
                    position: widget.latLng,
                    infoWindow: InfoWindow(
                        title:
                            S.of(context).placeOfThe + " " + widget.tourName),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              S.of(context).meetingPntAdress,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900]),
            ),
          ),
          SizedBox(
            height: 9,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 15),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: RED,
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: street,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: street != null ? ", " : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: placeName,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: placeName != null ? ", " : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: country,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: country != null ? ", " : "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                        TextSpan(
                          text: area,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 13,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              S.of(context).mtPointDontBe,
              style: TextStyle(
                  color: Colors.grey[850],
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: ElevatedButton(
              onPressed: () {
                if (street != null) {
                  Clipboard.setData(
                    ClipboardData(
                      text: street,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              S.of(context).addresIsCopied,
                            ),
                          ],
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(S.of(context).couldntCopy),
                          ],
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: Text(
                S.of(context).getDirect,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadAddress() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.latLng.latitude, widget.latLng.longitude);

    setState(() {
      country = placemarks[0].country;
      area = placemarks[0].locality;
      street = placemarks[0].street;
      placeName = placemarks[0].name;
    });
  }
}
