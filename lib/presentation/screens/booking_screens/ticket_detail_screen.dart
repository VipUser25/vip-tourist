import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/user_profile_look_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/user_profile_look_screen.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TicketDetailScreen extends StatefulWidget {
  final String bookingID;
  const TicketDetailScreen({Key? key, required this.bookingID})
      : super(key: key);

  @override
  _TicketDetailScreenState createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  late ScreenshotController screenshotController;
  @override
  void initState() {
    // TODO: implement initState
    screenshotController = ScreenshotController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserProfileLookProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: GREEN_BLACK,
      appBar: AppBar(
        elevation: 0.6,
        backgroundColor: GREEN_BLACK,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).orderDetails,
          style: TextStyle(color: Colors.white),
        ),
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 55.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
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
                heroTag: "1",
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(right: 8.0),
            //   child: FloatingActionButton(
            //     onPressed: () async {
            //       EasyLoading.show(status: S.of(context).loading);
            //       final ticketData = await context
            //           .read<PurchaseOrderProvider>()
            //           .getTicketDetails(id: widget.bookingID);
            //       EasyLoading.dismiss();
            //       await showDialog(
            //           context: context,
            //           barrierDismissible:
            //               true, // set to false if you want to force a rating
            //           builder: (context) {
            //             return _dialog(ticketData.sellerPhoto,
            //                 ticketData.sellerName, ticketData.sellerID, "2");
            //           });
            //     },
            //     elevation: 2,
            //     backgroundColor: Colors.white,
            //     mini: true,
            //     child: Icon(
            //       Icons.rate_review_rounded,
            //       size: 20,
            //       color: GREEN_BLACK,
            //     ),
            //     heroTag: "2",
            //   ),
            // )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
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
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 20),
                                    child: GestureDetector(
                                      onTap: () => showFullQR(
                                          context, snapshot.data!.bookingID),
                                      child: QrImage(
                                        data: snapshot.data!.bookingID,
                                        version: QrVersions.auto,
                                        size: 150,
                                      ),
                                    ),
                                  ),
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
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      S.of(context).guidedTour +
                                          ": " +
                                          snapshot.data!.sellerName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: GREEN_GRAY, fontSize: 18),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    GestureDetector(
                                      child: Icon(
                                        Icons.info_outline,
                                        size: 22,
                                        color: PRIMARY,
                                      ),
                                      onTap: () {
                                        guideProfileBottomSheet(
                                            data: data,
                                            sellerID: snapshot.data!.sellerID);
                                      },
                                    )
                                  ],
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
            GestureDetector(
              child: Icon(
                Icons.copy,
                color: PRIMARY,
                size: 18,
              ),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(
                    text: subtitle,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.fixed,
                    content: Text(
                      S.of(context).bookingIDisCopied,
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            )
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

  Future<void> showFullQR(BuildContext cont, String value) async {
    showDialog<void>(
      barrierDismissible: true,
      context: cont,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                height: 350,
                width: 350,
                child: QrImage(
                  data: value,
                  version: QrVersions.auto,
                  size: 350,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                EasyLoading.show(status: S.of(context).loading);
                final image = await screenshotController.capture();
                if (image != null) {
                  final now = DateTime.now();
                  String fileName =
                      "vip_tourist_qrcode" + now.toIso8601String();
                  final res =
                      await ImageGallerySaver.saveImage(image, name: fileName);
                  print("QR CODE SAVE CHECK");
                  print(res.toString());
                  EasyLoading.showSuccess(S.of(context).qrCodeSaved);
                } else {
                  EasyLoading.showError(S.of(context).errorOccured);
                }
              },
              icon: Icon(
                Icons.download,
                color: PRIMARY,
                size: 28,
              ),
              label: Text(
                S.of(context).download,
                style: TextStyle(color: PRIMARY, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }

  dynamic _dialog(String photo, String name, String ownerID, String tourID) {
    return RatingDialog(
      initialRating: 1.0,
      // your app's name?
      title: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      // encourage your user to leave a high rating?
      message: Text(
        S.of(context).rateTourTag,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),

      // your app's logo?
      image: CircleAvatar(
        backgroundImage: NetworkImage(photo),
        minRadius: 80,
      ),
      submitButtonText: S.of(context).submit,
      commentHint: S.of(context).rateGuideTagTwo,
      submitButtonTextStyle:
          TextStyle(color: PRIMARY, fontSize: 16, fontWeight: FontWeight.bold),
      onCancelled: () => print('cancelled'),
      onSubmitted: (response) async {
        EasyLoading.show(status: S.of(context).loading);
        bool res = await context.read<PurchaseOrderProvider>().rateGuide(
            comment: response.comment,
            rating: response.rating,
            ownerID: ownerID,
            tourID: tourID);
        if (res) {
          context.read<HomeScreenTourProvider>().triggerUpdate();
          EasyLoading.showSuccess(S.of(context).successfull);
        } else {
          EasyLoading.showError(
            S.of(context).errorOccured,
            duration: Duration(seconds: 2),
          );
        }
      },
    );
  }

  Future<void> guideProfileBottomSheet(
      {required UserProfileLookProvider data, required String sellerID}) async {
    data.getUser(id: sellerID);
    await showModalBottomSheet(
      isScrollControlled: true,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      barrierColor: Colors.black26,
      context: context,
      builder: (ctx) {
        return UserProfileLookScreen();
      },
    );
  }
}
