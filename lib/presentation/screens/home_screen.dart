import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/filter_tour_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/utility/city_tour_search.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/home_screen2.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/screens/cataog_screen.dart';
import 'package:vip_tourist/presentation/screens/tours_on_map_screen.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/tour_define_screen.dart';
import 'package:unique_list/unique_list.dart';
import 'package:vip_tourist/presentation/widgets/home_tour_item.dart';
import 'package:provider/provider.dart';

import '../../logic/providers/detail_tour_provider.dart';
import '../../logic/providers/home_cities_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<MiniCity> suggestCities = [];

  final citiesController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    citiesController.addListener(() {
      if (citiesController.position.maxScrollExtent ==
          citiesController.offset) {
        print("MAX SCROLL EVENT SRABATYBAET??");

        context.read<HomeCitiesProvider>().incrementCities();
        context.read<HomeCitiesProvider>().getCities();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;

    final data = Provider.of<HomeScreenTourProvider>(context);

    final authData = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: citiesController,
        child: Column(
          children: [
            noCitySelected(
                ctx: context,
                data: data,
                locale: locale,
                height: height,
                width: width),
            SizedBox(
              height: 15,
            ),
            getRecentlyWatched(data: data, locale: locale),
            getToppestTours(data: data, locale: locale),
            getPopularestCities(locale: locale),
            const SizedBox(
              height: 3,
            )
          ],
        ),
      ),
    );
  }

  Widget getToppestTours(
      {required HomeScreenTourProvider data, required Locale locale}) {
    return FutureBuilder<List<TempCatalogTour>>(
      future: data.getTopTour(localeCode: locale.languageCode),
      builder: (context, snapshot) {
        print(locale.languageCode);
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
            if (snapshot.hasError) {
              return const SizedBox();
            } else if (snapshot.connectionState == ConnectionState.none ||
                !snapshot.hasData ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return const SizedBox();
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      S.of(context).popularTours,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 287,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      //physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int i) =>
                          GestureDetector(
                        onTap: () {
                          pushNewScreen(context,
                              screen: TourDetailScreen(), withNavBar: false);
                          context
                              .read<DetailTourProvider>()
                              .getTourDetails(snapshot.data![i].tourID);
                          context
                              .read<HomeScreenTourProvider>()
                              .addToRecentlyWatched(snapshot.data![i].tourID);
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.only(bottom: 15, left: 15, right: 5),
                          child: TourHomeItem(
                            image: snapshot.data![i].image,
                            id: snapshot.data![i].tourID,
                            name: snapshot.data![i].name,
                            rate: snapshot.data![i].rating,
                            price: snapshot.data![i].price,
                            currency: " ",
                            reviewCount: snapshot.data![i].reviews,
                            reviews: snapshot.data![i].reviews,
                            duration: snapshot.data![i].duration,
                          ),
                        ),
                      ),
                      itemCount: snapshot.data!.length,
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  Widget getRecentlyWatched(
      {required HomeScreenTourProvider data, required Locale locale}) {
    if (data.recentlyWatched.isEmpty || data.recentlyWatched.length == 0) {
      return Container();
    } else {
      return FutureBuilder<List<TempCatalogTour>>(
        future: data.getRecentlyWatchedTours(localeCode: locale.languageCode),
        builder: (context, snapshot) {
          print(locale.languageCode);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Container(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY)),
                ),
              );

            default:
              if (snapshot.hasError) {
                return const SizedBox();
              } else if (snapshot.connectionState == ConnectionState.none ||
                  !snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data!.isEmpty) {
                return const SizedBox();
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        S.of(context).recentlyWatched,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 287,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        //physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) =>
                            GestureDetector(
                          onTap: () {
                            pushNewScreen(context,
                                screen: TourDetailScreen(), withNavBar: false);
                            context
                                .read<DetailTourProvider>()
                                .getTourDetails(snapshot.data![i].tourID);
                            context
                                .read<HomeScreenTourProvider>()
                                .addToRecentlyWatched(snapshot.data![i].tourID);
                          },
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: 15, left: 15, right: 5),
                            child: TourHomeItem(
                              image: snapshot.data![i].image,
                              id: snapshot.data![i].tourID,
                              name: snapshot.data![i].name,
                              rate: snapshot.data![i].rating,
                              price: snapshot.data![i].price,
                              currency: " ",
                              reviewCount: snapshot.data![i].reviews,
                              reviews: snapshot.data![i].reviews,
                              duration: snapshot.data![i].duration,
                            ),
                          ),
                        ),
                        itemCount: snapshot.data!.length,
                      ),
                    ),
                  ],
                );
              }
          }
        },
      );
    }
  }

  Widget getPopularestCities({required Locale locale}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            S.of(context).popularCities,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ),
        Consumer<HomeCitiesProvider>(
          builder: (_, data, Widget? child) {
            return data.firstFewLoaded
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.popularestCities.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int i) {
                      if (i == data.popularestCities.length) {
                        if (data.additionalLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(PRIMARY),
                              ),
                            ),
                          );
                        } else {
                          return SizedBox();
                        }
                      } else {
                        final city = data.popularestCities[i];

                        return Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, bottom: 8, left: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: GestureDetector(
                              onTap: () async {
                                pushNewScreen(
                                  context,
                                  screen: HomeScreen2(
                                    cityID: city.cityID,
                                    list: suggestCities,
                                    cityName: city.cityName,
                                    countryName: city.countryName,
                                  ),
                                );
                              },
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    height: 90,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(city.flag),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.2),
                                            BlendMode.colorBurn),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10.0, right: 10),
                                    child: Text(
                                      city.cityName,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )
                : Padding(
                    padding: EdgeInsets.only(top: 300),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(PRIMARY),
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }

  Widget haveCitySelected(
      {required HomeScreenTourProvider data,
      required CustomCity customCity,
      required Locale locale}) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.3,
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(customCity.photo),
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              Text(
                customCity.name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                DateFormat("dd MMMM, yyyy, HH:mm").format(DateTime.now()),
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
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
                    screen: CatalogScreen(
                        locale: locale, date: date, cityID: data.cityID),
                  );
                },
                color: Colors.white,
                child: Text(
                  S.of(context).today,
                  style: TextStyle(
                      color: Colors.black,
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
                    screen: CatalogScreen(
                        locale: locale, date: date, cityID: data.cityID),
                  );
                },
                color: Colors.white,
                child: Text(
                  S.of(context).tommorow,
                  style: TextStyle(
                      color: Colors.black,
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
                              locale: locale, date: date, cityID: data.cityID),
                        );
                      }
                    },
                  );
                },
                color: Colors.white,
                child: Icon(
                  Icons.calendar_view_week,
                  color: Colors.black,
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
      required Locale locale,
      required double height,
      required double width}) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(ctx).size.height / 3.5,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/newbghome.jpg"),
          // colorFilter:
          //     ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: TextFormField(
              //enableInteractiveSelection: false, // will disable paste operation
              focusNode: new AlwaysDisabledFocusNode(),
              maxLines: 1,
              onTap: () {
                bool? res;
                try {
                  res = !context.read<AuthProvider>().user.isTourist;
                } catch (e) {}

                showSearch(
                  context: context,
                  delegate: CityTourSearch(
                      isGuide: res,
                      data: data,
                      locale: locale,
                      suggestCities: suggestCities,
                      search: S.of(context).enterCity),
                );
              },
              decoration: InputDecoration(
                hintText: S.of(context).enterCityOrTour,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  //borderSide: BorderSide(color: GRAY),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  //borderSide: BorderSide(color: GRAY),
                ),
                contentPadding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "|  ",
                      style: TextStyle(color: GRAY, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.map,
                        color: PRIMARY,
                      ),
                    ),
                  ],
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: GRAY,
                ),
              ),
            ),
          ),

          // Text(
          //   S.of(context).tagOne,
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.w500,
          //     fontSize: 20,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
          // MaterialButton(
          //   onPressed: () {
          //     bool? res;
          //     try {
          //       res = !context.read<AuthProvider>().user.isTourist;
          //     } catch (e) {}

          //     showSearch(
          //       context: context,
          //       delegate: CityTourSearch(
          //           isGuide: res,
          //           data: data,
          //           locale: locale,
          //           suggestCities: suggestCities,
          //           search: S.of(context).enterCity),
          //     );
          //   },
          //   child: Text(
          //     S.of(context).search,
          //     style: TextStyle(
          //         color: Colors.white,
          //         fontSize: 17,
          //         fontWeight: FontWeight.w500),
          //   ),
          //   color: Colors.blue[600],
          //   minWidth: MediaQuery.of(context).size.width / 1.5,
          //   padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(20),
          //   ),
          // )
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
                isGuide: res,
                data: data,
                locale: locale,
                suggestCities: suggestCities,
                search: S.of(context).enterCity));
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

  Widget popularTours() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [],
    );
  }

  Widget noData() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        OctoImage(
          image: AssetImage('assets/empty-pana.png'),
          height: 200,
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
