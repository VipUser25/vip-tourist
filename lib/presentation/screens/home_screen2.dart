import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/mini_tour.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/weather_provider.dart';
import 'package:vip_tourist/logic/utility/city_tour_search.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/cataog_screen.dart';
import 'package:vip_tourist/presentation/screens/tours_on_map_screen.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/tour_define_screen.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:vip_tourist/presentation/widgets/horizontal_list.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatefulWidget {
  final String cityName;
  final String countryName;
  final String cityID;
  final List<MiniCity> list;

  const HomeScreen2(
      {Key? key,
      required this.cityID,
      required this.list,
      required this.cityName,
      required this.countryName})
      : super(key: key);

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().getWeatherData(cityID: widget.cityID);
    });
    super.initState();
  }

  List<dynamic> selectedCategories = [];
  String filterSuffix = "";
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final data = Provider.of<HomeScreenTourProvider>(context);
    final authData = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        //toolbarHeight: 60,
        centerTitle: true, automaticallyImplyLeading: false,

        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.search),
        //     onPressed: () async {
        //       bool? res;
        //       try {
        //         res = !context.read<AuthProvider>().user.isTourist;
        //       } catch (e) {}

        //       showSearch(
        //         context: context,
        //         delegate: CityTourSearch(
        //             suggestCities: widget.list,
        //             isGuide: res,
        //             data: data,
        //             locale: locale,
        //             search: S.of(context).enterCity),
        //       );
        //     },
        //   )
        // ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<WeatherProvider>().nullifyWeather();
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
      extendBodyBehindAppBar: true,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          context.read<WeatherProvider>().nullifyWeather();
          return Future.value(false);
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              cityTours(context, data, locale),
              const SizedBox(
                height: 25,
              ),
              cityInfoBlock(width: width, weatherProvider: weatherProvider),
              const SizedBox(
                height: 25,
              ),
              categoriesBlock(),
              const SizedBox(
                height: 10,
              ),
              FutureBuilder<Map<String, MiniTour>>(
                future: data.getCustomTours(
                    locale.languageCode, widget.cityID, filterSuffix),
                builder: (context, snapshot) {
                  print(locale.languageCode);
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Container(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(PRIMARY),
                          ),
                        ),
                      );

                    default:
                      if (snapshot.hasError) {
                        if (snapshot.error is NoInternetConnection) {
                          return noInternetConnec();
                        } else {
                          return noData();
                        }
                      } else if (snapshot.connectionState ==
                              ConnectionState.none ||
                          !snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return noData();
                      } else {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 20),
                          child: Column(
                            children: [
                              HorizontalList(
                                  headerText: S.of(context).guidedTour,
                                  keyword: "guideTour",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).privateTour,
                                  keyword: "privateTour",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).oneDay,
                                  keyword: "oneDayTrip",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).natuer,
                                  keyword: "nature",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).ticketMustHave,
                                  keyword: "ticketMustHave",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).onWater,
                                  keyword: "onWater",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).packageTour,
                                  keyword: "packageTour",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).smallGroups,
                                  keyword: "smallGroup",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).invalidFriend,
                                  keyword: "invalidFriendly",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).history,
                                  keyword: "history",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).openAir,
                                  keyword: "openAir",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).StreetArt,
                                  keyword: "streetArt",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).adrenaline,
                                  keyword: "adrenaline",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).architecture,
                                  keyword: "architecture",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).food,
                                  keyword: "food",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).music,
                                  keyword: "music",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).forCouples,
                                  keyword: "forCouples",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).forKids,
                                  keyword: "forKids",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).museums,
                                  keyword: "museum",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).memorials,
                                  keyword: "memorial",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).parks,
                                  keyword: "park",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).galleries,
                                  keyword: "gallery",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).squares,
                                  keyword: "square",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).theaters,
                                  keyword: "theater",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).castles,
                                  keyword: "castle",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).towers,
                                  keyword: "towers",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).airpots,
                                  keyword: "airports",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).bycicle,
                                  keyword: "bicycle",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).minivan,
                                  keyword: "minivan",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).pubTransport,
                                  keyword: "publicTransport",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).limousine,
                                  keyword: "limousine",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).car,
                                  keyword: "car",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).cruise,
                                  keyword: "cruise",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).hunting,
                                  keyword: "hunting",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).adventure,
                                  keyword: "adventure",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).fishing,
                                  keyword: "fishing",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).night,
                                  keyword: "night",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).game,
                                  keyword: "game",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).onlyTransfer,
                                  keyword: "onlyTransfer",
                                  tours: snapshot.data!,
                                  locale: locale),
                              HorizontalList(
                                  headerText: S.of(context).fewDaysTrip,
                                  keyword: "fewDaysTrip",
                                  tours: snapshot.data!,
                                  locale: locale),
                            ],
                          ),
                        );
                      }
                  }
                },
              ),
              // data.cityID == null
              //     ? Container()
              //     : exporeButton(data: data, locale: locale),
              // SizedBox(
              //   height: 15,
              // ),
              // Padding(
              //   padding: EdgeInsets.only(left: 15, right: 15),
              //   child: lookCityButton(data: data, locale: locale),
              // ),
              // authData.user.getIsVerified!
              //     ? SizedBox(
              //         height: 10,
              //       )
              //     : Container(),
              // authData.user.getIsVerified!
              //     ? Padding(
              //         child: addTourButton(),
              //         padding: EdgeInsets.only(left: 15, right: 15),
              //       )
              //     : Container(),
              lookToursOnMapButton(data: data, locale: locale),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget cityTours(
      BuildContext ctx, HomeScreenTourProvider data, Locale locale) {
    return FutureBuilder<CustomCity>(
      future: data.getCustomCity(widget.cityID),
      builder: (ctx, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY),
                ),
              ),
            );

          default:
            return haveCitySelected(
                data: data,
                customCity: snapshot.data!,
                locale: locale,
                mcID: widget.cityID);
        }
      },
    );
    // if (data.cityID == null) {
    //   return
    // } else {
    //   return Container(
    //     width: double.maxFinite,
    //     child: haveCitySelected(data),
    //     height: MediaQuery.of(ctx).size.height / 2.9,
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: NetworkImage(data.cityPhoto!),
    //         colorFilter: ColorFilter.mode(
    //             Colors.black.withOpacity(0.5), BlendMode.darken),
    //         fit: BoxFit.fitHeight,
    //       ),
    //     ),
    //   );
    // }
  }

  Widget cityInfoBlock(
      {required double width, required WeatherProvider weatherProvider}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                " " + widget.cityName,
                style: TextStyle(
                    color: GREEN_BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.location_on,
                    color: PRIMARY,
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  Text(
                    widget.countryName + ", " + widget.cityName,
                    style: TextStyle(color: GRAY, fontSize: 16),
                  ),
                ],
              )
            ],
          ),
          getExactWeatherWidgets(weatherProvider)
        ],
      ),
    );
  }

  Widget getExactWeatherWidgets(WeatherProvider weatherProvider) {
    if (weatherProvider.cityWeather != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            getWeatherIcon(weatherProvider.cityWeather!.fallout),
            size: 33,
            color: GREEN_BLACK,
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            " " + weatherProvider.cityWeather!.temperature.toString() + " °C",
            style: TextStyle(
                color: GREEN_BLACK, fontWeight: FontWeight.bold, fontSize: 21),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: SizedBox(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY),
          ),
          height: 20,
          width: 20,
        ),
      );
    }
  }

  IconData getWeatherIcon(String code) {
    if (code.contains("01")) {
      return WeatherIcons.day_sunny;
    } else if (code.contains("02")) {
      return WeatherIcons.day_cloudy_gusts;
    } else if (code.contains("03")) {
      return WeatherIcons.day_cloudy;
    } else if (code.contains("04")) {
      return WeatherIcons.day_cloudy_high;
    } else if (code.contains("09")) {
      return WeatherIcons.day_rain;
    } else if (code.contains("10")) {
      return WeatherIcons.day_rain_mix;
    } else if (code.contains("11")) {
      return WeatherIcons.day_thunderstorm;
    } else if (code.contains("13")) {
      return WeatherIcons.day_snow;
    } else if (code.contains("50")) {
      return WeatherIcons.fog;
    } else {
      return WeatherIcons.day_sunny;
    }
  }

  Widget templateBlock(
      {required String text,
      required IconData icon,
      required dynamic Function() dor}) {
    return SizedBox(
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(1),
            child: IconButton(
              padding: EdgeInsets.all(0),
              onPressed: dor,
              icon: Icon(
                icon,
                size: 33,
                color: PRIMARY,
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: LIGHT_GRAY),
              borderRadius: BorderRadius.circular(
                6,
              ),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                color: GREEN_BLACK, fontSize: 13, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }

  Widget categoriesBlock() {
    return Padding(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            templateBlock(
                text: S.of(context).all,
                icon: Icons.menu,
                dor: () {
                  _showMultiSelect(context, S.of(context));
                }),
            const SizedBox(
              width: 6,
            ),
            templateBlock(
                text: S.of(context).guidedTour,
                icon: Icons.emoji_people_sharp,
                dor: () {
                  setState(() {
                    filterSuffix = "&_guide=true";
                  });
                }),
            const SizedBox(
              width: 6,
            ),
            templateBlock(
                text: S.of(context).oneDay2,
                icon: Icons.watch_later,
                dor: () {
                  setState(() {
                    filterSuffix = "&_one_day_trip=true";
                  });
                }),
            const SizedBox(
              width: 6,
            ),
            templateBlock(
                text: S.of(context).private2,
                icon: Icons.supervisor_account_rounded,
                dor: () {
                  setState(() {
                    filterSuffix = "&_private=true";
                  });
                }),
            const SizedBox(
              width: 6,
            ),
            templateBlock(
                text: S.of(context).package,
                icon: CupertinoIcons.location_solid,
                dor: () {
                  setState(() {
                    filterSuffix = "&_package_tour=true";
                  });
                }),
          ],
        ),
      ),
      padding: EdgeInsets.only(left: 15, right: 15),
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
            MultiSelectItem("small_group", data.smallGroups),
            MultiSelectItem("invalid_friendly", data.invalidFriend),
            MultiSelectItem("history", data.history),
            MultiSelectItem("open_air", data.openAir),
            MultiSelectItem("street_art", data.StreetArt),
            MultiSelectItem("adrenaline", data.adrenaline),
            MultiSelectItem("architecture", data.architecture),
            MultiSelectItem("food", data.food),
            MultiSelectItem("music", data.music),
            MultiSelectItem("for_couples_activities", data.forCouples),
            MultiSelectItem("for_kids_activities", data.forKids),
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
            MultiSelectItem("hunting", data.hunting),
            MultiSelectItem("adventure", data.adventure),
            MultiSelectItem("fishing", data.fishing),
            MultiSelectItem("night", data.night),
            MultiSelectItem("game", data.game),
            MultiSelectItem("onlyTransfer", data.onlyTransfer),
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
            String temp = "";
            values.forEach((element) {
              temp = temp + "&_" + element.toString() + "=true";
            });
            setState(() {
              filterSuffix = temp;
              selectedCategories = values;
            });
          },
          maxChildSize: 0.8,
        );
      },
    );
  }

  Widget haveCitySelected(
      {required HomeScreenTourProvider data,
      required CustomCity customCity,
      required Locale locale,
      required String mcID}) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.8,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            customCity.photo,
          ),
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          // Column(
          //   children: [
          //     Text(
          //       customCity.name,
          //       style: TextStyle(
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white,
          //           fontSize: 30),
          //     ),
          //     SizedBox(
          //       height: 20,
          //     ),
          //     Text(
          //       DateFormat("dd MMMM, yyyy, HH:mm").format(DateTime.now()),
          //       style: TextStyle(fontSize: 18, color: Colors.white),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                shape: StadiumBorder(),
                onPressed: () {
                  final time = DateTime.now();
                  String date = time.toIso8601String().substring(0, 10);
                  pushNewScreen(
                    context,
                    screen:
                        CatalogScreen(locale: locale, date: date, cityID: mcID),
                  );
                },
                color: Colors.white,
                child: Text(
                  S.of(context).today,
                  style: TextStyle(
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              MaterialButton(
                shape: StadiumBorder(),
                onPressed: () {
                  final time = DateTime.now().add(Duration(days: 1));
                  String date = time.toIso8601String().substring(0, 10);
                  pushNewScreen(
                    context,
                    screen:
                        CatalogScreen(locale: locale, date: date, cityID: mcID),
                  );
                },
                color: Colors.white,
                child: Text(
                  S.of(context).tommorow,
                  style: TextStyle(
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              MaterialButton(
                shape: StadiumBorder(),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  ).then(
                    (selectedData) {
                      final time = selectedData;
                      if (time != null) {
                        String date = time.toIso8601String().substring(0, 10);
                        pushNewScreen(
                          context,
                          screen: CatalogScreen(
                              locale: locale, date: date, cityID: mcID),
                        );
                      }
                    },
                  );
                },
                color: Colors.white,
                child: Icon(
                  Icons.calendar_today,
                  color: GREEN_BLACK,
                  size: 20,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget noCitySelected(
      {required BuildContext ctx,
      required HomeScreenTourProvider data,
      required Locale locale}) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(ctx).size.height / 2.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/building.jpg"),
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 60),
          Text(
            S.of(context).tagOne,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          MaterialButton(
            onPressed: () {
              bool? res;
              try {
                res = !context.read<AuthProvider>().user.isTourist;
              } catch (e) {}

              showSearch(
                  context: context,
                  delegate: CityTourSearch(
                      suggestCities: widget.list,
                      data: data,
                      isGuide: res,
                      locale: locale,
                      search: S.of(context).enterCity));
            },
            child: Text(
              S.of(context).search,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500),
            ),
            color: Colors.blue[600],
            minWidth: MediaQuery.of(context).size.width / 1.5,
            padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          )
        ],
      ),
    );
  }

  Widget exporeButton({
    required HomeScreenTourProvider data,
    required Locale locale,
  }) {
    return Column(
      children: [
        Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
        GestureDetector(
          onTap: () async {
            EasyLoading.show(status: S.of(context).loading);
            List<MapTourItem> lst =
                await data.getToursForMap2(localeCode: locale.languageCode);
            if (lst.isNotEmpty) {
              EasyLoading.dismiss();
              pushNewScreen(
                context,
                screen: ToursOnMapScreen(
                  tours: lst,
                  locale: locale,
                  cityID: data.cityID,
                ),
              );
            } else {
              EasyLoading.showInfo(S.of(context).noToursHomeScreenTag);
            }
          },
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      '${S.of(context).discover}',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.grey[900],
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                )
              ],
            ),
          ),
        ),
        Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }

  Padding lookToursOnMapButton({
    required HomeScreenTourProvider data,
    required Locale locale,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: ElevatedButton(
          onPressed: () async {
            EasyLoading.show(status: S.of(context).loading);
            List<MapTourItem> lst =
                await data.getToursForMap2(localeCode: locale.languageCode);
            if (lst.isNotEmpty) {
              EasyLoading.dismiss();
              pushNewScreen(
                context,
                screen: ToursOnMapScreen(
                  tours: lst,
                  locale: locale,
                  cityID: data.cityID,
                ),
              );
            } else {
              EasyLoading.showInfo(S.of(context).noToursHomeScreenTag);
            }
          },
          child: Text(S.of(context).lookToursOnMap)),
    );
  }

  Widget lookCityButton(
      {required HomeScreenTourProvider data, required Locale locale}) {
    return MaterialButton(
      onPressed: () {
        bool? res;
        try {
          res = !context.read<AuthProvider>().user.isTourist;
        } catch (e) {}

        showSearch(
          context: context,
          delegate: CityTourSearch(
              suggestCities: widget.list,
              data: data,
              locale: locale,
              search: S.of(context).enterCity,
              isGuide: res),
        );
      },
      child: Text(
        S.of(context).lookCity,
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

  Widget addTourButton() {
    return MaterialButton(
      onPressed: () => pushNewScreen(
        context,
        screen: TourDefineScreen(),
        withNavBar: false,
      ),
      child: Text(
        S.of(context).addTour,
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

  Widget noInternetConnec() {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        OctoImage(
          image: AssetImage("assets/cancel.png"),
          height: 150,
        ),
        Shimmer.fromColors(
          baseColor: Colors.orange,
          highlightColor: Colors.orange.withOpacity(0.2),
          period: Duration(seconds: 2),
          child: Text(
            S.of(context).sorry,
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Shimmer.fromColors(
          period: Duration(seconds: 2),
          baseColor: Colors.blue,
          highlightColor: Colors.blue.withOpacity(0.2),
          child: Text(
            S.of(context).noInternetCon,
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 60,
        ),
      ],
    );
  }

  Widget cityPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey,
      highlightColor: Colors.red,
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height / 2.3,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget noData() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        OctoImage(
          image: AssetImage('assets/notours2.png'),
          height: 200,
        ),
        SizedBox(
          height: 40,
        ),
        Shimmer.fromColors(
          baseColor: GREEN_GRAY,
          highlightColor: Colors.grey.withOpacity(0.2),
          period: Duration(seconds: 2),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: Text(
              S.of(context).noToursHomeScreenTag,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600, color: GREEN_GRAY),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        getFot(context),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getFot(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30),
        child: TextButton(
          onPressed: () async {
            await launch(
                'mailto:support@viptourist.club?subject=&body=${S.of(context).texttouristaddcity2}');
          },
          child: Text(
            S.of(context).touristyouCanSendInquiry2,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: PRIMARY),
          ),
        ),
      ),
    );
  }
}
