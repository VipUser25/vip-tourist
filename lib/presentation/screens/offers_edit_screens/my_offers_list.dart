import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offer_edit_screen.dart';
import 'package:vip_tourist/presentation/widgets/active_tour_item.dart';

import '../../../generated/l10n.dart';
import '../../../logic/providers/offer_edit_provider.dart';
import '../../tour_addition_screens/tour_define_screen.dart';
import '../../widgets/mini_tour_item.dart';
import '../../widgets/offer_edit_item.dart';

class MyOffersList extends StatefulWidget {
  final String pageName;
  final String postfix;
  const MyOffersList({Key? key, required this.postfix, required this.pageName})
      : super(key: key);

  @override
  State<MyOffersList> createState() => _MyOffersListState();
}

class _MyOffersListState extends State<MyOffersList> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<OfferEditProvider>(context);
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          widget.pageName,
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder<List<CustomOffer>>(
          future: data.getToursList(locale.languageCode, widget.postfix),
          builder: (ctx, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return emptyList(locale: locale);
                } else {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int i) {
                      if (snapshot.data![i].remarkBody == null ||
                          snapshot.data![i].remarkTitle == null) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 15.0),
                            child: GestureDetector(
                              onTap: () async {
                                await context
                                    .read<OfferEditProvider>()
                                    .getTourDetails(snapshot.data![i].tourID);
                                pushNewScreen(context,
                                    screen: OfferEditScreen(
                                        offerID: snapshot.data![i].tourID));
                              },
                              child: MiniTouritem(
                                photo: snapshot.data![i].photo!,
                                price: snapshot.data![i].price,
                                description: snapshot.data![i].description,
                                name: snapshot.data![i].tourName,
                              ),
                            ));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: GestureDetector(
                            onTap: () async {
                              await context
                                  .read<OfferEditProvider>()
                                  .getTourDetails(snapshot.data![i].tourID);
                              pushNewScreen(context,
                                  screen: OfferEditScreen(
                                      offerID: snapshot.data![i].tourID));
                            },
                            child: MiniTouritem(
                              photo: snapshot.data![i].photo!,
                              price: snapshot.data![i].price,
                              description: snapshot.data![i].description,
                              name: snapshot.data![i].tourName,
                            ),
                          ), //MISSED REMARKS DO SMTH WITH THAT LATER!
                        );
                      }
                    },
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Widget emptyList({required Locale locale}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: OctoImage(
              image: AssetImage('assets/noTicket.png'),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            S.of(context).nOffersTag,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, color: GREEN_GRAY, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 23,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(double.infinity),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TourDefineScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                S.of(context).addTour,
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
}

// OfferEditItem(
//                             data: CustomOffer(
//                               approved: snapshot.data![i].approved,
//                               tourID: snapshot.data![i].tourID,
//                               subtitle: S.of(context).price +
//                                   ": " +
//                                   snapshot.data![i].subtitle,
//                               tourName: snapshot.data![i].tourName,
//                               photo: snapshot.data![i].photo,
//                             ),
//                           ),