import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ticket_material/ticket_material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:vip_tourist/logic/utility/city_tour_search.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/booking_screens/qr_code_scanner_screen.dart';
import 'package:vip_tourist/presentation/screens/booking_screens/ticket_detail_screen.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String? sort;
  String? url;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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
          onPressed: () => _showMultiSelect(context),
          elevation: 2,
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.sort,
            size: 20,
            color: GREEN_BLACK,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: bookings(
              id: context.watch<AuthProvider>().user.getIdd,
              data: data,
              locale: locale,
              ctx: context),
        ),
      ),
    );
  }

  Widget emptyList(
      {required HomeScreenTourProvider data, required Locale locale}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 11,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: OctoImage(
            image: AssetImage('assets/emptyTickets.png'),
            height: MediaQuery.of(context).size.height / 3.8,
          ),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          S.of(context).nextExp,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: GREEN_BLACK),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          S.of(context).tagOne,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: GREEN_GRAY, fontSize: 16, fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 55,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size.fromHeight(double.infinity),
          ),
          onPressed: () async {
            bool? res;
            try {
              res = !context.read<AuthProvider>().user.isTourist;
            } catch (e) {}

            showSearch(
              context: context,
              delegate: CityTourSearch(
                  data: data,
                  locale: locale,
                  search: S.of(context).enterCity,
                  suggestCities: data.suggestedList,
                  isGuide: res),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Text(
              S.of(context).pickUpTours,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        TextButton(
            onPressed: () async {
              await launch(
                  'mailto:support@viptourist.club?subject=&body=${S.of(context).cantFindMyTicket}');
            },
            child: Text(
              S.of(context).cantFind,
              style: TextStyle(color: PRIMARY),
            ))
      ],
    );
  }

  Widget bookings(
      {String? id,
      required HomeScreenTourProvider data,
      required Locale locale,
      required BuildContext ctx}) {
    if (id == null) {
      return emptyList(data: data, locale: locale);
    } else {
      return FutureBuilder<List<BookingTicket>>(
        future: ctx
            .watch<PurchaseOrderProvider>()
            .getTickets(id: id, ss: 2, sort: sort),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.5),
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY),
                )),
              );

            default:
              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty ||
                  snapshot.data == null) {
                return emptyList(data: data, locale: locale);
              } else {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 15),
                  itemBuilder: (context, i) {
                    return Column(
                      children: [
                        TicketMaterial(
                          tapHandler: () => pushNewScreen(context,
                              screen: TicketDetailScreen(
                                bookingID: snapshot.data![i].bookingID,
                              ),
                              withNavBar: false),
                          flexRightSize: 30,
                          leftChild: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                    topRight: Radius.circular(1),
                                    bottomRight: Radius.circular(1)),
                                border:
                                    Border.all(color: LIGHT_GRAY, width: 0.7)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![i].tourName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: GREEN_BLACK,
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      S.of(context).ownerName,
                                      style:
                                          TextStyle(color: GRAY, fontSize: 13),
                                    ),
                                    Text(
                                      snapshot.data![i].ownerName,
                                      style: TextStyle(
                                        color: GREEN_BLACK,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S.of(context).date,
                                              style: TextStyle(
                                                  color: GRAY, fontSize: 13),
                                            ),
                                            Text(
                                              DateFormat("dd MMMM, yyyy")
                                                  .format(
                                                      snapshot.data![i].date),
                                              style: TextStyle(
                                                  color: GREEN_BLACK,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              S.of(context).time,
                                              style: TextStyle(
                                                  color: GRAY, fontSize: 13),
                                            ),
                                            Text(
                                              DateFormat("HH:mm").format(
                                                  snapshot.data![i].date),
                                              style: TextStyle(
                                                  color: GREEN_BLACK,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          radiusCircle: 5,
                          radiusBorder: 10,
                          rightChild: Center(
                            child: QrImage(
                              backgroundColor: Colors.white,
                              data: snapshot.data![i].bookingID,
                              version: QrVersions.auto,
                              size: 90,
                            ),
                          ),
                          shadowSize: 0,
                          colorBackground:
                              snapshot.data![i].activated ? RED : PRIMARY,
                          height: 160,
                        ),
                        SizedBox(
                          height: 15,
                        )
                      ],
                    );
                  },
                );
              }
          }
        },
      );
    }
  }

  void _showMultiSelect(BuildContext context) async {
    String? t = await showConfirmationDialog(
      context: context,
      initialSelectedActionKey: sort,
      title: S.of(context).sortBy,
      actions: [
        AlertDialogAction(key: "&_sort=date", label: S.of(context).date),
        AlertDialogAction(
            key: "&_sort=activated", label: S.of(context).activationStatus),
      ],
      okLabel: S.of(context).ok,
      cancelLabel: S.of(context).cancel,
    );
    setState(() {
      sort = t;
    });
  }
}
