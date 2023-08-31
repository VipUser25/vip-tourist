import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';

import 'package:vip_tourist/logic/models/tour.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';

class MoreDetailedScreen extends StatefulWidget {
  final Tour tour;
  final String tourDescription;
  const MoreDetailedScreen(
      {Key? key, required this.tour, required this.tourDescription})
      : super(key: key);

  @override
  _MoreDetailedScreenState createState() => _MoreDetailedScreenState();
}

class _MoreDetailedScreenState extends State<MoreDetailedScreen> {
  late CarouselController carouselController;
  @override
  void initState() {
    // TODO: implement initState
    carouselController = CarouselController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final curData = Provider.of<CurrencyProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text(S.of(context).details),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                guideTile(),
                SizedBox(
                  height: 8,
                ),
                fullDescription(widget.tourDescription, curData),

                carPhotoBlock(),
                getIncluded(),
                getNotIncluded(),
                getPrereq(),
                getProhibs(),
                (widget.tour.freeTicketNotice == null ||
                        widget.tour.freeTicketNotice == "" ||
                        widget.tour.freeTicketNotice == " ")
                    ? Container()
                    : freeTicketNoticeBlock(),
                cancelationPolicy(),
                SizedBox(
                  height: 10,
                ),
                // covid19()
              ],
            )),
      ),
    );
  }

  Widget fullDescription(String desc, CurrencyProvider curData) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).fullDesc,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          desc,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        durationField(widget.tour.duration),
        elementBlank(Icons.emoji_people, S.of(context).liveTour,
            fromListToString(widget.tour.languages), null),
        dateField(widget.tour.date, widget.tour.alwaysAvailable),
        elementBlank(Icons.emoji_people, S.of(context).adultPrice,
            getPrice(curData, widget.tour.price), null),
        (widget.tour.childPrice == null || widget.tour.childPrice == 0)
            ? Container()
            : elementBlank(Icons.child_care, S.of(context).childPrice,
                getPrice(curData, widget.tour.childPrice!), null),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget getIncluded() {
    if (widget.tour.included == null) {
      return Container();
    } else {
      if (widget.tour.included!.isEmpty ||
          widget.tour.included == "" ||
          widget.tour.included == " ") {
        return Container();
      } else {
        return included();
      }
    }
  }

  Widget included() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).whatIncluded,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          widget.tour.included!,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget getNotIncluded() {
    if (widget.tour.notIncluded == null) {
      return Container();
    } else {
      if (widget.tour.notIncluded!.isEmpty ||
          widget.tour.notIncluded == "" ||
          widget.tour.notIncluded == " ") {
        return Container();
      } else {
        return notIncluded();
      }
    }
  }

  Widget getPrereq() {
    if (widget.tour.prerequisites == null) {
      return Container();
    } else {
      if (widget.tour.prerequisites!.isEmpty ||
          widget.tour.prerequisites == "" ||
          widget.tour.prerequisites == " ") {
        return Container();
      } else {
        return prerequisites();
      }
    }
  }

  Widget getProhibs() {
    if (widget.tour.prohibitions == null) {
      return Container();
    } else {
      if (widget.tour.prohibitions!.isEmpty ||
          widget.tour.prohibitions == "" ||
          widget.tour.prohibitions == " ") {
        return Container();
      } else {
        return prohibitions();
      }
    }
  }

  Widget notIncluded() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).whatNotIncluded,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          widget.tour.notIncluded!,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget prerequisites() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).prerequisites,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          widget.tour.prerequisites!,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget prohibitions() {
    print("CHECKCCKCKCKCK");
    print(widget.tour.prohibitions == null);
    print(widget.tour.prohibitions == "");
    print(widget.tour.prohibitions!.isEmpty);

    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).prohibs,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          widget.tour.prohibitions!,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget note(String note) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).note,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          note,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget points(String value, Color? color) {
    //////////////////////////////////////////////////////////// blanks widget for paragraphs
    return Row(
      children: <Widget>[
        Text(
          "• ",
          style: TextStyle(color: color, fontSize: 35),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Widget cancelationPolicy() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).cancellationPolicy,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          S.of(context).cancelupToTwentyFour,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget freeTicketNoticeBlock() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).notesAboutFreeTour2,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        Text(
          widget.tour.freeTicketNotice!,
          style: TextStyle(
              color: Colors.grey[850],
              fontSize: 16,
              fontWeight: FontWeight.w400),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget carPhotoBlock() {
    if (widget.tour.withTransfer) {
      return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            S.of(context).carPhoto,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900]),
          ),
          SizedBox(
            height: 18,
          ),
          Image.network(
            widget.tour.transferPhotoUrl!,
            height: 300,
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            thickness: 0.3,
            color: Colors.grey,
          )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget covid19() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          S.of(context).covidPrecautions,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900]),
        ),
        SizedBox(
          height: 18,
        ),
        covidPoint(S.of(context).covidOne),
        covidPoint(S.of(context).covidTwo),
        covidPoint(S.of(context).covidThree),
        covidPoint(S.of(context).covidFour),
        SizedBox(
          height: 15,
        ),
        Divider(
          thickness: 0.3,
          color: Colors.grey,
        )
      ],
    );
  }

  Widget covidPoint(String text) {
    return Row(
      children: <Widget>[
        Icon(
          Icons.check,
          color: Colors.green[900],
          size: 23,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: Colors.grey[850],
                fontSize: 16,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
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

  Widget dateField(DateTime? date, bool aval) {
    if (aval) {
      return ListTile(
        leading: Icon(
          Icons.restore,
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

  String fromListToString(List<String> list) {
    var concatenate = StringBuffer();
    list.forEach((item) {
      concatenate.write(item + ", ");
    });
    return concatenate.toString();
  }

  Widget guideTile() {
    return ListTile(
        contentPadding: EdgeInsets.only(right: 30, bottom: 10, top: 10),
        leading: widget.tour.userPhoto!.isEmpty
            ? CircleAvatar(
                maxRadius: 30,
                child: Text(
                  widget.tour.userName.toString()[0].toUpperCase(),
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
              )
            : GestureDetector(
                onTap: () => showAFullPhoto(context, widget.tour.userPhoto!),
                child: CircleAvatar(
                  maxRadius: 40,
                  backgroundImage: NetworkImage(widget.tour.userPhoto!),
                ),
              ),
        title: Padding(
          padding: EdgeInsets.only(bottom: 7),
          child: Text(
            S.of(context).guide + ": " + widget.tour.userName,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[850],
                fontSize: 20),
          ),
        ),
        subtitle: Row(
          children: [
            RatingBar.builder(
              wrapAlignment: WrapAlignment.center,
              ignoreGestures: true,
              itemSize: 19,
              glowColor: Color.fromRGBO(255, 206, 100, 1),
              initialRating: widget.tour.rating.toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Color.fromRGBO(255, 188, 44, 1),
              ),
              onRatingUpdate: (double value) {},
            ),
            Text("  ${widget.tour.rating}/5")
          ],
        ));
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

  Widget slider() {
    print(widget.tour.photos);
    if (widget.tour.photos.isEmpty) {
      return Container();
    } else {
      return CarouselSlider.builder(
          carouselController: carouselController,
          itemCount: widget.tour.photos.length,
          itemBuilder: (BuildContext ctx, int itemIndex, int pageViewIndex) =>
              OctoImage(
                image: NetworkImage(widget.tour.photos[itemIndex]),
                fit: BoxFit.fitHeight,
                height: 150,
              ),
          options: CarouselOptions(
            autoPlay: false,
          ));
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
}
