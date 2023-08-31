import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:vip_tourist/generated/l10n.dart';

class PopupItem extends StatelessWidget {
  const PopupItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          OctoImage(
            fit: BoxFit.cover,
            height: 80,
            width: 120,
            image: AssetImage(
              'assets/lake.jpg',
            ),
            placeholderBuilder: (context) => Container(
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Padding(
            padding: EdgeInsets.only(left: 3, right: 3),
            child: Text(
              'Almaty: Charyn Canyon Tour',
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 11,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            width: 120,
            color: Colors.blue[600],
            child: Text(
              S.of(context).open,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
