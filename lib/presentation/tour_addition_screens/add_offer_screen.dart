import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';

import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:vip_tourist/presentation/screens/meeting_point_selection_screen.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offers_list_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddOfferScreen extends StatefulWidget {
  final String tourID;
  const AddOfferScreen({Key? key, required this.tourID}) : super(key: key);

  @override
  _AddOfferScreenState createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  LatLng? latLng;
  bool withTransfer = false;
  bool withFood = false;
  bool alwaysAvailable = false;

  DateTime dateTime = DateTime.now();
  final globalKey = GlobalKey<FormState>();
  late TextEditingController transferPriceController;
  late RoundedLoadingButtonController cr1;
  late TextEditingController totalAdultPrice;
  late TextEditingController totalChildPrice;
  late TextEditingController date;
  late TextEditingController languageController;
  late TextEditingController adultController;
  late TextEditingController childController;
  late TextEditingController durationController;
  late TextEditingController prohibitionsController;
  late TextEditingController meetingPointController;
  late TextEditingController prerequisitesController;
  late TextEditingController includedController;
  late TextEditingController notIncludedController;
  late TextEditingController noteController;
  late TextEditingController foodController;
  late RoundedLoadingButtonController controller;
  late RoundedLoadingButtonController controllerF;
  List<File> files = [];
  List<String> filePaths = [];

  @override
  void initState() {
    totalChildPrice = TextEditingController();
    totalAdultPrice = TextEditingController();
    cr1 = RoundedLoadingButtonController();
    date = TextEditingController();
    controllerF = RoundedLoadingButtonController();
    languageController = TextEditingController();
    adultController = TextEditingController();
    childController = TextEditingController();
    durationController = TextEditingController();
    prohibitionsController = TextEditingController();
    prerequisitesController = TextEditingController();
    includedController = TextEditingController();
    notIncludedController = TextEditingController();
    meetingPointController = TextEditingController();
    noteController = TextEditingController();
    controller = RoundedLoadingButtonController();
    transferPriceController = TextEditingController();
    foodController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).addTour),
        centerTitle: true,
        backgroundColor: Colors.green[600],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Form(
                key: globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).enterHours,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    durationField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).enterLanguages,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    languageField(context),
                    SizedBox(
                      height: 20,
                    ),

                    Card(
                      color: Colors.grey[100],
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  S.of(context).enterTicketPrices,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Flexible(
                                  child: PopupMenuButton(
                                    padding: EdgeInsets.only(left: 1),
                                    icon: Icon(
                                      Icons.info_outline,
                                      color: Colors.yellow[800],
                                      size: 18,
                                    ),
                                    itemBuilder: (_) => [
                                      PopupMenuItem(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Text(S.of(context).commissionTag),
                                            // Text(S.of(context).comissionTag),
                                            // Text(S.of(context).commision1),
                                            // Text(S.of(context).commision2),
                                            // Text(S.of(context).commision3),
                                            // Text(S.of(context).commision4),
                                            // Text(S.of(context).commision5),
                                          ],
                                        ),
                                        value: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, right: 10),
                              child: Text(
                                S.of(context).usdTag,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            adultField(context),
                            SizedBox(
                              height: 20,
                            ),
                            childField(context),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).selectDate,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        title: Text(
                          S.of(context).alwaysAvailable,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        secondary: Icon(Icons.info),
                        value: alwaysAvailable,
                        onChanged: (value) {
                          setState(() {
                            alwaysAvailable = value;
                          });
                        }),
                    DateTimePicker(
                      enabled: !alwaysAvailable,
                      controller: date,
                      decoration: InputDecoration(
                        hintText: S.of(context).tapToOpen,
                        suffixStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.description,
                        ),
                        suffixIcon: Icon(Icons.calendar_today_outlined),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.bold),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(124, 124, 124, 1)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Color.fromRGBO(124, 124, 124, 1)),
                        ),
                      ),
                      type: DateTimePickerType.dateTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      dateMask: "MMM d, yyyy - hh:mm a",
                      onChanged: (value) {
                        print("DATE TIME BEELOW");
                        print(value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          S.of(context).transferPriceInfo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: withTransfer ? Colors.black : Colors.grey),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        PopupMenuButton(
                          padding: EdgeInsets.symmetric(vertical: 1),
                          icon: Icon(
                            Icons.info_outline,
                            color: Colors.yellow[800],
                          ),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(S.of(context).priceForTransferTag),
                              ),
                              value: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        title: Text(
                          S.of(context).withTransfer,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        secondary: Icon(Icons.info),
                        value: withTransfer,
                        onChanged: (value) {
                          setState(() {
                            withTransfer = value;
                          });
                        }),
                    transferPriceField(context),
                    SizedBox(
                      height: 20,
                    ),

                    ///
                    Text(
                      S.of(context).enterFoodSnacks,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: withFood ? Colors.black : Colors.grey),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SwitchListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                        title: Text(
                          S.of(context).withFood,
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        secondary: Icon(Icons.info),
                        value: withFood,
                        onChanged: (value) {
                          setState(() {
                            withFood = value;
                          });
                        }),
                    foodField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).prerequisites,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    prerequisitesField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).enterIncluded,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    includedField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).enterNotIncluded,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    notIncludedField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).enterProhibs,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    prohibitionsField(context),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).enterNotes,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    noteField(context),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      S.of(context).chooseMeetingPoint,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    !withTransfer
                        ? RoundedLoadingButton(
                            width: double.maxFinite,
                            color: Colors.indigo,
                            height: 45,
                            onPressed: () async {
                              controllerF.start();
                              Position pos = await _determinePosition();
                              controllerF.success();
                              LatLng? temp = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      MeetingPointSelectionScreen(
                                    currentPosition:
                                        LatLng(pos.latitude, pos.longitude),
                                  ),
                                ),
                              );
                              controllerF.reset();
                              if (temp != null) {
                                setState(() {
                                  latLng = temp;
                                  meetingPointController.text =
                                      temp.latitude.toString() +
                                          ", " +
                                          temp.longitude.toString();
                                });
                              }
                            },
                            controller: controllerF,
                            child: Text(
                              S.of(context).select,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 5,
                    ),
                    meetingPointField(context),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(Icons.accessibility_outlined,
                    color: Colors.green[600], size: 30),
                subtitle: Text(S.of(context).overallTotalAdult),
                title: Text(
                  getTotalAmount(true) + "\$",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              ListTile(
                leading:
                    Icon(Icons.child_care, color: Colors.green[600], size: 30),
                subtitle: Text(S.of(context).overallTotalChild),
                title: Text(
                  getTotalAmount(false) + "\$",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "  " + S.of(context).photos,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              files.isEmpty ? uploadDocuments() : customGridViewBuilder()
            ],
          ),
        ),
      ),
    );
  }

  Widget languageField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: languageController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field should not be empty!';
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).languageExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
      ),
    );
  }

  Widget adultField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: [
                Text(
                  S.of(context).yourPriceForTour,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  controller: adultController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).fieldShouldntBe;
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      totalAdultPrice.text = getTotalWithComission(value);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    label: Text(S.of(context).adult),
                    hintText: "526.30",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: [
                Text(
                  S.of(context).withComission,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  enabled: false,
                  controller: totalAdultPrice,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).fieldShouldntBe;
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    label: Text(S.of(context).adult),
                    hintText: "526.30",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget childField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: [
                Text(
                  S.of(context).yourPriceForTour,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  controller: childController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).fieldShouldntBe;
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      totalChildPrice.text = getTotalWithComission(value);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    label: Text(S.of(context).child),
                    hintText: "35.20",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.3,
            child: Column(
              children: [
                Text(
                  S.of(context).withComission,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  enabled: false,
                  controller: totalChildPrice,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).fieldShouldntBe;
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.description),
                    label: Text(S.of(context).child),
                    hintText: "526.30",
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget transferPriceField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: transferPriceController,
        autofocus: false,
        enabled: withTransfer,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: "250",
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget durationField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: durationController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field should not be empty!';
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: "4",
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
    );
  }

  Widget prohibitionsField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: prohibitionsController,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).prohibsExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget foodField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: foodController,
        autofocus: false,
        enabled: withFood,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).enterFoodEx,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget prerequisitesField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: prerequisitesController,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).prereqExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget includedField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: includedController,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).includedExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget notIncludedField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: notIncludedController,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).notIncludedExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget meetingPointField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        enabled: false,
        controller: meetingPointController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Field should not be empty!';
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.location_on,
          ),
          hintText: "42.326, 85,10586",
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
    );
  }

  Widget noteField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: noteController,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.description),
          hintText: S.of(context).notesExample,
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget dateField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).selectDate + "!";
          }
          return null;
        },
        controller: date,
        decoration: InputDecoration(
          suffixStyle: TextStyle(color: Colors.black),
          prefixIcon: Icon(
            Icons.description,
          ),
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget uploadDocuments() {
    return MaterialButton(
      onPressed: () async {
        final ImagePicker _picker = ImagePicker();
        List<XFile>? images = await _picker.pickMultiImage();
        if (images != null) {
          for (int i = 0; i < images.length; i++) {
            setState(() {
              filePaths.add(images[i].path);
              files.add(File(images[i].path));
            });
          }
        } else {}
      },
      child: Text(
        S.of(context).uploadPhotos,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      color: Colors.blue[600],
      minWidth: double.maxFinite,
      padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget customGridViewBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          S.of(context).selectedPics,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        SizedBox(
          height: 15,
        ),
        GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: files.length,
            itemBuilder: (ctx, i) {
              return Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      files.removeAt(i);
                      filePaths.removeAt(i);
                    });
                  },
                ),
                height: 200,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(files[i].path),
                    ),
                  ),
                ),
              );
            }),
        SizedBox(
          height: 5,
        ),
        addMorePhoto(),
        SizedBox(
          height: 20,
        ),
        sendToVerifyButton()
      ],
    );
  }

  Widget addMorePhoto() {
    return TextButton(
        onPressed: () async {
          final ImagePicker _picker = ImagePicker();
          List<XFile>? images = await _picker.pickMultiImage();
          for (int i = 0; i < images!.length; i++) {
            setState(() {
              filePaths.add(images[i].path);
              files.add(File(images[i].path));
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: Colors.blue[600],
            ),
            Text(
              '   ' + S.of(context).addMorePics.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.blue[600]),
            )
          ],
        ));
  }

  Widget sendToVerifyButton() {
    return RoundedLoadingButton(
      onPressed: () async {
        controller.start();
        String? idd = context.read<AuthProvider>().user.getIdd;
        if (filePaths.isNotEmpty &&
            globalKey.currentState!.validate() &&
            idd != null) {
          CustomPhotoError cuf =
              await context.read<TourAdditionProvider>().addPhotos(filePaths);
          print(cuf.urls);
          if (cuf.noError) {
            // context.read<TourAdditionProvider>().addOffer(
            //     addOffer: AddOffer(
            //       food: withFood,
            //       transfer: withTransfer,
            //       alwaysAvailable: alwaysAvailable,
            //       duration: durationController.text,
            //       dateTime: date.text,
            //       adultPrice: getTotalAmount(true),
            //       meetingPoint: latLng == null
            //           ? "42.326|85.10586"
            //           : (latLng!.latitude.toString() +
            //               "|" +
            //               latLng!.longitude.toString()),
            //       childPrice: getTotalAmount(false),
            //       included: includedController.text,
            //       languages: languageController.text,
            //       notIncluded: notIncludedController.text,
            //       note: noteController.text,
            //       prerequisites: prerequisitesController.text,
            //       prohibitions: prohibitionsController.text,
            //       urls: fromListToString(cuf.urls),
            //     ),
            //     tourID: widget.tourID,
            //     userIDD: idd);
            controller.success();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                action: SnackBarAction(
                  label: S.of(context).goToOffers,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OffersListScreen()),
                    );
                  },
                ),
                content: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    S.of(context).toursIsSentTag,
                  ),
                ),
                duration: Duration(
                  seconds: 10,
                ),
              ),
            );
          } else {
            controller.error();
            EasyLoading.showError(
              S.of(context).errorOccuredTryAgain,
              duration: Duration(seconds: 2),
            );
            controller.reset();
          }
        } else {
          controller.error();
          EasyLoading.showError(
            S.of(context).errorOccuredTryAgain,
            duration: Duration(seconds: 2),
          );
          controller.reset();
        }
      },
      child: Text(
        S.of(context).sendToPublish,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      color: Colors.blue[600],
      width: double.maxFinite,
      controller: controller,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    date.dispose();

    languageController.dispose();

    adultController.dispose();
    childController.dispose();
    durationController.dispose();
    prohibitionsController.dispose();
    meetingPointController.dispose();
    prerequisitesController.dispose();
    includedController.dispose();
    notIncludedController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void clearForm() {
    setState(() {
      date.text = "";
      languageController.text = "";
      adultController.text = "";
      childController.text = "";
      durationController.text = "";
      prohibitionsController.text = "";
      meetingPointController.text = "";
      prerequisitesController.text = "";
      includedController.text = "";
      notIncludedController.text = "";
      noteController.text = "";
      files = [];
      filePaths = [];
    });
  }

  String fromListToString(List<String> list) {
    String s = list.join('|');
    return s;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  String getTotalWithComission(String value) {
    double val;

    try {
      val = double.parse(value);
    } catch (e) {
      return "0.0";
    }

    if (val <= 40 && val > 0) {
      double perc = (val * 15) / 100;
      val = val + perc;
    } else if (val >= 41 && val <= 149) {
      double perc = (val * 13) / 100;
      val = val + perc;
    } else if (val >= 150 && val <= 500) {
      double perc = (val * 10) / 100;
      val = val + perc;
    } else if (val >= 501 && val <= 950) {
      val = val + 50;
    } else if (val >= 951) {
      double perc = (val * 7) / 100;
      val = val + perc;
    }

    return val.toString();
  }

  String getTotalAmount(bool isAdult) {
    double l = 0.0;
    double r = 0.0;
    if (isAdult) {
      try {
        l = double.parse(adultController.text);
      } catch (e) {
        l = 0.0;
      }
    } else {
      try {
        l = double.parse(childController.text);
      } catch (e) {
        l = 0.0;
      }
    }

    if (withTransfer) {
      try {
        r = double.parse(transferPriceController.text);
      } catch (e) {
        r = 0.0;
      }
    }
    String s = getTotalWithComission((l + r).toString());
    return s;
  }
}
