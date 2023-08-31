import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:provider/provider.dart';

import '../../../logic/utility/constants.dart';

class TicketDetailForGuide extends StatefulWidget {
  final String bookingID;
  const TicketDetailForGuide({Key? key, required this.bookingID})
      : super(key: key);

  @override
  _TicketDetailForGuideState createState() => _TicketDetailForGuideState();
}

class _TicketDetailForGuideState extends State<TicketDetailForGuide> {
  late RoundedLoadingButtonController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = RoundedLoadingButtonController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(39, 15, 27, 1),
      appBar: AppBar(
        actions: [],
        elevation: 0,
        backgroundColor: Color.fromRGBO(39, 15, 27, 1),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
          child: FutureBuilder<BookingTicket>(
              future: context
                  .watch<PurchaseOrderProvider>()
                  .getTicketDetails(id: widget.bookingID),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    if (!snapshot.hasData || snapshot.hasError) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 30,
                                ),
                                snapshot.data!.activated
                                    ? Center(
                                        child: Text(
                                          S.of(context).uConfirmedTicket + "!",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: RED,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0, right: 15),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              EasyLoading.show(
                                                  status:
                                                      S.of(context).loading);
                                              bool res = await context
                                                  .read<PurchaseOrderProvider>()
                                                  .activateOrder(
                                                      orderID:
                                                          widget.bookingID);
                                              EasyLoading.dismiss();
                                              if (res) {
                                                controller.success();
                                                showOkAlertDialog(
                                                    context: context,
                                                    message:
                                                        S.of(context).success);
                                              } else {
                                                controller.error();
                                                showOkAlertDialog(
                                                    context: context,
                                                    message: S
                                                        .of(context)
                                                        .errorOccured);
                                              }
                                            },
                                            child:
                                                Text(S.of(context).activate)),
                                      ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  bottomRight:
                                                      Radius.circular(10)),
                                              color: GREEN_BLACK),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return Flex(
                                                children: List.generate(
                                                  (constraints.constrainWidth() /
                                                          10)
                                                      .floor(),
                                                  (index) => SizedBox(
                                                    height: 1,
                                                    width: 5,
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .grey.shade400),
                                                    ),
                                                  ),
                                                ),
                                                direction: Axis.horizontal,
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 10,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  bottomLeft:
                                                      Radius.circular(10)),
                                              color: GREEN_BLACK),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  snapshot.data!.tourName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: GREEN_BLACK,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  S.of(context).guidedTour +
                                      ": " +
                                      snapshot.data!.sellerName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: GREEN_GRAY, fontSize: 18),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tileTemplate(
                                              title: S.of(context).ownerName,
                                              subtitle:
                                                  snapshot.data!.ownerName),
                                          tileTemplate(
                                              title: S.of(context).date,
                                              subtitle: DateFormat(
                                                      "dd MMMM, yyyy")
                                                  .format(snapshot.data!.date)),
                                          idCopyBlock(
                                              subtitle:
                                                  snapshot.data!.bookingID)
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                    ),
                                    Spacer(
                                      flex: 2,
                                    ),
                                    Expanded(
                                      flex: 10,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          tileTemplate(
                                              title: S.of(context).ticketFor,
                                              subtitle: snapshot.data!.isChild
                                                  ? S.of(context).child
                                                  : S.of(context).adult),
                                          tileTemplate(
                                            title: S.of(context).time,
                                            subtitle: DateFormat("HH:mm")
                                                .format(snapshot.data!.date),
                                          ),
                                          tileTemplate(
                                              title: S.of(context).status,
                                              subtitle: snapshot.data!.activated
                                                  ? S.of(context).confirmed
                                                  : S.of(context).notConfirmed)
                                        ],
                                        mainAxisSize: MainAxisSize.min,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: snapshot.data!.activated ? RED : PRIMARY,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25),
                                ),
                              ),
                              child: Text(
                                'VIP TOURIST',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cinzel(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                        ],
                      );
                    }
                }
              }),
        ),
      ),
    );
  }

  Widget idCopyBlock({required String subtitle}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              S.of(context).bookingID,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(color: GRAY, fontSize: 16),
            ),
            const SizedBox(
              width: 5,
            ),
          ],
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: GREEN_BLACK, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget tileTemplate({required String title, required String subtitle}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(color: GRAY, fontSize: 16),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.left,
          style: TextStyle(
              color: GREEN_BLACK, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
