import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/widgets/map_tour_item.dart';
import 'dart:math';
import 'package:location/location.dart' as loc;

import '../../logic/providers/currency_provider.dart';

class ToursOnMapScreen extends StatefulWidget {
  final List<MapTourItem> tours;
  final Locale locale;
  final String? cityID;
  const ToursOnMapScreen(
      {Key? key, this.cityID, required this.locale, required this.tours})
      : super(key: key);

  @override
  _ToursOnMapScreenState createState() => _ToursOnMapScreenState();
}

class _ToursOnMapScreenState extends State<ToursOnMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  MapTourItem? selectedTour;
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: "2",
              backgroundColor: Colors.white.withOpacity(0.65),
              elevation: 15,
              mini: true,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black.withOpacity(0.75),
                size: 22,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: FloatingActionButton(
                heroTag: "3",
                backgroundColor: Colors.white.withOpacity(0.65),
                elevation: 15,
                mini: true,
                child: Icon(
                  Icons.location_searching_sharp,
                  color: Colors.black.withOpacity(0.75),
                  size: 22,
                ),
                onPressed: () => _currentLocation(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: widget.tours[0].latLng, zoom: 14.4746),
            mapType: MapType.normal, myLocationEnabled: true,
            myLocationButtonEnabled: false,
            //padding: EdgeInsets.only(top: 100),
            //myLocationEnabled: true,
            //myLocationButtonEnabled: true,
            markers: getMarkers(item: widget.tours),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.2),
            child: popupItem(currencyProvider),
          )
        ],
      ),
    );
  }

  void _currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;
    var location = new loc.Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));
  }

  LatLng getCoodinates(String? value) {
    if (value != null) {
      List<String> s = value.split("|");
      return LatLng(double.parse(s[0]), double.parse(s[1]));
    } else {
      return LatLng(0, 0);
    }
  }

  String getOnePhoto(String value) {
    List<String> s = value.split("|");
    return s[0];
  }

  Widget popupItem(CurrencyProvider currencyProvider) {
    if (selectedTour != null) {
      return MapTourItemWidget(
          image: selectedTour!.photo,
          price: getPrice(currencyProvider, selectedTour!.price),
          tourName: selectedTour!.name,
          moveCamera: () {
            _goToTheTour(
              cameraPosition: CameraPosition(
                  target: selectedTour!.latLng,
                  tilt: 59.440717697143555,
                  zoom: 13.151926040649414),
            );
          },
          openTour: () {
            pushNewScreen(context,
                screen: TourDetailScreen(), withNavBar: true);
            print("CURRENT SELECTED TOUR ID");
            print(selectedTour!.id);
            context.read<DetailTourProvider>().getTourDetails(selectedTour!.id);
          },
          rating: selectedTour!.rating,
          reviews: selectedTour!.reviews,
          tourDescription: selectedTour!.desc);
    } else {
      return const SizedBox();
    }
  }

  String getPrice(CurrencyProvider data, double price) {
    if (data.currency == "USD" || data.currency == null) {
      return "\$" + price.toStringAsFixed(2);
    } else if (data.currency == "EUR") {
      return "€" + (price * data.euro!).toStringAsFixed(2);
    } else if (data.currency == "AED") {
      return ".د.إ" + (price * data.dirham!).toStringAsFixed(2);
    } else if (data.currency == "RUB") {
      return "₽" + (price * data.rouble!).toStringAsFixed(2);
    } else if (data.currency == "THB") {
      return "฿" + (price * data.baht!).toStringAsFixed(2);
    } else if (data.currency == "TRY") {
      return "₤" + (price * data.lira!).toStringAsFixed(2);
    } else if (data.currency == "GBP") {
      return "£" + (price * data.gbp!).toStringAsFixed(2);
    }
    return "\$" + price.toStringAsFixed(2);
  }

  Future<void> _goToTheTour({required CameraPosition cameraPosition}) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Set<Marker> getMarkers({required List<MapTourItem> item}) {
    Set<Marker> temp = {};
    item.forEach((element) {
      Random random = new Random();
      int randomNumber = random.nextInt(300);
      temp.add(
        Marker(
          markerId: MarkerId(element.name),
          position: element.latLng,
          onTap: () {
            setState(() {
              selectedTour = element;
            });
          },
          infoWindow:
              InfoWindow(title: S.of(context).placeOfThe + " " + element.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(randomNumber.toDouble()),
        ),
      );
    });
    print("MAP TOURS BELLOW!");
    print(temp.first.markerId);
    print(temp.last.markerId);
    return temp;
  }

  Widget noData() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        OctoImage(
          image: AssetImage('assets/empty-pana.png'),
          height: 224,
        ),
        SizedBox(
          height: 40,
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[800]!.withOpacity(0.2),
          period: Duration(seconds: 2),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Text(
              S.of(context).noToursHomeScreenTag,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[850]),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class MapTourItem {
  final String name;
  final String desc;
  final int rating;
  final int reviews;
  final double price;
  final String id;
  final String photo;
  final LatLng latLng;

  MapTourItem(
      {required this.name,
      required this.id,
      required this.photo,
      required this.latLng,
      required this.desc,
      required this.price,
      required this.rating,
      required this.reviews});
}
