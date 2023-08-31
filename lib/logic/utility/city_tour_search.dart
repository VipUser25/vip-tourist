import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/filter_tour_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/cataog_screen.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/tour_define_screen.dart';

class CityTourSearch extends SearchDelegate<String> {
  final HomeScreenTourProvider data;
  final Locale locale;
  final String search;
  final List<MiniCity>? suggestCities;
  final bool? isGuide;
  CityTourSearch(
      {required this.data,
      required this.locale,
      required this.search,
      this.suggestCities,
      this.isGuide});

  get builder => null;

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];
  @override
  String get searchFieldLabel => search;
  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back_ios_new),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) {
    return CatalogScreen(
      locale: locale,
      value: query,
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: PRIMARY,
      textTheme: theme.textTheme.copyWith(
        headline6: theme.textTheme.subtitle1?.copyWith(color: Colors.black),
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        hintStyle: theme.textTheme.subtitle1?.copyWith(color: Colors.grey),
        fillColor: Colors.grey[200],
        filled: true,
        isDense: true,
        contentPadding:
            const EdgeInsets.only(left: 7, right: 7, top: 7, bottom: 7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey, width: 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey, width: 0),
        ),
      ),
      appBarTheme:
          theme.appBarTheme.copyWith(titleSpacing: 0, backgroundColor: PRIMARY), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: PRIMARY),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (ctx, setState) => Container(
          color: Colors.white,
          child: FutureBuilder<CityTour>(
            future: context
                .read<FilterTourProvider>()
                .getSuggestions(value: query, localeCode: locale.languageCode),
            builder: (context, snapshot) {
              if (query.isEmpty) return customSuggestions(context);

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
                      (snapshot.data!.tours.isEmpty &&
                          snapshot.data!.cities.isEmpty)) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 2.7,
                        ),
                        Center(
                          child: Text(
                            S.of(context).noSuggestions,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        getFot(context)
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.tours.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () {
                                  pushNewScreen(context,
                                      screen: TourDetailScreen());
                                  print("CHECKIGN TOUR ID:::");
                                  print(snapshot.data!.tours[i].tourID);
                                  context
                                      .read<DetailTourProvider>()
                                      .getTourDetails(
                                        snapshot.data!.tours[i].tourID,
                                      );
                                },
                              ),
                              onTap: () {
                                pushNewScreen(context,
                                    screen: TourDetailScreen());
                                context
                                    .read<DetailTourProvider>()
                                    .getTourDetails(
                                      snapshot.data!.tours[i].tourID,
                                    );
                              },
                              leading: Icon(Icons.tour),
                              title: Text(
                                snapshot.data!.tours[i].tourName,
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          },
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.cities.length,
                          itemBuilder: (BuildContext context, int i) {
                            return ListTile(
                              trailing: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () async {
                                  await data.setCityIdLocaly(
                                      snapshot.data!.cities[i].cityID);

                                  data.clearTours();

                                  pushNewScreen(context,
                                      screen: CatalogScreen(
                                        cityID: snapshot.data!.cities[i].cityID,
                                        locale: locale,
                                      ),
                                      withNavBar: true);
                                },
                              ),
                              leading: Icon(Icons.location_city),
                              title: GestureDetector(
                                onTap: () async {
                                  await data.setCityIdLocaly(
                                      snapshot.data!.cities[i].cityID);

                                  data.clearTours();

                                  pushNewScreen(context,
                                      screen: CatalogScreen(
                                        cityID: snapshot.data!.cities[i].cityID,
                                        locale: locale,
                                      ),
                                      withNavBar: true);
                                },
                                child: Text(
                                  snapshot.data!.cities[i].cityName,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget getFot(BuildContext context) {
    if (isGuide != null) {
      if (isGuide!) {
        return Center(
          child: TextButton.icon(
            icon: Icon(Icons.add),
            onPressed: () async {
              Navigator.pop(context);
              context.read<AuthProvider>().controller.jumpToTab(4);
              pushNewScreen(context,
                  screen: TourDefineScreen(), withNavBar: false);
            },
            label: Text(
              S.of(context).addTour,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
            ),
          ),
        );
      } else {
        return Center(
          child: TextButton(
            onPressed: () async {
              await launch(
                  'mailto:support@viptourist.club?subject=&body=${S.of(context).texttouristaddcity2}$query');
            },
            child: Text(
              S.of(context).touristyouCanSendInquiry2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15.5, fontWeight: FontWeight.bold, color: PRIMARY),
            ),
          ),
        );
      }
    } else {
      return Center(
        child: TextButton(
          onPressed: () async {
            await launch(
                'mailto:support@viptourist.club?subject=&body=${S.of(context).texttouristaddcity2}$query');
          },
          child: Text(
            S.of(context).touristyouCanSendInquiry2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Widget customSuggestions(BuildContext context) {
    if (suggestCities != null) {
      if (suggestCities!.isNotEmpty) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                S.of(context).hints,
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
            ListView.builder(
              itemBuilder: (ctx, i) {
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: ListTile(
                    onTap: () {
                      pushNewScreen(context,
                          screen: CatalogScreen(
                            cityID: suggestCities![i].cityID,
                            locale: locale,
                          ),
                          withNavBar: true);
                    },
                    contentPadding: EdgeInsets.symmetric(vertical: 1),
                    leading: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey[350],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
                    ),
                    title: Text(suggestCities![i].cityName),
                  ),
                );
              },
              itemCount: suggestCities!.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
            )
          ],
        );
      } else {
        return const SizedBox();
      }
    } else {
      return const SizedBox();
    }
  }
}
