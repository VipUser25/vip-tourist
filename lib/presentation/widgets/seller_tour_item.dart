import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';

import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/billing_screen.dart';

class SellerTourItem extends StatefulWidget {
  final Function showFilter;
  const SellerTourItem({Key? key, required this.showFilter}) : super(key: key);

  @override
  _SellerTourItemState createState() => _SellerTourItemState();
}

class _SellerTourItemState extends State<SellerTourItem> {
  @override
  Widget build(BuildContext context) {
    final curData = Provider.of<CurrencyProvider>(context);
    final authData = Provider.of<AuthProvider>(context);
    final tourData = Provider.of<DetailTourProvider>(context);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 15),
      decoration: BoxDecoration(
          border:
              Border.all(width: 0.5, color: Color.fromRGBO(117, 117, 117, 1)),
          borderRadius: BorderRadius.circular(15)),
      // child: Expandable(
      //   animationDuration: Duration(milliseconds: 300),
      //   primaryWidget: Column(
      //     children: [
      //       getTitleWidget(tourData.tour.cityName, tourData.tour.name),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       ListTile(
      //         contentPadding: EdgeInsets.only(left: 1),
      //         leading: (tourData.tour.userPhoto == null ||
      //                 tourData.tour.userPhoto!.isEmpty)
      //             ? CircleAvatar(
      //                 maxRadius: 30,
      //                 child: Text(tourData.tour.userName[0].toUpperCase()),
      //               )
      //             : GestureDetector(
      //                 onTap: () =>
      //                     showAFullPhoto(context, tourData.tour.userPhoto!),
      //                 child: CircleAvatar(
      //                   maxRadius: 30,
      //                   backgroundImage: NetworkImage(tourData.tour.userPhoto!),
      //                 ),
      //               ),
      //         title: Text(
      //           tourData.tour.userName,
      //           style: TextStyle(
      //               color: Colors.grey[850],
      //               fontSize: 18,
      //               fontWeight: FontWeight.w600),
      //         ),
      //         subtitle: Text(S.of(context).guide,
      //             style: TextStyle(color: Colors.grey[700], fontSize: 18)),
      //       ),
      //       SizedBox(
      //         height: 15,
      //       ),
      //       totalAmount(curData, tourData),
      //       SizedBox(
      //         height: 15,
      //       )
      //     ],
      //   ),
      //   secondaryWidget: Column(
      //     children: [
      //       durationField(tourData.tour.duration),
      //       elementBlank(Icons.emoji_people, S.of(context).liveTour,
      //           fromListToString(tourData.tour.languages), null),
      //       dateField(tourData.tour.date, tourData.tour.alwaysAvailable),
      //       elementBlank(
      //         Icons.description,
      //         S.of(context).aboutActiv,
      //         S.of(context).fullDesc,
      //         IconButton(
      //           onPressed: () => pushNewScreen(context,
      //               screen: MoreDetailedScreen(
      //                 tourDescription: tourData.tour.description,
      //                 tour: tourData.tour,
      //               ),
      //               withNavBar: false),
      //           icon: Icon(Icons.arrow_forward_ios),
      //         ),
      //       ),
      //       tourData.tour.withTransfer
      //           ? ListTile(
      //               leading: Icon(
      //                 Icons.drive_eta,
      //                 color: Colors.blue[600],
      //                 size: 27,
      //               ),
      //               title: Text(
      //                 S.of(context).driverWillPickUp,
      //                 style: TextStyle(
      //                     color: Colors.grey[850],
      //                     fontSize: 15,
      //                     fontWeight: FontWeight.w600),
      //               ),
      //             )
      //           : ListTile(
      //               onTap: () {
      //                 pushNewScreen(context,
      //                     screen: MeetingPointScreen(
      //                       latLng: tourData.tour.meetingPoint!,
      //                       tourName: tourData.tour.name,
      //                     ),
      //                     withNavBar: false);
      //               },
      //               leading: Icon(
      //                 Icons.location_on,
      //                 color: Colors.blue[600],
      //                 size: 27,
      //               ),
      //               title: Text(
      //                 S.of(context).meetingPoint,
      //                 style: TextStyle(
      //                     fontSize: 15,
      //                     fontWeight: FontWeight.w600,
      //                     color: Colors.blue[600]),
      //               ),
      //             ),
      //       SizedBox(
      //         height: 10,
      //       ),
      //       nextButton(
      //           curData: curData, authData: authData, tourData: tourData),
      //       SizedBox(
      //         height: 10,
      //       )
      //     ],
      //   ),
      // ),
    );
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

  Widget totalAmount(CurrencyProvider curData, DetailTourProvider tourData) {
    double adultPrice = tourData.tour.price;
    double childPrice = tourData.tour.childPrice ?? 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).totalAmount,
          style: TextStyle(
              color: Colors.grey[700],
              fontSize: 17.5,
              fontWeight: FontWeight.w600),
        ),
        GestureDetector(
          onTap: () {
            widget.showFilter(context);
          },
          child: Text(
            getPrice(
                curData,
                ((context.watch<DetailTourProvider>().adults * adultPrice) +
                    (context.watch<DetailTourProvider>().children *
                        childPrice))),
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900]),
          ),
        )
      ],
    );
  }

  double getCurrentTotalAmount(DetailTourProvider tourData) {
    double t = 0;
    double adult = tourData.tour.price;
    double? child = tourData.tour.childPrice;
    if (child != null) {
      t = (context.read<DetailTourProvider>().adults * adult) +
          (context.read<DetailTourProvider>().children * child);
    } else {
      t = (context.read<DetailTourProvider>().adults * adult);
    }
    return t;
  }

  Widget elementBlank(
      IconData icon, String title, String subtitle, Widget? widget) {
    return ListTile(
      trailing: widget ?? null,
      leading: Icon(
        icon,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle,
          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
    );
  }

  Widget durationField(int? duration) {
    if (duration != null) {
      return ListTile(
        leading: Icon(
          Icons.watch_later_outlined,
          color: Colors.grey[850],
          size: 27,
        ),
        title: Text(
          getDuration(duration),
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(S.of(context).durationAndValid,
            style: TextStyle(color: Colors.grey[700], fontSize: 15)),
      );
    } else {
      return SizedBox();
    }
  } //

  Widget dateField(DateTime? date, bool avlabl) {
    if (avlabl) {
      return ListTile(
        leading: Icon(
          Icons.refresh_sharp,
          color: Colors.grey[850],
          size: 27,
        ),
        title: Text(
          S.of(context).alwaysAvailable,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
      );
    } else {
      return ListTile(
        leading: Icon(
          Icons.calendar_today,
          color: Colors.grey[850],
          size: 27,
        ),
        title: Text(
          DateFormat("dd MMMM, yyyy").format(date!),
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(S.of(context).dateAndTime,
            style: TextStyle(color: Colors.grey[700], fontSize: 15)),
      );
    }
  }

  Widget nextButton(
      {required CurrencyProvider curData,
      required AuthProvider authData,
      required DetailTourProvider tourData}) {
    return MaterialButton(
      onPressed: () async {
        // if (tourData.adults < 1) {
        //   EasyLoading.showInfo(S.of(context).atLeastOneAdult);
        // } else {
        pushNewScreen(
          context,
          screen: BillingScreen(
            curData: curData,
            adults: tourData.adults,
            tour: tourData.tour,
            children: tourData.children,
          ),
        );
        //}
      },
      child: Text(
        S.of(context).next,
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      color: Colors.green[600],
      minWidth: double.maxFinite,
      padding: EdgeInsets.only(top: 14, bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
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

  String fromListToString(List<String> list) {
    var concatenate = StringBuffer();
    list.forEach((item) {
      concatenate.write(item + ", ");
    });
    return concatenate.toString();
  }

  Widget getTitleWidget(String? cityName, String tourName) {
    if (cityName != null) {
      return Text(
        '$cityName: $tourName',
        style: TextStyle(
            color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w500),
      );
    } else {
      return Text(
        tourName,
        style: TextStyle(
            color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w500),
      );
    }
  }
}

String getPrice(CurrencyProvider data, double price) {
  // if (data.currency == "USD" || data.currency == null) {
  //   return "\$" + price.toStringAsFixed(2);
  // } else if (data.currency == "EUR") {
  //   return "€" + (price * data.euro!).toStringAsFixed(2);
  // } else if (data.currency == "AED") {
  //   return ".د.إ" + (price * data.dirham!).toStringAsFixed(2);
  // } else if (data.currency == "RUB") {
  //   return "₽" + (price * data.rouble!).toStringAsFixed(2);
  // } else if (data.currency == "THB") {
  //   return "฿" + (price * data.baht!).toStringAsFixed(2);
  // } else if (data.currency == "TRY") {
  //   return "₤" + (price * data.lira!).toStringAsFixed(2);
  // } else if (data.currency == "GBP") {
  //   return "£" + (price * data.gbp!).toStringAsFixed(2);
  // }
  // return "\$" + price.toStringAsFixed(2);
  if (data.currency == "USD" || data.currency == null) {
    return "\$" + price.toInt().toString();
  } else if (data.currency == "EUR") {
    return "€" + (price * data.euro!).toInt().toString();
  } else if (data.currency == "AED") {
    return ".د.إ" + (price * data.dirham!).toInt().toString();
  } else if (data.currency == "RUB") {
    return "₽" + (price * data.rouble!).toInt().toString();
  } else if (data.currency == "THB") {
    return "฿" + (price * data.baht!).toInt().toString();
  } else if (data.currency == "TRY") {
    return "₤" + (price * data.lira!).toInt().toString();
  } else if (data.currency == "GBP") {
    return "£" + (price * data.gbp!).toInt().toString();
  }
  return "\$" + price.toInt().toString();
}
