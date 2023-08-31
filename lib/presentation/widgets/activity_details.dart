import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vip_tourist/generated/l10n.dart';

class ActivityDetails {
  final S data;
  ActivityDetails({required this.data});

  Widget get freeCancelation {
    return ListTile(
      leading: Icon(
        Icons.today,
        color: Colors.green[800],
        size: 27,
      ),
      title: Text(
        data.freeCancel,
        style: TextStyle(
            color: Colors.green[800],
            fontSize: 15,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        data.cancelupToTwentyFour,
        style: TextStyle(color: Colors.grey[700], fontSize: 15),
      ),
    );
  }

  Widget get covid19 {
    return ListTile(
      leading: Icon(
        Icons.medical_services_rounded,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        data.covidPrecautions,
        style: TextStyle(
            color: Colors.green[800],
            fontSize: 15,
            fontWeight: FontWeight.w600),
      ),
      subtitle: Text(data.covidTag,
          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
    );
  }

  Widget get mobileTicketing {
    return ListTile(
      leading: Icon(
        Icons.bookmark_added,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        data.mobileTicketing,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(data.vouchersMustBe,
          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
    );
  }

  Widget getAlwaysAvailableBlock(
      {required bool alwaysAvailable,
      DateTime? date,
      String? time,
      String? weekdays}) {
    if (alwaysAvailable) {
      return ListTile(
        leading: Icon(
          Icons.watch_later_outlined,
          color: Colors.grey[850],
          size: 27,
        ),
        title: Text(
          data.toursAreScheduled,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(getWeekdays(weekdays!),
            style: TextStyle(color: Colors.grey[700], fontSize: 15)),
      );
    } else {
      return ListTile(
        leading: Icon(
          Icons.watch_later_outlined,
          color: Colors.grey[850],
          size: 27,
        ),
        title: Text(
          data.dateAndTime,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 15,
              fontWeight: FontWeight.w600),
        ),
        subtitle: Text(DateFormat("dd MMMM, yyyy").format(date!) + ", " + time!,
            style: TextStyle(color: Colors.grey[700], fontSize: 15)),
      );
    }
  }

  String getWeekdays(String val) {
    String cc = "";
    List<String> days = val.split(",");
    days.forEach((element) {
      if (element == "mn") {
        cc = cc + data.monday + ", ";
      } else if (element == "tu") {
        cc = cc + data.tuesday + ", ";
      } else if (element == "wd") {
        cc = cc + data.wednesday + ", ";
      } else if (element == "th") {
        cc = cc + data.thursday + ", ";
      } else if (element == "fr") {
        cc = cc + data.friday + ", ";
      } else if (element == "st") {
        cc = cc + data.saturday + ", ";
      } else if (element == "sn") {
        cc = cc + data.sunday + ", ";
      }
    });
    return cc.substring(0, cc.length - 2);
  }

  Widget get instantCofirmation {
    return ListTile(
      leading: Icon(
        Icons.flash_on,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        data.guideConfirm,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget duration() {
    return ListTile(
      leading: Icon(
        Icons.watch_later_outlined,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        data.duration + ' 3 - 6 ' + data.hours,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(data.checkAvail,
          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
    );
  }

  Widget liveTourGuide() {
    return ListTile(
      leading: Icon(
        Icons.people,
        color: Colors.grey[850],
        size: 27,
      ),
      title: Text(
        data.liveTour,
        style: TextStyle(
            color: Colors.grey[850], fontSize: 15, fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Enlish, Russian',
          style: TextStyle(color: Colors.grey[700], fontSize: 15)),
    );
  }

  Widget details(String value) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          data.detailsAndHig,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey[850],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 18,
        ),
        // Row(
        //   children: <Widget>[
        //     Text(
        //       "• ",
        //       style: TextStyle(color: Colors.red[700], fontSize: 35),
        //     ),
        //     Expanded(
        //       child: Text(
        //         'Maecenas sodales ut elit a pulvinar. Nam aliquam, ante scelerisque condimentum aliquet',
        //         style: TextStyle(
        //             color: Colors.grey[850],
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   children: <Widget>[
        //     Text(
        //       "• ",
        //       style: TextStyle(color: Colors.red[700], fontSize: 35),
        //     ),
        //     Expanded(
        //       child: Text(
        //         'Donec eu risus sed felis porttitor vehicula.',
        //         style: TextStyle(
        //             color: Colors.grey[850],
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   children: <Widget>[
        //     Text(
        //       "• ",
        //       style: TextStyle(color: Colors.red[700], fontSize: 35),
        //     ),
        //     Expanded(
        //       child: Text(
        //         'Mauris sed nisl placerat, facilisis tellus sit amet, mattis purus. Sed euismod, risus sed vestibulum fringilla, arcu nulla posuere ligula',
        //         style: TextStyle(
        //             color: Colors.grey[850],
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   children: <Widget>[
        //     Text(
        //       "• ",
        //       style: TextStyle(color: Colors.red[700], fontSize: 35),
        //     ),
        //     Expanded(
        //       child: Text(
        //         'Maecenas sodales ut elit a pulvinar. ',
        //         style: TextStyle(
        //             color: Colors.grey[850],
        //             fontSize: 16,
        //             fontWeight: FontWeight.w400),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}
