import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/purchase_screen.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/meeting_point_screen.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/more_reviews_screen.dart';
import 'package:vip_tourist/presentation/widgets/commentary_builder.dart';

import 'package:share/share.dart';

class TourDetailScreen extends StatefulWidget {
  const TourDetailScreen({Key? key}) : super(key: key);

  @override
  _TourDetailScreenState createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen> {
  bool _isPlaying = false;
  GlobalKey _sliderKey = GlobalKey();
  late CarouselController carouselController;
  late ExpandableController includedController;
  late ExpandableController notIncludedController;
  late ExpandableController prerequisitesController;
  late ExpandableController prohibitionsController;
  late ExpandableController noteController;
  late ExpandableController freeTicketController;
  late ExpandableController carPhotoController;
  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    carouselController = CarouselController();
    includedController = ExpandableController();
    notIncludedController = ExpandableController();
    prerequisitesController = ExpandableController();
    prohibitionsController = ExpandableController();
    noteController = ExpandableController();
    freeTicketController = ExpandableController();
    carPhotoController = ExpandableController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    includedController.dispose();
    notIncludedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DetailTourProvider>(context);
    final curData = Provider.of<CurrencyProvider>(context);
    final s = S.of(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: data.loaded
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    width: 1,
                    color: LIGHT_GRAY,
                  ),
                ),
              ),
              padding:
                  EdgeInsets.only(bottom: 10, top: 10, left: 15, right: 15),
              height: 90,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: SizedBox(
                      width: width / 2.3,
                      child: Column(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: S.of(context).from,
                                  style: TextStyle(
                                      color: GREEN_GRAY, fontSize: 16),
                                ),
                                TextSpan(
                                  text: " " + data.tour.price.toString() + " ",
                                  style: TextStyle(
                                      color: GREEN_GRAY,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: S.of(context).perPerson,
                                  style: TextStyle(
                                      color: GREEN_GRAY, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              RatingBar.builder(
                                ignoreGestures: true,
                                unratedColor: GRAY,
                                itemSize: 18,
                                glowColor: YELLOW,
                                initialRating: data.tour.rating.toDouble(),
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: false,
                                itemCount: 5,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: YELLOW,
                                ),
                                onRatingUpdate: (double value) {},
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                data.tour.rating.toString(),
                                style: TextStyle(
                                    color: GREEN_GRAY,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 2.3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: ElevatedButton(
                        child: Text(S.of(context).buyNow),
                        onPressed: () => pushNewScreen(context,
                            screen: PurchaseOneScreen(), withNavBar: false),
                      ),
                    ),
                  )
                ],
              ),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 60,
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
          title: Text(
            S.of(context).tourDetails,
          ),
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
        body: data.loaded
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      slider(ppp: data.tour.photos),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width / 1.6,
                            child: Text(
                              data.tour.name,
                              style: TextStyle(
                                  color: GREEN_BLACK,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (context
                                      .read<WishlistProvider>()
                                      .isFavorite(data.tour.tourID)) {
                                    context
                                        .read<WishlistProvider>()
                                        .removeFromFavorites(data.tour.tourID);
                                  } else {
                                    context
                                        .read<WishlistProvider>()
                                        .addToFavorites(data.tour.tourID);
                                  }
                                },
                                icon: Icon(
                                  Icons.favorite,
                                  size: 25.5,
                                  color: context
                                          .watch<WishlistProvider>()
                                          .isFavorite(data.tour.tourID)
                                      ? RED
                                      : GRAY,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              IconButton(
                                onPressed: () {
                                  _share(context, data);
                                },
                                icon: Icon(
                                  Icons.share,
                                  size: 25.5,
                                  color: GRAY,
                                ),
                              )
                            ],
                          ),
                        ],
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
                            data.tour.cityName!,
                            style: TextStyle(color: GRAY, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RatingBar.builder(
                            ignoreGestures: true,
                            itemSize: 20,
                            glowColor: YELLOW,
                            unratedColor: GRAY,
                            initialRating: data.tour.rating.toDouble(),
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: YELLOW,
                            ),
                            onRatingUpdate: (double value) {},
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            (data.reviews.length < 1)
                                ? "(" + S.of(context).noReviews + ")"
                                : '(${data.reviews.length} ' +
                                    S.of(context).reviews +
                                    ")",
                            style: TextStyle(
                              fontSize: 12,
                              color: GREEN_BLACK,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        data.tour.description,
                        style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      listTileTemplate(
                          icon: Icons.watch_later_sharp,
                          title: getDuration(data.tour.duration!),
                          subtitle: S.of(context).duration),
                      const SizedBox(
                        height: 15,
                      ),
                      listTileTemplate(
                          icon: Icons.emoji_people,
                          title: fromListToString(data.tour.languages),
                          subtitle: S.of(context).liveTour),
                      const SizedBox(
                        height: 15,
                      ),
                      getAvailabilityBlock(data),
                      const SizedBox(
                        height: 15,
                      ),
                      listTileTemplate(
                          icon: Icons.chair,
                          title: data.tour.seats.toString(),
                          subtitle: S.of(context).seatsAvailable),
                      const SizedBox(
                        height: 15,
                      ),
                      getTransferBlock(data, context),
                      const SizedBox(
                        height: 15,
                      ),
                      listTileTemplate(
                          icon: CupertinoIcons.person_alt,
                          title: getPrice(curData, data.tour.price),
                          subtitle: S.of(context).adultPrice),
                      const SizedBox(
                        height: 15,
                      ),
                      data.tour.childPrice == null
                          ? Container()
                          : listTileTemplate(
                              icon: Icons.child_care,
                              title: getPrice(curData, data.tour.childPrice!),
                              subtitle: S.of(context).childPrice),
                      data.tour.childPrice == null
                          ? Container()
                          : const SizedBox(
                              height: 15,
                            ),
                      Divider(),
                      // const SizedBox(
                      //   height: 15,
                      // ),
                      getIncluded(data),
                      getNotIncluded(data),
                      getProhibs(data),
                      getPrereq(data),
                      getNotes(data),
                      getFreeTicket(data),
                      getCarPhoto(data),
                      const SizedBox(
                        height: 15,
                      ),

                      data.reviews.isEmpty
                          ? Container()
                          : Column(
                              children: [
                                Text(
                                  S.of(context).reviews +
                                      " (${data.reviews.length.toString()})",
                                  style: TextStyle(
                                      color: GREEN_BLACK,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 10,
                                )
                              ],
                            ),
                      CommentaryBuilder(),
                      data.reviews.isEmpty
                          ? Container()
                          : GestureDetector(
                              onTap: () => pushNewScreen(context,
                                  screen: MoreReviewScreen(),
                                  withNavBar: false),
                              child: Padding(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      S.of(context).seeAllReviews,
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey[900],
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                            ),
                      data.reviews.isEmpty
                          ? Container()
                          : Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                            ),
                      SizedBox(
                        height: 82,
                      )
                    ],
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  String fromListToString(List<String> list) {
    return list.join(", ");
  }

  Widget getIncluded(DetailTourProvider data) {
    if (data.tour.included == null) {
      return Container();
    } else {
      if (data.tour.included!.isEmpty ||
          data.tour.included == "" ||
          data.tour.included == " ") {
        return Container();
      } else {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: includedController,
              collapsed: InkWell(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: () {
                  includedController.toggle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).whatIncluded,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      includedController.toggle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).whatIncluded,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.included!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getNotIncluded(DetailTourProvider data) {
    if (data.tour.notIncluded == null) {
      return Container();
    } else {
      if (data.tour.notIncluded!.isEmpty ||
          data.tour.notIncluded == "" ||
          data.tour.notIncluded == " ") {
        return Container();
      } else {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: notIncludedController,
              collapsed: InkWell(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: () {
                  notIncludedController.toggle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).whatNotIncluded,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      notIncludedController.toggle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).whatNotIncluded,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.notIncluded!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getPrereq(DetailTourProvider data) {
    if (data.tour.prerequisites == null) {
      return Container();
    } else {
      if (data.tour.prerequisites!.isEmpty ||
          data.tour.prerequisites == "" ||
          data.tour.prerequisites == " ") {
        return Container();
      } else {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: prerequisitesController,
              collapsed: InkWell(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: () {
                  prerequisitesController.toggle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).prerequisites2,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    onTap: () {
                      prerequisitesController.toggle();
                    },
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).prerequisites2,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.prerequisites!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getProhibs(DetailTourProvider data) {
    if (data.tour.prohibitions == null) {
      return Container();
    } else {
      if (data.tour.prohibitions!.isEmpty ||
          data.tour.prohibitions == "" ||
          data.tour.prohibitions == " ") {
        return Container();
      } else {
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: prohibitionsController,
              collapsed: InkWell(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: () {
                  prohibitionsController.toggle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).prohibs,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      prohibitionsController.toggle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).prohibs,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.prohibitions!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getFreeTicket(DetailTourProvider data) {
    if (data.tour.freeTicketNotice == null) {
      return Container();
    } else {
      if (data.tour.freeTicketNotice!.isEmpty ||
          data.tour.freeTicketNotice == "" ||
          data.tour.freeTicketNotice == " ") {
        return Container();
      } else {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: freeTicketController,
              collapsed: InkWell(
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                onTap: () {
                  freeTicketController.toggle();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).notesAboutFreeTour2,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    onTap: () {
                      freeTicketController.toggle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).notesAboutFreeTour2,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.freeTicketNotice!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getNotes(DetailTourProvider data) {
    if (data.tour.note == null) {
      return Container();
    } else {
      if (data.tour.note!.isEmpty ||
          data.tour.note == "" ||
          data.tour.note == " ") {
        return Container();
      } else {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: noteController,
              collapsed: InkWell(
                onTap: () {
                  noteController.toggle();
                },
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).note,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    onTap: () {
                      noteController.toggle();
                    },
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).note,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.tour.note!,
                    style: TextStyle(fontSize: 16, color: GREEN_BLACK),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  Widget getCarPhoto(DetailTourProvider data) {
    if (!data.tour.withTransfer) {
      return Container();
    } else {
      if (data.tour.transferPhotoUrl!.isEmpty ||
          data.tour.transferPhotoUrl == "" ||
          data.tour.transferPhotoUrl == " ") {
        return Container();
      } else {
        return Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ExpandablePanel(
              controller: carPhotoController,
              collapsed: InkWell(
                onTap: () {
                  carPhotoController.toggle();
                },
                focusColor: Colors.white,
                hoverColor: Colors.white,
                splashColor: Colors.white,
                highlightColor: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      S.of(context).carPhoto,
                      style: TextStyle(
                          color: GREEN_BLACK,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.keyboard_arrow_down_outlined)
                  ],
                ),
              ),
              expanded: Column(
                children: [
                  InkWell(
                    onTap: () {
                      carPhotoController.toggle();
                    },
                    focusColor: Colors.white,
                    hoverColor: Colors.white,
                    splashColor: Colors.white,
                    highlightColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          S.of(context).carPhoto,
                          style: TextStyle(
                              color: GREEN_BLACK,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.keyboard_arrow_up_outlined)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: OctoImage(
                      image: NetworkImage(data.tour.transferPhotoUrl!),
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      }
    }
  }

  String getWeekdays(String val) {
    String cc = "";
    List<String> days = val.split(",");
    days.forEach((element) {
      if (element == "mn") {
        cc = cc + S.of(context).monday + ", ";
      } else if (element == "tu") {
        cc = cc + S.of(context).tuesday + ", ";
      } else if (element == "wd") {
        cc = cc + S.of(context).wednesday + ", ";
      } else if (element == "th") {
        cc = cc + S.of(context).thursday + ", ";
      } else if (element == "fr") {
        cc = cc + S.of(context).friday + ", ";
      } else if (element == "st") {
        cc = cc + S.of(context).saturday + ", ";
      } else if (element == "sn") {
        cc = cc + S.of(context).sunday + ", ";
      }
    });
    return cc.substring(0, cc.length - 2);
  }

  String getDuration(int duration) {
    if (duration % 24 == 0) {
      if (duration == 24) {
        return "1 " + S.of(context).day.toLowerCase();
      } else {
        double days = duration / 24;
        return days.toInt().toString() + " " + S.of(context).days.toLowerCase();
      }
    } else {
      return duration.toString() + " " + S.of(context).hours.toLowerCase();
    }
  }

  Widget getAvailabilityBlock(DetailTourProvider data) {
    if (data.tour.alwaysAvailable) {
      return listTileTemplate(
          icon: Icons.calendar_month,
          title: getWeekdays(data.tour.weekDays!),
          subtitle: S.of(context).alwaysAvailable);
    } else {
      return listTileTemplate(
          icon: Icons.calendar_month,
          title: DateFormat("dd MMMM, yyyy").format(data.tour.date!),
          subtitle: S.of(context).dateAndTime);
    }
  }

  Widget getTransferBlock(DetailTourProvider data, BuildContext cont) {
    if (data.tour.withTransfer) {
      return listTileTemplate2(
          icon: Icons.local_taxi,
          title: S.of(context).driverWillPickUp,
          subtitle: S.of(context).withTransfer,
          doPressed: () {
            showAFullPhoto(cont, data.tour.transferPhotoUrl!);
          });
    } else {
      return listTileTemplate2(
        icon: Icons.location_on,
        title: S.of(context).meetingPoint,
        subtitle: S.of(context).tour,
        doPressed: () {
          pushNewScreen(context,
              screen: MeetingPointScreen(
                latLng: data.tour.meetingPoint!,
                tourName: data.tour.name,
              ),
              withNavBar: false);
        },
      );
    }
  }

  Future<void> showAFullPhoto(BuildContext cont, String image) async {
    showDialog<void>(
      barrierDismissible: true,
      context: cont,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OctoImage(
                image: NetworkImage(image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget listTileTemplate(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Icon(
          icon,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 13,
        ),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: GREEN_BLACK),
              ),
              Text(subtitle, style: TextStyle(color: GRAY, fontSize: 12)),
            ],
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget listTileTemplate2(
      {required IconData icon,
      required String title,
      required String subtitle,
      required void Function()? doPressed}) {
    return Row(
      children: [
        Icon(
          icon,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: GREEN_BLACK),
            ),
            Text(subtitle, style: TextStyle(color: GRAY, fontSize: 12)),
          ],
        ),
        Spacer(),
        IconButton(
          onPressed: doPressed,
          icon: Icon(
            Icons.arrow_forward_ios,
            color: GREEN_BLACK,
            size: 18,
          ),
          padding: EdgeInsets.all(0),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
  // Widget reviews() {
  //   return Row(
  //     children: [
  //       RatingBar.builder(
  //         ignoreGestures: true,
  //         itemSize: 24,
  //         glowColor: Color.fromRGBO(255, 206, 100, 1),
  //         initialRating: data.tour.rating.toDouble(),
  //         minRating: 1,
  //         direction: Axis.horizontal,
  //         allowHalfRating: false,
  //         itemCount: 5,
  //         itemBuilder: (context, _) => Icon(
  //           Icons.star,
  //           color: Color.fromRGBO(255, 188, 44, 1),
  //         ),
  //         onRatingUpdate: (double value) {},
  //       ),
  //       SizedBox(
  //         width: 7,
  //       ),
  //       Text(
  //         data.tour.rating.toString(),
  //         style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
  //       )
  //     ],
  //   );
  // }

  Widget slider({
    required List<String> ppp,
  }) {
    if (ppp.isEmpty) {
      return Container();
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: CarouselSlider.builder(
                carouselController: carouselController,
                itemCount: ppp.length,
                itemBuilder:
                    (BuildContext ctx, int itemIndex, int pageViewIndex) =>
                        Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: OctoImage(
                      image: NetworkImage(ppp[itemIndex]),
                      fit: BoxFit.cover,
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.height / 1.5,
                    ),
                  ),
                ),
                options: CarouselOptions(
                    autoPlay: true,
                    enableInfiniteScroll: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    },
                    enlargeCenterPage: false),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ppp.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => carouselController.animateToPage(entry.key),
                  child: Container(
                    width: 9.0,
                    height: 9.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    }
  }

  String getPrice(CurrencyProvider data, double price) {
    if (data.currency == "USD" || data.currency == null) {
      return "\$" + price.toStringAsFixed(2);
    } else if (data.currency == "EUR") {
      return "€" + (price * data.euro!).toStringAsFixed(2);
    } else if (data.currency == "AED") {
      return ".د.إ" + (price * data.dirham!).toStringAsFixed(2);
    } else if (data.currency == "RUB") {
      return "₽" + (price * data.rouble!).toStringAsFixed(2);
    } else if (data.currency == "THB") {
      return "฿" + (price * data.baht!).toStringAsFixed(2);
    } else if (data.currency == "TRY") {
      return "₤" + (price * data.lira!).toStringAsFixed(2);
    } else if (data.currency == "GBP") {
      return "£" + (price * data.gbp!).toStringAsFixed(2);
    }
    return "\$" + price.toStringAsFixed(2);
  }

  void _share(BuildContext context, DetailTourProvider data) async {
    final String subject = 'Get ${data.tour.name} in VIP Tourist!';

    String url = "http://viptourist.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/${data.tour.tourID}'),
      androidParameters: AndroidParameters(
        packageName: "com.alishber.vip_tourist",
        minimumVersion: 0,
      ),
      iosParameters: IOSParameters(bundleId: '', appStoreId: ''),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '',
          imageUrl: Uri.parse(data.tour.photos[0]),
          title: subject),
    );
    EasyLoading.show();
    final dynamicUrl =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    EasyLoading.dismiss();
    String? desc = '${dynamicUrl.shortUrl.toString()}';
    await Share.share(desc, subject: subject);
  }
}
