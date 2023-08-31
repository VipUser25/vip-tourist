import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/filter_tour_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/tour_define_screen.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:vip_tourist/presentation/widgets/horizontal_list.dart';

import '../../logic/models/mini_tour.dart';
import '../../logic/providers/localization_provider.dart';

class CatalogScreen extends StatefulWidget {
  final String? cityID;
  final String? value;
  final String? date;
  final Locale locale;
  const CatalogScreen(
      {Key? key, this.cityID, required this.locale, this.value, this.date})
      : super(key: key);

  @override
  _CatalogScreenState createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late RoundedLoadingButtonController rc1;
  late RoundedLoadingButtonController rc2;

  String? tourSort;
  String? tourFilter;
  @override
  void initState() {
    // TODO: implement initState
    rc1 = RoundedLoadingButtonController();
    rc2 = RoundedLoadingButtonController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FilterTourProvider>(context);
    final authData = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).catalog,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: () => _showMultiSelect(context),
                          icon: Icon(
                            Icons.filter_alt,
                            color: GREEN_BLACK,
                          ),
                          label: Text(
                            S.of(context).filter,
                            style: TextStyle(color: GREEN_BLACK, fontSize: 16),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            dynamic sort = await showConfirmationDialog(
                              barrierDismissible: false,
                              context: context,
                              title: S.of(context).sortBy,
                              shrinkWrap: true,
                              actions: <AlertDialogAction>[
                                AlertDialogAction(
                                    key: "&_sort=rating",
                                    label: S.of(context).rating),
                                AlertDialogAction(
                                    key: "&_sort=name",
                                    label: S.of(context).name),
                                AlertDialogAction(
                                    key: "&_sort=reviews_count",
                                    label: S.of(context).reviewCount),
                                AlertDialogAction(
                                    key: "&_sort=price:ASC",
                                    label: S.of(context).priceAsc),
                                AlertDialogAction(
                                  key: "&_sort=price:DESC",
                                  label: S.of(context).priceDesc,
                                ),
                              ],
                            );
                            if (sort != null) {
                              setState(() {
                                tourSort = sort.toString();
                              });
                            }
                          },
                          icon: Icon(
                            Icons.sort,
                            color: GREEN_BLACK,
                          ),
                          label: Text(
                            S.of(context).sort,
                            style: TextStyle(color: GREEN_BLACK, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: LIGHT_GRAY,
                    thickness: 1,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: FutureBuilder<List<TempCatalogTour>>(
                  future: getFunction(context, data),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                            ),
                            Center(child: CircularProgressIndicator()),
                          ],
                        );

                      default:
                        if (snapshot.hasError ||
                            !snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: noData(authData),
                          );
                        } else {
                          Map<String, MiniTour> tours = {};
                          snapshot.data!.forEach((element) {
                            tours.putIfAbsent(
                              element.tourID,
                              () => MiniTour(
                                  tourID: element.tourID,
                                  name: element.name,
                                  photoURL: element.image,
                                  rating: element.rating,
                                  price: element.price,
                                  category: element.categories,
                                  duration: element.duration,
                                  reviews: element.reviews),
                            );
                          });
                          return Column(
                            children: [
                              HorizontalList(
                                  headerText: S.of(context).guidedTour,
                                  keyword: "guideTour",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).privateTour,
                                  keyword: "privateTour",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).oneDay,
                                  keyword: "oneDayTrip",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).natuer,
                                  keyword: "nature",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).ticketMustHave,
                                  keyword: "ticketMustHave",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).onWater,
                                  keyword: "onWater",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).packageTour,
                                  keyword: "packageTour",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).smallGroups,
                                  keyword: "smallGroup",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).invalidFriend,
                                  keyword: "invalidFriendly",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).history,
                                  keyword: "history",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).openAir,
                                  keyword: "openAir",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).StreetArt,
                                  keyword: "streetArt",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).adrenaline,
                                  keyword: "adrenaline",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).architecture,
                                  keyword: "architecture",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).food,
                                  keyword: "food",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).music,
                                  keyword: "music",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).forCouples,
                                  keyword: "forCouples",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).forKids,
                                  keyword: "forKids",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).museums,
                                  keyword: "museum",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).memorials,
                                  keyword: "memorial",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).parks,
                                  keyword: "park",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).galleries,
                                  keyword: "gallery",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).squares,
                                  keyword: "square",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).theaters,
                                  keyword: "theater",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).castles,
                                  keyword: "castle",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).towers,
                                  keyword: "towers",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).airpots,
                                  keyword: "airports",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).bycicle,
                                  keyword: "bicycle",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).minivan,
                                  keyword: "minivan",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).pubTransport,
                                  keyword: "publicTransport",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).limousine,
                                  keyword: "limousine",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).car,
                                  keyword: "car",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).cruise,
                                  keyword: "cruise",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).hunting,
                                  keyword: "hunting",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).adventure,
                                  keyword: "adventure",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).fishing,
                                  keyword: "fishing",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).night,
                                  keyword: "night",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).game,
                                  keyword: "game",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).onlyTransfer,
                                  keyword: "onlyTransfer",
                                  tours: tours,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).fewDaysTrip,
                                  keyword: "fewDaysTrip",
                                  tours: tours,
                                  locale: locale)
                            ],
                          );
                        }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<TempCatalogTour>> getFunction(
      BuildContext ctx, FilterTourProvider data) {
    if (widget.cityID == null && widget.date == null) {
      print("GET TORUS BY VALUE SELECTED");
      return data.getToursByValue(
          value: widget.value!, localeCode: widget.locale.languageCode);
    } else if (widget.cityID != null && widget.date == null) {
      print("GET TORUS BY CITY SELECTED");
      return data.getToursPerCityForCatalog(
          cityID: widget.cityID!,
          localeCode: widget.locale.languageCode,
          sort: tourSort,
          filter: tourFilter);
    } else if (widget.date != null) {
      print("GET TORUS BY DATE SELECTED");
      return data.getToursByDate(
          cityID: widget.cityID!,
          localeCode: widget.locale.languageCode,
          date: widget.date!,
          filter: tourFilter,
          sort: tourSort);
    } else {
      return data.getEmptyList();
    }
  }

  void _showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          title: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: Text(
              S.of(context).select,
              style: TextStyle(fontSize: 18.5),
            ),
          ),
          items: [
            MultiSelectItem("&_guide=true", S.of(context).guidedTour),
            MultiSelectItem("&_private=true", S.of(context).privateTour),
            MultiSelectItem("&_one_day_trip=true", S.of(context).oneDay),
            MultiSelectItem("&_nature=true", S.of(context).natuer),
            MultiSelectItem(
                "&_ticket_must_have=true", S.of(context).ticketMustHave),
            MultiSelectItem("&_on_water=true", S.of(context).onWater),
            MultiSelectItem("&_package_tour=true", S.of(context).packageTour),
            MultiSelectItem("&_small_group=true", S.of(context).smallGroups),
            MultiSelectItem(
                "&_invalid_friendly=true", S.of(context).invalidFriend),
            MultiSelectItem("&_history=true", S.of(context).history),
            MultiSelectItem("&_world_war=true", S.of(context).worldWar),
            MultiSelectItem("&_open_air=true", S.of(context).openAir),
            MultiSelectItem("&_street_art=true", S.of(context).StreetArt),
            MultiSelectItem("&_adrenaline=true", S.of(context).adrenaline),
            MultiSelectItem("&_architecture=true", S.of(context).architecture),
            MultiSelectItem("&_food=true", S.of(context).food),
            MultiSelectItem("&_music=true", S.of(context).music),
            MultiSelectItem(
                "&_for_couples_activities=true", S.of(context).forCouples),
            MultiSelectItem(
                "&_for_kids_activities=true", S.of(context).forKids),
            MultiSelectItem("&_museum=true", S.of(context).museums),
            MultiSelectItem("&_memorial=true", S.of(context).memorials),
            MultiSelectItem("&_park=true", S.of(context).parks),
            MultiSelectItem("&_gallery=true", S.of(context).galleries),
            MultiSelectItem("&_square=true", S.of(context).squares),
            MultiSelectItem("&_theater=true", S.of(context).theaters),
            MultiSelectItem("&_castle=true", S.of(context).castles),
            MultiSelectItem("&_towers=true", S.of(context).towers),
            MultiSelectItem("&_airports=true", S.of(context).airpots),
            MultiSelectItem("&_bicycle=true", S.of(context).bycicle),
            MultiSelectItem(
                "&_public_transport=true", S.of(context).pubTransport),
            MultiSelectItem("&_limousine=true", S.of(context).limousine),
            MultiSelectItem("&_car=true", S.of(context).car),
            MultiSelectItem("&_cruise=true", S.of(context).cruise),
          ],
          initialValue: [],
          onConfirm: (values) {
            String tempConc = "";
            values.forEach((element) {
              print(element);
              tempConc = tempConc + element.toString();
            });
            setState(() {
              tourFilter = tempConc;
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  Widget noData(AuthProvider authData) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
          ),
          OctoImage(
            image: AssetImage("assets/nodis.png"),
            height: 250,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            S.of(context).noDataFound,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.5,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 8,
          ),
          authData.user.isVerified!
              ? TextButton.icon(
                  onPressed: () {
                    authData.controller.jumpToTab(4);
                    pushNewScreen(context,
                        screen: TourDefineScreen(), withNavBar: false);
                  },
                  icon: Icon(
                    Icons.add,
                    size: 28,
                  ),
                  label: Text(
                    S.of(context).createNewTour,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
              : Center(
                  child: TextButton(
                    onPressed: () async {
                      await launch(
                          'mailto:support@viptourist.club?subject=&body=${S.of(context).texttouristaddcity2}');
                    },
                    child: Text(
                      S.of(context).touristyouCanSendInquiry2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
