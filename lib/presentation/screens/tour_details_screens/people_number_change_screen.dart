import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

import '../../../generated/l10n.dart';
import '../../../logic/providers/detail_tour_provider.dart';
import '../../../logic/providers/user_profile_look_provider.dart';

class PeopleNumberChangeScreen extends StatefulWidget {
  const PeopleNumberChangeScreen({Key? key}) : super(key: key);

  @override
  State<PeopleNumberChangeScreen> createState() =>
      _PeopleNumberChangeScreenState();
}

class _PeopleNumberChangeScreenState extends State<PeopleNumberChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DetailTourProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext cnt, StateSetter setState) {
        return Container(
          color: Colors.transparent,
          height: height * 0.33,
          child: Padding(
            padding: const EdgeInsets.only(left: 23, right: 23),
            child: body(setState: setState, data: data),
          ),
        );
      },
    );
  }

  Widget body(
      {required StateSetter setState, required DetailTourProvider data}) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 30, bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                S.of(context).numberOfPpl,
                style: TextStyle(
                    color: GREEN_BLACK,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.close,
                  color: GREEN_BLACK,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    S.of(context).adults,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GREEN_BLACK),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    S.of(context).from18yo,
                    style: TextStyle(fontSize: 12, color: GRAY),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().decrementAdult();
                      });
                    },
                    splashRadius: 20,
                    padding: EdgeInsets.only(bottom: 0),
                    icon: Icon(
                      Icons.remove,
                      color: GRAY,
                      size: 33,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    data.adults.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GREEN_BLACK),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().incrementAdult();
                      });
                    },
                    splashRadius: 20,
                    padding: EdgeInsets.all(0),
                    icon: Container(
                      padding: EdgeInsets.all(7),
                      decoration:
                          BoxDecoration(color: PRIMARY, shape: BoxShape.circle),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    S.of(context).children,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GREEN_BLACK),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    S.of(context).under18yo,
                    style: TextStyle(fontSize: 12, color: GRAY),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().decrementChild();
                      });
                    },
                    splashRadius: 20,
                    padding: EdgeInsets.only(bottom: 0),
                    icon: Icon(
                      Icons.remove,
                      color: GRAY,
                      size: 33,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    data.children.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GREEN_BLACK),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().incrementChild();
                      });
                    },
                    splashRadius: 20,
                    padding: EdgeInsets.all(0),
                    icon: Container(
                      padding: EdgeInsets.all(7),
                      decoration:
                          BoxDecoration(color: PRIMARY, shape: BoxShape.circle),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
