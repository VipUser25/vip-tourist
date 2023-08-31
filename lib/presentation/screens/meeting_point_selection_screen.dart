import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'dart:async';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class MeetingPointSelectionScreen extends StatefulWidget {
  final LatLng currentPosition;
  const MeetingPointSelectionScreen({Key? key, required this.currentPosition})
      : super(key: key);

  @override
  _MeetingPointSelectionScreenState createState() =>
      _MeetingPointSelectionScreenState();
}

class _MeetingPointSelectionScreenState
    extends State<MeetingPointSelectionScreen> {
  Marker? meetingPoint;
  late LatLng meetingPointLatLng;

  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    // TODO: implement initState
    meetingPointLatLng = widget.currentPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String localeCode =
        Provider.of<LocalizationProvider>(context).currentLocale.languageCode;

    String locale = "en";
    if (localeCode.contains("en")) {
      locale = "en";
    } else if (localeCode.contains("ru")) {
      locale = "ru-RU";
    } else if (localeCode.contains("ar")) {
      locale = "ar-AE";
    } else if (localeCode.contains("de")) {
      locale = "de-DE";
    } else if (localeCode.contains("es")) {
      locale = "es-ES";
    } else if (localeCode.contains("fr")) {
      locale = "fr-FR";
    } else if (localeCode.contains("it")) {
      locale = "it-IT";
    } else if (localeCode.contains("th")) {
      locale = "th-TH";
    } else if (localeCode.contains("tr")) {
      locale = "tr-TR";
    } else {
      locale = "en";
    }
    meetingPoint = Marker(
      markerId: MarkerId("meetingPoint"),
      position: meetingPointLatLng,
      draggable: false, //it was true before latest pravki
      // onDragEnd: (LatLng value) {
      //   setState(() {
      //     meetingPointLatLng = value;
      //   });
      //   print("DO COORDINATED CHANGED");
      //   print(value);
      // },
      infoWindow: InfoWindow(
          title: S.of(context).meetPntTagOne,
          snippet: S.of(context).meetPntTagTwo),
      icon: BitmapDescriptor.defaultMarkerWithHue(305),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).meetingPoint,
          style: TextStyle(color: GREEN_BLACK),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: GREEN_BLACK,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Prediction? p = await PlacesAutocomplete.show(
                  offset: 0,
                  radius: 1000,
                  strictbounds: false,
                  language: locale,
                  context: context,
                  mode: Mode.overlay,
                  onError: (e) {
                    print(e);
                  },
                  apiKey: GOOGLE_PLACES_KEY,
                  types: [],
                  components: [
                    // Component(Component.country, "ru"),
                    // Component(Component.country, "kz"),
                    // Component(Component.country, "kg"),
                    // Component(Component.country, "ua"),
                    // Component(Component.country, "eg"),
                    //Component(Component.country, "ae"),
                    // Component(Component.country, "th"),
                    // Component(Component.country, "lk"),
                    // Component(Component.country, "vn"),
                    // Component(Component.country, "us"),
                    // Component(Component.country, "ca"),
                    // Component(Component.country, "mx"),
                    // Component(Component.country, "fr"),
                    // Component(Component.country, "it"),
                    // Component(Component.country, "gr"),
                    // Component(Component.country, "gb"),
                    // Component(Component.country, "de"),
                    // Component(Component.country, "es"),
                    // Component(Component.country, "tr"),
                    // Component(Component.country, "se"),
                    // Component(Component.country, "ch"),
                  ],
                  hint: S.of(context).search,
                );
                if (p != null) {
                  try {
                    print("STILL TESTING THAT GOOGLE PLACES API: BELOW:::");
                    LatLng vas = await getPlaceDetails(placeID: p.placeId!);

                    setState(() {
                      meetingPointLatLng = vas;
                    });
                    _goToTheTour(
                      cameraPosition: CameraPosition(
                          target: vas, tilt: 0, zoom: 16.151926040649414),
                    );
                  } catch (e) {
                    print("EROR OCCURED");
                  }
                }
              },
              icon: Icon(
                Icons.search,
                color: GREEN_BLACK,
              ))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: FloatingActionButton(
          heroTag: "1",
          backgroundColor: PRIMARY,
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.check_sharp,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          onPressed: () => Navigator.of(context).pop(meetingPointLatLng),
        ),
      ),
      body: Scaffold(
        body: GoogleMap(
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          onTap: (value) {
            setState(() {
              meetingPointLatLng = value;
            });
            print("DO COORDINATED CHANGED");
            print(value);
          },
          padding: EdgeInsets.symmetric(vertical: 29),
          initialCameraPosition:
              CameraPosition(target: widget.currentPosition, zoom: 14.4746),
          mapType: MapType.normal,
          markers: {meetingPoint!},
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }

  Future<void> _goToTheTour({required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<LatLng> getPlaceDetails({required String placeID}) async {
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/place/details/json?key=$GOOGLE_PLACES_KEY&place_id=$placeID");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode != 200) {
      throw Exception();
    } else {
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;

      return LatLng(
        double.parse(
          body["result"]["geometry"]["location"]["lat"].toString(),
        ),
        double.parse(
          body["result"]["geometry"]["location"]["lng"].toString(),
        ),
      );
    }
  }
}
