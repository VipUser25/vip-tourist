import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/order.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/my_offers_list.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/tour_define_screen.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/presentation/widgets/order_item.dart';

import '../../tour_addition_screens/add_tour_screen.dart';

class OffersListScreen extends StatefulWidget {
  const OffersListScreen({Key? key}) : super(key: key);

  @override
  _OffersListScreenState createState() => _OffersListScreenState();
}

class _OffersListScreenState extends State<OffersListScreen> {
  String? filter;
  bool isFirst = true;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<PurchaseOrderProvider>(context);

    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).myTours,
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
      body: Column(
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
                      onPressed: () {
                        setState(() {
                          isFirst = true;
                        });
                      },
                      icon: Icon(
                        Icons.tour,
                        color: isFirst ? GREEN_BLACK : GRAY,
                      ),
                      label: Text(
                        S.of(context).myTours,
                        style: TextStyle(
                            color: isFirst ? GREEN_BLACK : GRAY, fontSize: 16),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          isFirst = false;
                        });
                      },
                      icon: Icon(
                        Icons.wallet,
                        color: isFirst ? GRAY : GREEN_BLACK,
                      ),
                      label: Text(
                        S.of(context).mySales,
                        style: TextStyle(
                            color: isFirst ? GRAY : GREEN_BLACK, fontSize: 16),
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
          getBody(locale: locale, orderData: orderData),
        ],
      ),
    );
  }

  Widget getBody(
      {required Locale locale, required PurchaseOrderProvider orderData}) {
    if (isFirst) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            templateTile1(
                title: S.of(context).addTour,
                onTap: () => pushNewScreen(context,
                    screen: TourDefineScreen(), withNavBar: false)),
            const SizedBox(
              height: 30,
            ),
            templateTile1(
                title: S.of(context).activeTours,
                onTap: () {
                  String postfix = "&_active=true&_approved=true";
                  pushNewScreen(context,
                      screen: MyOffersList(
                        postfix: postfix,
                        pageName: S.of(context).activeTours,
                      ),
                      withNavBar: false);
                }),
            const SizedBox(
              height: 30,
            ),
            templateTile1(
                title: S.of(context).onConsider,
                onTap: () {
                  String postfix = "&_active=true&_approved=false";
                  pushNewScreen(context,
                      screen: MyOffersList(
                        postfix: postfix,
                        pageName: S.of(context).onConsider,
                      ),
                      withNavBar: false);
                }),
            const SizedBox(
              height: 30,
            ),
            templateTile1(
                title: S.of(context).draft,
                onTap: () async {
                  String? cityID =
                      context.read<TourAdditionProvider>().localData.cityID;
                  if (cityID == null) {
                    EasyLoading.showInfo(S.of(context).noSavedDraft);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTourScreen(
                          cityID: cityID,
                        ),
                      ),
                    );
                  }
                })
          ],
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 1.4,
        child: Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: "aza9az9",
              elevation: 15,
              onPressed: () => _showMultiSelect(context),
              child: Icon(
                CupertinoIcons.slider_horizontal_3,
                color: PRIMARY,
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniEndDocked,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<List<Order>>(
              future: orderData.getOrdersList(
                  sellerID: context.read<AuthProvider>().user.getIdd,
                  filter: filter),
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: OrderItem(
                              order: snapshot.data![i],
                            ),
                          );
                        },
                        itemCount: snapshot.data!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                      );
                    }
                }
              },
            ),
          ),
        ),
      );
    }
  }

  Widget templateTile1(
      {required String title, required void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, color: GREEN_GRAY),
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: GRAY,
          ),
        ],
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }

  Widget emptyList({required Locale locale}) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
      child: Center(
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
              S.of(context).noPurchasedTickets,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18, color: GREEN_GRAY, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 23,
            ),
            Text(
              S.of(context).applyForTourTag,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: GREEN_GRAY,
              ),
            ),
            SizedBox(
              height: 28,
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
      ),
    );
  }

  String getTitle({required String sellerName, required double price}) {
    return sellerName + ", " + "x1, " + price.toString() + "\$";
  }

  String getSubtitle({required DateTime date, required String tourName}) {
    return tourName + ", " + DateFormat("dd MMMM, yyyy, HH:mm").format(date);
  }

  void _showMultiSelect(BuildContext context) async {
    String? t = await showConfirmationDialog(
      context: context,
      title: S.of(context).showOnly,
      message: S.of(context).filter,
      actions: [
        AlertDialogAction(
            key: "&_seller_confirmed=true&_activated=false",
            label: S.of(context).confirmedByYou),
        AlertDialogAction(
            key: "&_seller_confirmed=true&_activated=true",
            label: S.of(context).activated),
        AlertDialogAction(
            key: "&_canceled=true", label: S.of(context).canceled),
        AlertDialogAction(
            key: "&_seller_confirmed=false&_canceled=false",
            label: S.of(context).waitingForConfirm),
        AlertDialogAction(key: "", label: S.of(context).showAll),
      ],
      okLabel: S.of(context).ok,
      cancelLabel: S.of(context).cancel,
      initialSelectedActionKey: filter,
    );
    if (t != null) {
      setState(() {
        filter = t;
      });
    }
  }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

