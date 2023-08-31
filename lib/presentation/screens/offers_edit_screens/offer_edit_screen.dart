import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:day_picker/day_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/models/custom/cool_step2.dart';
import 'package:vip_tourist/logic/models/custom/cool_stepper2.dart';
import 'package:vip_tourist/logic/models/custom/cool_stepper_config2.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:vip_tourist/logic/models/add_tour.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/offer_edit_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:vip_tourist/logic/utility/temp_currency.dart';
import 'package:vip_tourist/presentation/screens/meeting_point_selection_screen.dart';

import '../../../logic/providers/localization_provider.dart';
import '../../../logic/utility/constants.dart';
import '../../tour_addition_screens/tour_sent_screen.dart';

class OfferEditScreen extends StatefulWidget {
  final String offerID;
  const OfferEditScreen({Key? key, required this.offerID}) : super(key: key);

  @override
  _OfferEditScreenState createState() => _OfferEditScreenState();
}

//переход на страницу с крышой
// ну и логика кнопки onDoneLogic
class _OfferEditScreenState extends State<OfferEditScreen> {
  LatLng? latLng;
  late bool withTransfer;
  late String previewPhotoUrl;
  late RoundedLoadingButtonController controllerF;
  bool alwaysAvailable = false;
  String currency = "USD";
  DateTime dateTime = DateTime.now();
  final globalKey = GlobalKey<FormState>();
  final globalKey2 = GlobalKey<FormState>();
  final globalKey3 = GlobalKey<FormState>();
  final globalKey4 = GlobalKey<FormState>();
  late TextEditingController transferPriceController;
  late RoundedLoadingButtonController cr1;
  late TextEditingController date;
  late TextEditingController languageController;
  late TextEditingController nameController;
  late TextEditingController desController;
  late TextEditingController adultController;
  late TextEditingController childController;
  late TextEditingController durationController;
  late TextEditingController prohibitionsController;
  late TextEditingController meetingPointController;
  late TextEditingController prerequisitesController;
  late TextEditingController includedController;
  late TextEditingController notIncludedController;
  late TextEditingController noteController;
  late TextEditingController totalAdultPrice;
  late TextEditingController freeTicketController;
  late TextEditingController time;

  List<File> files = [];
  List<String> filePaths = [];
  List<dynamic> selectedCategories = [];
  late List<String> urls;
  late TextEditingController seatsController;
  String? carPhotoPath;
  File? carPhoto;
  late TextEditingController totalChildPrice;

  bool firstTime = true;

  bool isKeyboardVisible = false;
  List<DayInWeek> days = [];
  String ddays = "mn";
  String toUploadLanguages = "";

  int _current = 0;
  late CarouselController carouselController;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (firstTime) {
      days = getDaysList(context.read<OfferEditProvider>().tour.days);
      firstTime = false;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    KeyboardVisibilityController().onChange.listen((event) {
      setState(() {
        isKeyboardVisible = event;
      });
    });
    carouselController = CarouselController();
    toUploadLanguages = context.read<OfferEditProvider>().tour.languages;
    alwaysAvailable = context.read<OfferEditProvider>().tour.alwaysAvailable;
    time = TextEditingController(
        text: getTime(context.read<OfferEditProvider>().tour.time));
    totalChildPrice = TextEditingController(
        text: getTotalWithComission(
            context.read<OfferEditProvider>().tour.childPrice ?? "0"));
    totalAdultPrice = TextEditingController(
        text: getTotalWithComission(
            context.read<OfferEditProvider>().tour.adultPrice));
    controllerF = RoundedLoadingButtonController();
    nameController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.name);
    desController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.description);
    withTransfer = context.read<OfferEditProvider>().tour.transfer;
    cr1 = RoundedLoadingButtonController();
    urls = context.read<OfferEditProvider>().urls;
    date = TextEditingController(
        text: context.read<OfferEditProvider>().tour.dateTime);
    languageController = TextEditingController(
        text: getLanguagesForField(
            context.read<OfferEditProvider>().tour.languages));
    adultController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.adultPrice);
    childController = TextEditingController(
        text: getNormalValueForChildController(
            context.read<OfferEditProvider>().tour.childPrice));
    durationController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.duration);
    prohibitionsController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.prohibitions);
    prerequisitesController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.prerequisites);
    includedController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.included);
    notIncludedController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.notIncluded);
    meetingPointController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.meetingPoint);
    noteController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.note);
    seatsController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.seats);
    previewPhotoUrl = context.read<OfferEditProvider>().tour.mainPhotoUrl;
    freeTicketController = TextEditingController(
        text: context.read<OfferEditProvider>().tour.freeTicketNote);
    transferPriceController = TextEditingController();
    carPhotoPath = context.read<OfferEditProvider>().tour.transferPhotoUrl;
    initCategories(context.read<OfferEditProvider>().categories!);
    super.initState();
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    final data = S.of(context);
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).editTour,
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
      body: CoolStepper2(
        config: CoolStepperConfig2(
            backText: S.of(context).back.toUpperCase(),
            nextText: S.of(context).next.toUpperCase().toUpperCase(),
            finalText: S.of(context).save,
            stepText: S.of(context).step.toUpperCase(),
            ofText: S.of(context).izz.toUpperCase()),
        showErrorSnackbar: true,
        steps: [
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getFirstScreen(data),
              validation: () {
                if (!globalKey.currentState!.validate()) {
                  return "NAHAHAHAAHAHA";
                }
                return null;
              }),
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getSecondScreen(data),
              validation: () {
                return null;
              }),
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getThirdScreen(data),
              validation: () {
                if (!globalKey3.currentState!.validate()) {
                  return S.of(context).enterAdult;
                }
                return null;
              }),
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getFourthScreen(data),
              validation: () {
                if (alwaysAvailable) {
                  if (ddays == "" || ddays.isEmpty) {
                    EasyLoading.showInfo(S.of(context).daysOfWeekNotSelected);
                    return "";
                  } else {
                    if (!globalKey4.currentState!.validate()) {
                      return S.of(context).enterAdult;
                    }
                    return null;
                  }
                } else {
                  if (!globalKey4.currentState!.validate()) {
                    return S.of(context).enterAdult;
                  }
                  return null;
                }
              }),
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getFifthScreen(data, locale),
              validation: () {
                if (withTransfer) {
                  if (filePaths.isNotEmpty && carPhoto != null ||
                      urls.isNotEmpty && carPhoto != null ||
                      filePaths.isNotEmpty && carPhotoPath != null ||
                      urls.isNotEmpty && carPhotoPath != null) {
                    //carPhotoPath

                    return null;
                  } else {
                    if (previewPhotoUrl.isEmpty && carPhoto != null) {
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            S.of(context).uMustUploadPhotos,
                          ),
                        ),
                        duration: Duration(seconds: 2),
                      );
                      print("U MUST UPLOAD TOUR PHOTOS SELECTED");
                      return "";
                    } else if (previewPhotoUrl.isNotEmpty && carPhoto == null) {
                      print("U MUST UPLOAD CAR PHOTOS SELECTED");
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            S.of(context).noCarPhotoSelectedWarn,
                          ),
                        ),
                        duration: Duration(seconds: 2),
                      );

                      return "";
                    } else if (previewPhotoUrl.isEmpty && carPhoto == null) {
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text(
                            S.of(context).uMustUploadPhotos2,
                          ),
                        ),
                        duration: Duration(seconds: 2),
                      );
                      print("U MUST UPLOAD AAALLLL PHOTOS SELECTED");
                      return "";
                    }
                  }
                } else {
                  if (previewPhotoUrl.isEmpty) {
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          S.of(context).uMustUploadPhotos,
                        ),
                      ),
                      duration: Duration(seconds: 2),
                    );
                    return "";
                  } else {
                    return null;
                  }
                }
                return null;
              }),
          CoolStep2(
              isHeaderEnabled: false,
              title: "vor title",
              subtitle: "vot subtitle",
              content: getLastScreen(data, locale),
              validation: () {
                return null;
              }),
        ],
        onCompleted: () => onDoneLogic(),
      ),
    );
  }

  String? getNormalValueForChildController(String? price) {
    if (price != null) {
      if (price.isEmpty ||
          price == "" ||
          price == " " ||
          price == " " ||
          price == " " ||
          price == "null") {
        return null;
      } else {
        return price;
      }
    }
    return null;
  }

  String? getTime(String? tm) {
    if (tm != null) {
      return tm.substring(0, 5);
    }
    return null;
  }

  String getLanguagesForField(String langgg) {
    List<String> listko = langgg.split("|");
    return listko.join(", ");
  }

  Widget getTourPhotos() {
    if (previewPhotoUrl.isEmpty) {
      return Container();
    } else {
      try {
        return Center(
          child: ClipRRect(
            child: Image.file(
              File(filePaths[0]),
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        );
      } catch (e) {
        return Center(
          child: ClipRRect(
            child: Image.network(
              urls[0],
              height: 200,
              width: 300,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
        );
      }
    }
  }

  Widget getLastScreen(S data, Locale locale) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          slider(),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          (nameController.text.isEmpty || nameController.text == "")
              ? Container()
              : Text(
                  nameController.text,
                  style: TextStyle(
                      color: GREEN_BLACK,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                ),
          const SizedBox(
            height: 12,
          ),
          Text(
            desController.text,
            style: TextStyle(fontSize: 16, color: GREEN_BLACK),
          ),
          const SizedBox(
            height: 10,
          ),
          Divider(
            thickness: 0.5,
            color: GRAY,
          ),
          const SizedBox(
            height: 10,
          ),
          listTileTemplate(
              icon: Icons.watch_later_sharp,
              title: durationController.text + " " + S.of(context).hours,
              subtitle: S.of(context).duration),
          const SizedBox(
            height: 15,
          ),
          listTileTemplate(
              icon: Icons.emoji_people,
              title: languageController.text,
              subtitle: S.of(context).liveTour),
          getAvailabilityBlock(),
          const SizedBox(
            height: 15,
          ),
          listTileTemplate(
              icon: Icons.chair,
              title: seatsController.text,
              subtitle: S.of(context).seatsAvailable),
          const SizedBox(
            height: 15,
          ),
          listTileTemplate(
              icon: CupertinoIcons.person_alt,
              title: getTotalAmount(true) + "\$",
              subtitle: S.of(context).adultPrice),
          const SizedBox(
            height: 15,
          ),
          listTileTemplate(
              icon: Icons.child_care,
              title: getTotalAmount(false) + "\$",
              subtitle: S.of(context).childPrice),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  Widget getAvailabilityBlock() {
    if (alwaysAvailable) {
      return SizedBox();
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: listTileTemplate(
            icon: Icons.calendar_month,
            title: DateFormat("dd MMMM, yyyy").format(dateTime),
            subtitle: S.of(context).dateAndTime),
      );
    }
  }

  Widget listTileTemplate(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Icon(
          icon,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: GREEN_BLACK),
            ),
            Text(subtitle, style: TextStyle(color: GRAY, fontSize: 12)),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget getDurationForLast() {
    return ListTile(
      leading: Icon(Icons.restore, color: Colors.pink[700], size: 30),
      subtitle: Text(S.of(context).duration),
      title: Text(
        durationController.text + " " + S.of(context).hours.toLowerCase(),
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget getSeatsForLast() {
    return ListTile(
      leading: Icon(Icons.chair, color: Colors.yellow[700], size: 30),
      title: Text(
        seatsController.text + " " + S.of(context).seatsAvailable,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget getFifthScreen(S data, Locale locale) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          (files.isEmpty &&
                  urls.isEmpty &&
                  carPhoto == null &&
                  carPhotoPath == null)
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                )
              : Container(),
          (files.isEmpty &&
                  urls.isEmpty &&
                  carPhoto == null &&
                  carPhotoPath == null)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 70.0, right: 70),
                      child: Image.asset("assets/uploadPhoto.png"),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Text(S.of(context).photos,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: GREEN_BLACK))
                  ],
                )
              : Container(),
          const SizedBox(
            height: 20,
          ),
          (files.isEmpty && urls.isEmpty)
              ? uploadDocuments(locale)
              : customGridViewBuilder(),
          const SizedBox(
            height: 23,
          ),
          getCarBlock(locale)
        ],
      ),
    );
  }

  List<DayInWeek> getDaysList(String? days) {
    List<DayInWeek> list = [
      DayInWeek(S.of(context).mn),
      DayInWeek(
        S.of(context).tu,
      ),
      DayInWeek(
        S.of(context).wd,
      ),
      DayInWeek(
        S.of(context).th,
      ),
      DayInWeek(
        S.of(context).fr,
      ),
      DayInWeek(
        S.of(context).st,
      ),
      DayInWeek(
        S.of(context).sn,
      ),
    ];
    if (days == null) {
      ddays = "mn";
      list[0].toggleIsSelected();
    } else {
      ddays = days;
      List<String> op = days.split(",");
      op.forEach((element) {
        if (element == "mn") {
          list[0].toggleIsSelected();
        } else if (element == "tu") {
          list[1].toggleIsSelected();
        } else if (element == "wd") {
          list[2].toggleIsSelected();
        } else if (element == "th") {
          list[3].toggleIsSelected();
        } else if (element == "fr") {
          list[4].toggleIsSelected();
        } else if (element == "st") {
          list[5].toggleIsSelected();
        } else if (element == "sn") {
          list[6].toggleIsSelected();
        }
      });
    }
    return list;
  }

  Widget getFourthScreen(S data) {
    return SingleChildScrollView(
      child: Form(
        key: globalKey4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              S.of(context).selectDateAndTime,
              style: TextStyle(
                  fontSize: 18,
                  color: GREEN_BLACK,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 3),
                activeColor: PRIMARY,
                title: Text(
                  S.of(context).alwaysAvailable,
                  style: TextStyle(
                      color: GREEN_GRAY,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                value: alwaysAvailable,
                onChanged: (value) {
                  setState(() {
                    alwaysAvailable = value;
                  });
                }),
            Divider(
              thickness: 0.5,
              color: GRAY,
            ),
            const SizedBox(height: 20),
            alwaysAvailable
                ? SelectWeekDays(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    days: days,
                    border: false,
                    boxDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        colors: [Colors.green[600]!, Colors.blue[600]!],
                        tileMode: TileMode
                            .repeated, // repeats the gradient over the canvas
                      ),
                    ),
                    onSelect: (values) {
                      print("selectiob results:");
                      days.forEach((element) {
                        print(element.isSelected);
                      });
                      setState(() {
                        ddays = getDayOfWeeks();
                      });
                      print(ddays);
                    },
                  )
                : Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mustHaveTile(text: S.of(context).date),
                            SizedBox(
                              height: 10,
                            ),
                            DateTimePicker(
                              enabled: !alwaysAvailable,
                              controller: date,
                              validator: alwaysAvailable
                                  ? null
                                  : (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == " " ||
                                          value == "  " ||
                                          value == "  " ||
                                          value == "  ") {
                                        print("THIS SRABATYBEAT???");

                                        return S.of(context).selectDate;
                                      }
                                      return null;
                                    },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.calendar_today),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(18, 24, 18, 16),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                              ),
                              type: DateTimePickerType.date,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              dateMask: "d MMMM, yyyy",
                              onChanged: (value) {
                                print("DATE TIME BEELOW");
                                print(value);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 2.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            mustHaveTile(text: S.of(context).time),
                            SizedBox(
                              height: 10,
                            ),
                            DateTimePicker(
                              enabled: !alwaysAvailable,
                              controller: time,
                              validator: alwaysAvailable
                                  ? null
                                  : (value) {
                                      if (value == null ||
                                          value.isEmpty ||
                                          value == " " ||
                                          value == "  " ||
                                          value == "  " ||
                                          value == "  ") {
                                        print("THIS SRABATYBEAT???");

                                        return S.of(context).fieldShouldntBe;
                                      }
                                      return null;
                                    },
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.watch_later_rounded),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                                contentPadding:
                                    EdgeInsets.fromLTRB(18, 24, 18, 16),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: GRAY),
                                ),
                              ),
                              type: DateTimePickerType.time,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                              dateMask: "hh:mm a",
                              onChanged: (value) {
                                print(" TIME BEELOW");
                                print(value);
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
            SizedBox(
              height: 30,
            ),
            optionalTile(text: S.of(context).chooseMeetingPoint),
            SizedBox(
              height: 20,
            ),
            !withTransfer
                ? RoundedLoadingButton(
                    width: double.maxFinite,
                    color: PRIMARY,
                    borderRadius: 10,
                    height: 60,
                    onPressed: () async {
                      bool isLocationEnabled =
                          await Geolocator.isLocationServiceEnabled();
                      if (isLocationEnabled) {
                        controllerF.start();
                        Position pos = await _determinePosition();
                        controllerF.success();
                        LatLng? temp = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingPointSelectionScreen(
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
                      } else {
                        EasyLoading.showInfo(
                          S.of(context).geolocationOff,
                          duration: const Duration(seconds: 3),
                        );
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
              height: 20,
            ),
            meetingPointField(context),
            SizedBox(
              height: 30,
            ),
            optionalTile(text: S.of(context).notesAboutFreeTour),
            const SizedBox(
              height: 15,
            ),
            freeTicketField(context),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  Widget freeTicketField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: freeTicketController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 7,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).freeChildTicketEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  String getDayOfWeeks() {
    String cc = "";
    if (days[0].isSelected) {
      cc = cc + "mn,";
    }
    if (days[1].isSelected) {
      cc = cc + "tu,";
    }
    if (days[2].isSelected) {
      cc = cc + "wd,";
    }
    if (days[3].isSelected) {
      cc = cc + "th,";
    }
    if (days[4].isSelected) {
      cc = cc + "fr,";
    }
    if (days[5].isSelected) {
      cc = cc + "st,";
    }
    if (days[6].isSelected) {
      cc = cc + "sn,";
    }
    if (cc.isNotEmpty || cc != "") {
      String oo = cc;
      cc = oo.substring(0, oo.length - 1);
    }
    print("THAT CC RESULT IS");
    print(cc);
    return cc;
  }

  Widget getThirdScreen(S data) {
    return SingleChildScrollView(
      child: Form(
        key: globalKey3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  S.of(context).ticketPrice,
                  style: TextStyle(
                      fontSize: 18,
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold),
                ),
                PopupMenuButton(
                  padding: EdgeInsets.only(left: 1),
                  icon: Icon(
                    Icons.info_outline,
                    color: RED,
                    size: 18,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(S.of(context).commissionTag),
                          Text(S.of(context).comissionTag),
                          Text(S.of(context).commission0),
                          Text(S.of(context).commission1),
                          Text(S.of(context).commission2),
                          Text(S.of(context).commission3),
                          Text(S.of(context).commission4),
                          Text(S.of(context).commission5),
                          Text(S.of(context).commission6),
                        ],
                      ),
                      value: true,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              S.of(context).usdTag,
              style: TextStyle(
                fontSize: 16,
                color: GREEN_GRAY,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            adultPriceTile(),
            SizedBox(
              height: 15,
            ),
            adultField(context),
            SizedBox(
              height: 20,
            ),
            childPriceTile(),
            SizedBox(
              height: 15,
            ),
            childField(context),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 0.5,
              color: GRAY,
            ),
            SwitchListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                title: Text(
                  S.of(context).withTransfer,
                  style: TextStyle(
                      color: GREEN_GRAY,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                value: withTransfer,
                activeColor: PRIMARY,
                onChanged: (value) {
                  setState(() {
                    withTransfer = value;
                  });
                }),
          ],
        ),
      ),
    );
  }

  Widget mustHaveTile({required String text}) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: text + " ",
            style: TextStyle(
                color: GRAY, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextSpan(
              text: "*",
              style: TextStyle(
                  color: RED, fontSize: 16, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget adultPriceTile() {
    return Row(
      children: [
        Icon(
          Icons.person,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 10,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: S.of(context).adultPrice + " ",
                style: TextStyle(
                    color: GREEN_GRAY,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              TextSpan(
                  text: "*",
                  style: TextStyle(
                      color: RED, fontSize: 16, fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ],
    );
  }

  Widget childPriceTile() {
    return Row(
      children: [
        Icon(
          Icons.child_care,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 10,
        ),
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                text: S.of(context).childPrice + " ",
                style: TextStyle(
                    color: GREEN_GRAY,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget optionalTile({required String text}) {
    return Text(
      text,
      style: TextStyle(color: GRAY, fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget getFirstScreen(S data) {
    return SingleChildScrollView(
      child: Form(
        key: globalKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              S.of(context).describeUrTour,
              style: TextStyle(
                  fontSize: 18,
                  color: GREEN_BLACK,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).name),
            const SizedBox(
              height: 15,
            ),
            nameField(context),
            SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).desc),
            SizedBox(
              height: 15,
            ),
            descField(context),
            SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).chooseCategories),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                _showMultiSelect(context, data);
              },
              child: Text(
                S.of(context).select,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            selectedCategories.isEmpty
                ? Container()
                : SizedBox(
                    height: 20,
                  ),
            selectedCategories.isEmpty
                ? Container()
                : Text(
                    getCategories(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16, color: GRAY),
                  ),
            selectedCategories.isEmpty
                ? Container()
                : SizedBox(
                    height: 10,
                  ),
            selectedCategories.isEmpty
                ? Container()
                : Divider(
                    thickness: 0.5,
                    color: GRAY,
                  ),
            SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).enterHours),
            const SizedBox(
              height: 15,
            ),
            durationField(context),
            SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).enterSeats),
            SizedBox(
              height: 15,
            ),
            seatsField(context),
            SizedBox(
              height: 20,
            ),
            mustHaveTile(text: S.of(context).chooseLanguages),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                _showLanguageSelect(context, data);
              },
              child: Text(
                S.of(context).select,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            languageField(context),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelect(BuildContext context, S data) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: [
            MultiSelectItem("en", S.of(context).english),
            MultiSelectItem("ru", S.of(context).russian),
            MultiSelectItem("es", S.of(context).spanish),
            MultiSelectItem("it", S.of(context).italian),
            MultiSelectItem("fr", S.of(context).french),
            MultiSelectItem("tr", S.of(context).turkish),
            MultiSelectItem("ar", S.of(context).arabian),
            MultiSelectItem("th", S.of(context).thai),
            MultiSelectItem("de", S.of(context).german),
          ],
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Text(S.of(context).select,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          ),
          cancelText: Text(S.of(context).cancel),
          confirmText: Text(S.of(context).ok),
          initialValue: selectedCategories,
          listType: MultiSelectListType.LIST,
          onConfirm: (values) {
            List<String> opp = [];
            values.forEach((element) {
              if (element == "en") {
                opp.add(S.of(context).english);
              } else if (element == "ru") {
                opp.add(S.of(context).russian);
              } else if (element == "es") {
                opp.add(S.of(context).spanish);
              } else if (element == "it") {
                opp.add(S.of(context).italian);
              } else if (element == "fr") {
                opp.add(S.of(context).french);
              } else if (element == "tr") {
                opp.add(S.of(context).turkish);
              } else if (element == "ar") {
                opp.add(S.of(context).arabian);
              } else if (element == "th") {
                opp.add(S.of(context).thai);
              } else if (element == "de") {
                opp.add(S.of(context).german);
              }
            });
            setState(() {
              toUploadLanguages = opp.join("|");
              languageController.text = opp.join(", ");
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  Widget getSecondScreen(S data) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).additional,
            style: TextStyle(
                fontSize: 18, color: GREEN_BLACK, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 20,
          ),
          optionalTile(text: S.of(context).prerequisites2),
          const SizedBox(
            height: 15,
          ),
          prerequisitesField(context),
          SizedBox(
            height: 20,
          ),
          optionalTile(text: S.of(context).enterIncluded2),
          const SizedBox(
            height: 15,
          ),
          includedField(context),
          SizedBox(
            height: 20,
          ),
          optionalTile(text: S.of(context).enterNotIncluded2),
          const SizedBox(
            height: 15,
          ),
          notIncludedField(context),
          SizedBox(
            height: 20,
          ),
          optionalTile(text: S.of(context).enterProhibs2),
          const SizedBox(
            height: 15,
          ),
          prohibitionsField(context),
          SizedBox(
            height: 20,
          ),
          optionalTile(text: S.of(context).enterNotes2),
          const SizedBox(
            height: 15,
          ),
          noteField(context),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  String getCategories() {
    String ss = "";
    selectedCategories.forEach((element) {
      if (element.toString() == "guide") {
        ss = ss + " " + S.of(context).guidedTour;
      } else if (element.toString() == "private") {
        ss = ss + " " + S.of(context).privateTour;
      } else if (element.toString() == "one_day_trip") {
        ss = ss + " " + S.of(context).oneDay;
      } else if (element.toString() == "nature") {
        ss = ss + " " + S.of(context).natuer;
      } else if (element.toString() == "ticket_must_have") {
        ss = ss + " " + S.of(context).ticketMustHave;
      } else if (element.toString() == "on_water") {
        ss = ss + " " + S.of(context).onWater;
      } else if (element.toString() == "package_tour") {
        ss = ss + " " + S.of(context).packageTour;
      } else if (element.toString() == "small_group") {
        ss = ss + " " + S.of(context).smallGroups;
      } else if (element.toString() == "invalid_friendly") {
        ss = ss + " " + S.of(context).invalidFriend;
      } else if (element.toString() == "history") {
        ss = ss + " " + S.of(context).history;
      } else if (element.toString() == "open_air") {
        ss = ss + " " + S.of(context).openAir;
      } else if (element.toString() == "street_art") {
        ss = ss + " " + S.of(context).StreetArt;
      } else if (element.toString() == "adrenaline") {
        ss = ss + " " + S.of(context).adrenaline;
      } else if (element.toString() == "architecture") {
        ss = ss + " " + S.of(context).architecture;
      } else if (element.toString() == "food") {
        ss = ss + " " + S.of(context).food;
      } else if (element.toString() == "music") {
        ss = ss + " " + S.of(context).music;
      } else if (element.toString() == "for_couples_activities") {
        ss = ss + " " + S.of(context).forCouples;
      } else if (element.toString() == "for_kids_activities") {
        ss = ss + " " + S.of(context).forKids;
      } else if (element.toString() == "museum") {
        ss = ss + " " + S.of(context).museums;
      } else if (element.toString() == "memorial") {
        ss = ss + " " + S.of(context).memorials;
      } else if (element.toString() == "park") {
        ss = ss + " " + S.of(context).parks;
      } else if (element.toString() == "gallery") {
        ss = ss + " " + S.of(context).galleries;
      } else if (element.toString() == "square") {
        ss = ss + " " + S.of(context).squares;
      } else if (element.toString() == "theater") {
        ss = ss + " " + S.of(context).theaters;
      } else if (element.toString() == "castle") {
        ss = ss + " " + S.of(context).castles;
      } else if (element.toString() == "towers") {
        ss = ss + " " + S.of(context).towers;
      } else if (element.toString() == "airports") {
        ss = ss + " " + S.of(context).airpots;
      } else if (element.toString() == "bicycle") {
        ss = ss + " " + S.of(context).bycicle;
      } else if (element.toString() == "minivan") {
        ss = ss + " " + S.of(context).minivan;
      } else if (element.toString() == "public_transport") {
        ss = ss + " " + S.of(context).pubTransport;
      } else if (element.toString() == "limousine") {
        ss = ss + " " + S.of(context).limousine;
      } else if (element.toString() == "car") {
        ss = ss + " " + S.of(context).car;
      } else if (element.toString() == "cruise") {
        ss = ss + " " + S.of(context).cruise;
      }
    });
    return ss;
  }

  void initCategories(Categories categories) {
    if (categories.guideTour) {
      selectedCategories.add("guide");
    }
    if (categories.privateTour) {
      selectedCategories.add("private");
    }
    if (categories.oneDayTrip) {
      selectedCategories.add("one_day_trip");
    }
    if (categories.nature) {
      selectedCategories.add("natuer");
    }
    if (categories.ticketMustHave) {
      selectedCategories.add("ticket_must_have");
    }
    if (categories.onWater) {
      selectedCategories.add("on_water");
    }
    if (categories.packageTour) {
      selectedCategories.add("package_tour");
    }
    if (categories.smallGroup) {
      selectedCategories.add("small_group");
    }
    if (categories.invalidFriendly) {
      selectedCategories.add("invalid_friendly");
    }
    if (categories.history) {
      selectedCategories.add("history");
    }
    if (categories.openAir) {
      selectedCategories.add("open_air");
    }
    if (categories.streetArt) {
      selectedCategories.add("street_art");
    }
    if (categories.adrenaline) {
      selectedCategories.add("adrenaline");
    }
    if (categories.architecture) {
      selectedCategories.add("architecture");
    }
    if (categories.food) {
      selectedCategories.add("food");
    }
    if (categories.music) {
      selectedCategories.add("music");
    }
    if (categories.forCouples) {
      selectedCategories.add("for_couples_activities");
    }
    if (categories.forKids) {
      selectedCategories.add("for_kids_activities");
    }
    if (categories.museum) {
      selectedCategories.add("museum");
    }
    if (categories.memorial) {
      selectedCategories.add("memorial");
    }
    if (categories.gallery) {
      selectedCategories.add("gallery");
    }
    if (categories.square) {
      selectedCategories.add("square");
    }
    if (categories.theater) {
      selectedCategories.add("theater");
    }
    if (categories.castle) {
      selectedCategories.add("castle");
    }
    if (categories.towers) {
      selectedCategories.add("towers");
    }
    if (categories.airports) {
      selectedCategories.add("airports");
    }
    if (categories.bicycle) {
      selectedCategories.add("bicycle");
    }
    if (categories.minivan) {
      selectedCategories.add("minivan");
    }
    if (categories.publicTransport) {
      selectedCategories.add("public_transport");
    }
    if (categories.limousine) {
      selectedCategories.add("limousine");
    }
    if (categories.car) {
      selectedCategories.add("car");
    }
    if (categories.cruise) {
      selectedCategories.add("cruise");
    }
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Widget languageField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: languageController,

        enableInteractiveSelection: false, // will disable paste operation
        focusNode: new AlwaysDisabledFocusNode(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).fieldShouldntBe;
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16, color: GREEN_GRAY),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).languageEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
      ),
    );
  }

  Widget carGridViewBuilder(Locale locale) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GridView(
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  setState(() {
                    carPhoto = null;
                    carPhotoPath = null;
                  });
                },
              ),
              height: 200,
              width: 120,
              decoration: getImageType(),
            )
          ],
        ),
      ],
    );
  }

  BoxDecoration getImageType() {
    if (carPhotoPath!.contains("http://res.cloudinary.com/space-developers")) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(carPhotoPath!),
        ),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(
            File(carPhoto!.path),
          ),
        ),
      );
    }
  }

  Widget getCarBlock(Locale locale) {
    if (withTransfer) {
      if (carPhoto != null || carPhotoPath != null) {
        return carGridViewBuilder(locale);
      } else {
        return uploadCarPhoto(locale);
      }
    } else {
      return Container();
    }
  }

  Widget uploadCarPhoto(Locale locale) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              S.of(context).uploadCarPhoto,
              style: TextStyle(
                  color: GREEN_GRAY, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
              onPressed: () async {
                final ImagePicker _picker = ImagePicker();
                XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    carPhoto = File(image.path);
                    carPhotoPath = image.path;
                  });
                }
              },
              icon: Icon(
                Icons.add_circle,
                color: PRIMARY,
                size: 40,
              ))
        ],
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
            width: MediaQuery.of(context).size.width / 2.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                optionalTile(text: S.of(context).withoutComission),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  controller: adultController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).enterAdult;
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      totalAdultPrice.text = getTotalWithComission(value);
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                optionalTile(text: S.of(context).withComission),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  enabled: true,
                  controller: totalAdultPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return " ";
                    }
                    return null;
                  },
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      adultController.text =
                          getTotalWithComissionReversed(value);
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
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
            width: MediaQuery.of(context).size.width / 2.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                optionalTile(text: S.of(context).withoutComission),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  controller: childController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      totalChildPrice.text = getTotalWithComission(value);
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                  ),
                  obscureText: false,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                optionalTile(text: S.of(context).withComission),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  maxLines: null,
                  enabled: true,
                  controller: totalChildPrice,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  autofocus: false,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      childController.text =
                          getTotalWithComissionReversed(value);
                    });
                  },
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
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
        if (childController.text.isEmpty || childController.text == "") {
          l = 0.0;
        }
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

  Widget transferPriceField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: transferPriceController,
        autofocus: false,
        enabled: withTransfer,
        validator: (value) {
          if (withTransfer) {
            if (value == null || value.isEmpty) {
              return S.of(context).fieldShouldntBe;
            }
          }
          return null;
        },
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
        minLines: 1,
        maxLines: 1,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).uShouldEnterDuration;
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: "4",
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
    );
  }

  Widget seatsField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: seatsController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        minLines: 1,
        maxLines: 1,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).uShouldEnterSeats;
          } else if (!isNumeric(value)) {
            return S.of(context).invalidFormatTag;
          }
          return null;
        },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: "28",
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
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
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 7,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).prohibsEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
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
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 7,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).prereqEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
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
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 7,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).includedEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
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
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 7,
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).notIncludedEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
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
        validator: withTransfer
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).fieldShouldntBe;
                }
                return null;
              },
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.location_on,
          ),
          hintText: "42.326, 85,10586",
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        keyboardType: TextInputType.number,
        obscureText: false,
      ),
    );
  }

  Widget noteField(BuildContext ctx) {
    return TextFormField(
      controller: noteController,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 7,
      autofocus: false,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      onChanged: (value) {},
      decoration: InputDecoration(
        hintText: S.of(context).notesExample,
        hintStyle: TextStyle(color: GRAY, fontSize: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GRAY),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GRAY),
        ),
        contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: GRAY),
        ),
      ),
      obscureText: false,
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
          if (alwaysAvailable) {
            if (value == null || value.isEmpty) {
              return S.of(context).selectDate + "!";
            }
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

  Widget uploadDocuments(Locale locale) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            S.of(context).mainPhotos,
            style: TextStyle(
                color: GREEN_GRAY, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
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
                  setState(() {
                    previewPhotoUrl = filePaths[0];
                  });
                } else {}
              },
              icon: Icon(
                Icons.add_circle,
                color: PRIMARY,
                size: 40,
              ))
        ],
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: PRIMARY,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(S.of(context).previewImage)
          ],
        ),
        const SizedBox(
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
          itemCount: urls.length,
          itemBuilder: (ctx, i) {
            print("check urls bellow!");
            print(urls);
            return Container(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: previewPhotoUrl == urls[i] ? PRIMARY : Colors.grey,
                    ),
                    onPressed: () {
                      if (previewPhotoUrl != urls[i]) {
                        setState(() {
                          previewPhotoUrl = urls[i];
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: RED,
                    ),
                    onPressed: () {
                      if (previewPhotoUrl == urls[i]) {
                        setState(() {
                          urls.removeAt(i);
                          try {
                            previewPhotoUrl = urls[0];
                          } catch (e) {
                            try {
                              previewPhotoUrl = filePaths[0];
                            } catch (e) {
                              previewPhotoUrl = "";
                            }
                          }
                        });
                      } else {
                        setState(() {
                          urls.removeAt(i);
                          // files.removeAt(i);
                          // filePaths.removeAt(i);
                        });
                      }
                    },
                  ),
                ],
              ),
              height: 200,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(urls[i]),
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 12,
        ),

        ///
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: previewPhotoUrl == filePaths[i]
                          ? PRIMARY
                          : Colors.grey,
                    ),
                    onPressed: () {
                      if (previewPhotoUrl != filePaths[i]) {
                        setState(() {
                          previewPhotoUrl = filePaths[i];
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: RED,
                    ),
                    onPressed: () {
                      if (previewPhotoUrl == filePaths[i]) {
                        setState(() {
                          files.removeAt(i);
                          filePaths.removeAt(i);
                          try {
                            previewPhotoUrl = filePaths[0];
                          } catch (e) {
                            setState(() {
                              previewPhotoUrl = "";
                            });
                          }
                        });
                      } else {
                        setState(() {
                          files.removeAt(i);
                          filePaths.removeAt(i);
                        });
                      }
                    },
                  ),
                ],
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
          },
        ),
        SizedBox(
          height: 5,
        ),
        addMorePhoto(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget nameField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: nameController,
        autofocus: false,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 3,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).uShouldEnterTour;
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: S.of(context).enterTourName,
          hintStyle: TextStyle(
            color: GRAY,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  Widget descField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        controller: desController,
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: 10,
        autofocus: false,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return S.of(context).uShouldEnterDescription;
          }
          return null;
        },
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        onChanged: (value) {},
        decoration: InputDecoration(
          hintText: S.of(context).descEx,
          hintStyle: TextStyle(color: GRAY, fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
          contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: GRAY),
          ),
        ),
        obscureText: false,
      ),
    );
  }

  void _showMultiSelect(BuildContext context, S data) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: [
            MultiSelectItem("guide", data.guidedTour),
            MultiSelectItem("private", data.privateTour),
            MultiSelectItem("one_day_trip", data.oneDay),
            MultiSelectItem("nature", data.natuer),
            MultiSelectItem("ticket_must_have", data.ticketMustHave),
            MultiSelectItem("on_water", data.onWater),
            MultiSelectItem("package_tour", data.packageTour),
            MultiSelectItem("smallGroup", data.smallGroups),
            MultiSelectItem("invalid_friendly", data.invalidFriend),
            MultiSelectItem("history", data.history),
            MultiSelectItem("openAir", data.openAir),
            MultiSelectItem("streetArt", data.StreetArt),
            MultiSelectItem("adrenaline", data.adrenaline),
            MultiSelectItem("architecture", data.architecture),
            MultiSelectItem("food", data.food),
            MultiSelectItem("music", data.music),
            MultiSelectItem("for_couples_activities", data.forCouples),
            MultiSelectItem("for_activities", data.forKids),
            MultiSelectItem("museum", data.museums),
            MultiSelectItem("memorial", data.memorials),
            MultiSelectItem("park", data.parks),
            MultiSelectItem("gallery", data.galleries),
            MultiSelectItem("square", data.squares),
            MultiSelectItem("theater", data.theaters),
            MultiSelectItem("castle", data.castles),
            MultiSelectItem("towers", data.towers),
            MultiSelectItem("airports", data.airpots),
            MultiSelectItem("bicycle", data.bycicle),
            MultiSelectItem("minivan", data.minivan),
            MultiSelectItem("public_transport", data.pubTransport),
            MultiSelectItem("limousine", data.limousine),
            MultiSelectItem("car", data.car),
            MultiSelectItem("cruise", data.cruise),
            MultiSelectItem("fewDaysTrip", data.fewDaysTrip),
          ],
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Text(S.of(context).selectCategories,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          ),
          cancelText: Text(S.of(context).cancel),
          confirmText: Text(S.of(context).ok),
          initialValue: selectedCategories,
          listType: MultiSelectListType.CHIP,
          onConfirm: (values) {
            setState(() {
              selectedCategories = values;
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
    print("CURRENT CATEGORIES");
    print(selectedCategories);
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
              color: PRIMARY,
            ),
            Text(
              '   ' + S.of(context).addMorePics.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold, color: PRIMARY),
            )
          ],
        ));
  }

  // Widget sendToVerifyButton() {
  //   return RoundedLoadingButton(
  //     onPressed: () async {
  //       if (globalKey.currentState!.validate()) {
  //         if (filePaths.isNotEmpty) {
  //           CustomPhotoError cuf;
  //           String varl;
  //           if (!previewPhotoUrl
  //               .contains("http://res.cloudinary.com/space-developers")) {
  //             filePaths.remove(previewPhotoUrl);
  //             filePaths.insert(0, previewPhotoUrl);
  //             cuf = await context
  //                 .read<TourAdditionProvider>()
  //                 .addPhotos(filePaths);
  //             varl = cuf.urls[0];
  //           } else {
  //             cuf = await context
  //                 .read<TourAdditionProvider>()
  //                 .addPhotos(filePaths);
  //             varl = previewPhotoUrl;
  //           }
  //           print(cuf.urls);
  //           String? machineUrl;

  //           try {
  //             machineUrl = await context
  //                 .read<OfferEditProvider>()
  //                 .uploadCarPhoto(withTransfer, carPhoto, carPhotoPath);
  //           } catch (e) {
  //             if (e is NoCarPhotoSelectedException) {
  //               EasyLoading.showInfo(S.of(context).noCarPhotoSelectedWarn);
  //               return null;
  //             }
  //           }

  //           if (cuf.noError) {
  //             await context.read<OfferEditProvider>().updateTour(
  //               categories: {},
  //               tourID: widget.offerID,
  //               addTour: AddTour(
  //                 transferPhotoUrl: machineUrl,
  //                 mainPhotoUrl: varl,
  //                 seats: seatsController.text,
  //                 name: nameController.text,
  //                 description: desController.text,
  //                 withTransfer: withTransfer,
  //                 transfer: withTransfer,
  //                 alwaysAvailable: alwaysAvailable,
  //                 duration: durationController.text,
  //                 dateTime: date.text,
  //                 adultPrice: toSendCurrency(adultController.text),
  //                 meetingPoint: meetingPointController.text,
  //                 childPrice: toSendCurrency(childController.text),
  //                 included: includedController.text,
  //                 languages: languageController.text,
  //                 notIncluded: notIncludedController.text,
  //                 note: noteController.text,
  //                 prerequisites: prerequisitesController.text,
  //                 prohibitions: prohibitionsController.text,
  //                 urls: fromListToString(cuf.urls) + fromListToString2(urls),
  //               ),
  //             );
  //             //suceess ui show
  //           } else {
  //             //error show
  //           }
  //         } else {
  //           String? machineUrl;

  //           try {
  //             machineUrl = await context
  //                 .read<OfferEditProvider>()
  //                 .uploadCarPhoto(withTransfer, carPhoto, carPhotoPath);
  //           } catch (e) {
  //             if (e is NoCarPhotoSelectedException) {
  //               EasyLoading.showInfo(S.of(context).noCarPhotoSelectedWarn);
  //               return null;
  //             }
  //           }
  //           await context.read<OfferEditProvider>().updateTour(
  //             categories: {},
  //             tourID: widget.offerID,
  //             addTour: AddTour(
  //               mainPhotoUrl: previewPhotoUrl,
  //               transferPhotoUrl: machineUrl,
  //               seats: seatsController.text,
  //               name: nameController.text,
  //               description: desController.text,
  //               withTransfer: withTransfer,
  //               transfer: withTransfer,
  //               alwaysAvailable: alwaysAvailable,
  //               duration: durationController.text,
  //               dateTime: date.text,
  //               adultPrice: toSendCurrency(adultController.text),
  //               meetingPoint: meetingPointController.text,
  //               childPrice: toSendCurrency(childController.text),
  //               included: includedController.text,
  //               languages: languageController.text,
  //               notIncluded: notIncludedController.text,
  //               note: noteController.text,
  //               prerequisites: prerequisitesController.text,
  //               prohibitions: prohibitionsController.text,
  //               urls: fromListToString(urls),
  //             ),
  //           );
  //           //success show
  //         }
  //       } else {
  //         //error show

  //         EasyLoading.showError(S.of(context).fieldShouldntBe);
  //       }
  //     },
  //     child: Text(
  //       S.of(context).save,
  //       style: TextStyle(
  //           color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
  //     ),
  //     color: Colors.blue[600],
  //     width: double.maxFinite,
  //   );
  // }
  String? getDateee() {
    if (date.text == "" || date.text == " " || date.text.isEmpty) {
      return null;
    } else {
      return date.text;
    }
  }

  String? getTimeee() {
    if (time.text == "" || time.text == " " || time.text.isEmpty) {
      return null;
    } else {
      return time.text + ":00.000";
    }
  }

  Map<String, String> initMainCategories() {
    Map<String, String> ctg = {
      "guide": "false",
      "private": "false",
      "one_day_trip": "false",
      "nature": "false",
      "ticket_must_have": "false",
      "on_water": "false",
      "package_tour": "false",
      "small_group": "false",
      "invalid_friendly": "false",
      "history": "false",
      "open_air": "false",
      "street_art": "false",
      "adrenaline": "false",
      "architecture": "false",
      "food": "false",
      "music": "false",
      "for_couples_activities": "false",
      "for_kids_activities": "false",
      "museum": "false",
      "memorial": "false",
      "park": "false",
      "gallery": "false",
      "square": "false",
      "theater": "false",
      "castle": "false",
      "towers": "false",
      "airports": "false",
      "bicycle": "false",
      "minivan": "false",
      "public_transport": "false",
      "limousine": "false",
      "car": "false",
      "cruise": "false",
      "hunting": "false",
      "adventure": "false",
      "fishing": "false",
      "night": "false",
      "game": "false",
      "only_transfer": "false",
      "fewDaysTrip": "false"
    };
    selectedCategories.forEach((element) {
      ctg[element.toString()] = "true";
    });
    return ctg;
  }

  Future<void> onDoneLogic() async {
    EasyLoading.show(status: S.of(context).loading);
    if (filePaths.isNotEmpty) {
      if (alwaysAvailable) {}
      CustomPhotoError cuf;
      String varl;
      if (!previewPhotoUrl
          .contains("http://res.cloudinary.com/space-developers")) {
        filePaths.remove(previewPhotoUrl);
        filePaths.insert(0, previewPhotoUrl);
        cuf = await context.read<TourAdditionProvider>().addPhotos(filePaths);
        varl = cuf.urls[0];
      } else {
        cuf = await context.read<TourAdditionProvider>().addPhotos(filePaths);
        varl = previewPhotoUrl;
      }
      print(cuf.urls);
      String? machineUrl;

      try {
        machineUrl = await context
            .read<OfferEditProvider>()
            .uploadCarPhoto(withTransfer, carPhoto, carPhotoPath);
      } catch (e) {
        if (e is NoCarPhotoSelectedException) {
          EasyLoading.showInfo(S.of(context).noCarPhotoSelectedWarn);
          return null;
        }
      }

      if (cuf.noError) {
        await context.read<OfferEditProvider>().updateTour(
              categories: initMainCategories(),
              tourID: widget.offerID,
              addTour: AddTour(
                  transferPhotoUrl: machineUrl,
                  mainPhotoUrl: varl,
                  seats: seatsController.text,
                  name: nameController.text,
                  description: desController.text,
                  withTransfer: withTransfer,
                  transfer: withTransfer,
                  alwaysAvailable: alwaysAvailable,
                  duration: durationController.text,
                  dateTime: getDateee(),
                  adultPrice: adultController.text,
                  meetingPoint: meetingPointController.text,
                  childPrice: childController.text,
                  included: includedController.text,
                  languages: toUploadLanguages,
                  notIncluded: notIncludedController.text,
                  note: noteController.text,
                  prerequisites: prerequisitesController.text,
                  prohibitions: prohibitionsController.text,
                  urls: fromListToString(cuf.urls) + fromListToString2(urls),
                  days: ddays,
                  freeTicketNote: freeTicketController.text,
                  time: getTimeee()),
            );

        Navigator.pop(context);
        Navigator.pop(context);
        EasyLoading.dismiss();
        pushNewScreen(
          context,
          screen: TourSentScreen(
              tourName: nameController.text,
              adultPrice: double.parse(getTotalAmount(true)),
              seats: int.parse(seatsController.text),
              description: "",
              price: "",
              photoUrl: cuf.urls[0]),
        );
      } else {
        EasyLoading.showError(S.of(context).errorOccured);
      }
    } else {
      if (alwaysAvailable) {}
      String? machineUrl;

      try {
        machineUrl = await context
            .read<OfferEditProvider>()
            .uploadCarPhoto(withTransfer, carPhoto, carPhotoPath);
      } catch (e) {
        if (e is NoCarPhotoSelectedException) {
          EasyLoading.showInfo(S.of(context).noCarPhotoSelectedWarn);
          return null;
        }
      }
      await context.read<OfferEditProvider>().updateTour(
            categories: initMainCategories(),
            tourID: widget.offerID,
            addTour: AddTour(
                mainPhotoUrl: previewPhotoUrl,
                transferPhotoUrl: machineUrl,
                seats: seatsController.text,
                name: nameController.text,
                description: desController.text,
                withTransfer: withTransfer,
                transfer: withTransfer,
                alwaysAvailable: alwaysAvailable,
                duration: durationController.text,
                dateTime: getDateee(),
                adultPrice: adultController.text,
                meetingPoint: meetingPointController.text,
                childPrice: childController.text,
                included: includedController.text,
                languages: toUploadLanguages,
                notIncluded: notIncludedController.text,
                note: noteController.text,
                prerequisites: prerequisitesController.text,
                prohibitions: prohibitionsController.text,
                urls: fromListToString(urls),
                days: ddays,
                freeTicketNote: freeTicketController.text,
                time: getTimeee()),
          );
      EasyLoading.dismiss();
      Navigator.pop(context);
      Navigator.pop(context);

      pushNewScreen(
        context,
        screen: TourSentScreen(
            tourName: nameController.text,
            description: "",
            price: "",
            adultPrice: double.parse(getTotalAmount(true)),
            seats: int.parse(seatsController.text),
            photoUrl: urls[0]),
      );
    }
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

  String fromListToString2(List<String>? list) {
    if (list != null) {
      if (list.isNotEmpty) {
        String s = list.join('|');
        return "|" + s;
      } else {
        return "";
      }
    } else {
      return "";
    }
  }

  String toSendCurrency(String value) {
    double temp = double.parse(value);
    if (currency == "USD") {
      return temp.toString();
    } else if (currency == "EUR") {
      return (temp * EURO).toString();
    } else if (currency == "AED") {
      return (temp * DIRHAM).toString();
    } else if (currency == "RUB") {
      return (temp * ROUBLE).toString();
    } else if (currency == "THB") {
      return (temp * BAHT).toString();
    } else if (currency == "TRY") {
      return (temp * LIRA).toString();
    }

    return value;
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
      if (value.isEmpty || value == "" || value == "null") {
        return "";
      }
      val = double.parse(value);
    } catch (e) {
      return "0.0";
    }
    if (value.isEmpty || value == "" || value == "null") {
      return "";
    }

    if (val < 10 && val >= 0) {
      val = val + 2;
    } else if (val >= 10 && val < 31) {
      double perc = (val * 20) / 100;
      val = val + perc;
    } else if (val >= 31 && val < 40) {
      val = val + 7;
    } else if (val >= 40 && val < 131) {
      double perc = (val * 18) / 100;
      val = val + perc;
    } else if (val >= 131 && val < 231) {
      val = val + 30;
    } else if (val >= 231 && val < 501) {
      double perc = (val * 13) / 100;
      val = val + perc;
    } else if (val >= 501) {
      double perc = (val * 10) / 100;
      val = val + perc;
    }

    return val.toString();
  }

  String getTotalWithComissionReversed(String value) {
    double val;

    try {
      val = double.parse(value);
    } catch (e) {
      return "0.0";
    }

    if (val < 10 && val >= 0) {
      val = val - 2;
    } else if (val >= 10 && val < 31) {
      double perc = 1 + (20 / 100);
      val = val / perc;
    } else if (val >= 31 && val < 40) {
      val = val - 7;
    } else if (val >= 40 && val < 131) {
      double perc = 1 + (18 / 100);
      val = val / perc;
    } else if (val >= 131 && val < 231) {
      val = val - 30;
    } else if (val >= 231 && val < 501) {
      double perc = 1 + (13 / 100);
      val = val / perc;
    } else if (val >= 501) {
      double perc = 1 + (10 / 100);
      val = val / perc;
    }

    return val.round().toString();
  }

  Widget slider() {
    if (filePaths.isEmpty && urls.isEmpty) {
      return Container();
    } else {
      List<String> general = filePaths + urls;
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: general.length,
                itemBuilder:
                    (BuildContext ctx, int itemIndex, int pageViewIndex) =>
                        Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: OctoImage(
                      image: getImageObjectForSlider(value: general[itemIndex]),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.height / 1.5,
                    ),
                  ),
                ),
                options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    enlargeCenterPage: false),
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: filePaths.asMap().entries.map((entry) {
            //     return GestureDetector(
            //       onTap: () => carouselController.animateToPage(entry.key),
            //       child: Container(
            //         width: 9.0,
            //         height: 9.0,
            //         margin:
            //             EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: (Theme.of(context).brightness == Brightness.dark
            //                     ? Colors.white
            //                     : Colors.black)
            //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
            //       ),
            //     );
            //   }).toList(),
            // ),
          ],
        ),
      );
    }
  }

  ImageProvider<Object> getImageObjectForSlider({required String value}) {
    if (value.contains("http://res.cloudinary.com/space-developers")) {
      return NetworkImage(value);
    } else {
      return FileImage(File(value));
    }
  }
}
