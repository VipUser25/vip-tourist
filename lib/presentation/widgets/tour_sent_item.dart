import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offer_edit_screen.dart';

class TourSentItem extends StatelessWidget {
  final String photo;
  final String name;

  const TourSentItem({
    Key? key,
    required this.photo,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: LIGHT_GRAY, width: 1.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            photo,
            height: 100,
            width: 130,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: Text(
            name,
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: GREEN_BLACK),
          ),
        ),
      ]),
    );
  }
}
