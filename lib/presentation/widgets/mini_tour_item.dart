import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offer_edit_screen.dart';

class MiniTouritem extends StatelessWidget {
  final String price;
  final String photo;
  final String name;
  final String description;

  const MiniTouritem({
    Key? key,
    required this.photo,
    required this.price,
    required this.description,
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
        Stack(
          alignment: Alignment.topLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                photo,
                height: 100,
                width: 130,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 7,
              top: 7,
              child: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 3, bottom: 3),
                decoration: BoxDecoration(
                  color: YELLOW,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  price,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: GREEN_BLACK),
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          width: 10,
        ),
        SizedBox(
          width: width / 1.91,
          child: Column(
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: GREEN_BLACK),
              ),
              Text(
                description,
                maxLines: 3,
                style: TextStyle(fontSize: 14, color: GRAY),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
        )
      ]),
    );
  }
}
