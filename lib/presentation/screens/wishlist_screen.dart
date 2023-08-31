import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/widgets/catalog_tour_item.dart';
import 'package:vip_tourist/presentation/widgets/favorite_tour_item.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/presentation/widgets/new_tour_item.dart';
import 'package:weather/weather.dart';

import '../../logic/utility/constants.dart';
import '../widgets/new_catalog_tour_item.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  _WishlistScreenState createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final data = Provider.of<HomeScreenTourProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(S.of(context).wishlist),
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: FutureBuilder<List<WishlistTour>>(
          future: context
              .watch<WishlistProvider>()
              .getFavoriteTours(locale.languageCode),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: noData(data: data),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              pushNewScreen(context,
                                  screen: TourDetailScreen(), withNavBar: true);
                              print(snapshot.data![i].tourID);
                              context.read<DetailTourProvider>().getTourDetails(
                                    snapshot.data![i].tourID,
                                  );
                            },
                            child: NewTourItem(
                              duration: snapshot.data![i].duration,
                              id: snapshot.data![i].tourID,
                              image: snapshot.data![i].image,
                              locale: locale,
                              name: snapshot.data![i].tourName,
                              price: snapshot.data![i].price,
                              rating: snapshot.data![i].rating.toInt(),
                              reviews: snapshot.data![i].reviews,
                              seats: 1,
                            ),
                          ),
                          SizedBox(
                            height: 13,
                          )
                        ],
                      );
                    },
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget noData({required HomeScreenTourProvider data}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5),
            child: OctoImage(
              image: AssetImage('assets/emptylikes.png'),
              height: 224,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            S.of(context).favTag,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 19, fontWeight: FontWeight.w400, color: GREEN_BLACK),
          ),
          SizedBox(
            height: 43,
          ),
          ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().controller.jumpToTab(0);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size.fromHeight(double.infinity),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(S.of(context).pickUpTours),
              ))
        ],
      ),
    );
  }
}
