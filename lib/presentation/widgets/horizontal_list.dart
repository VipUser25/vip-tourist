import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/models/mini_tour.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/widgets/home_tour_item.dart';

class HorizontalList extends StatefulWidget {
  final String headerText;
  final String keyword;
  final Map<String, MiniTour> tours;
  final Locale locale;
  const HorizontalList(
      {Key? key,
      required this.headerText,
      required this.keyword,
      required this.tours,
      required this.locale})
      : super(key: key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  Map<String, MiniTour> mapp = {};

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.tours.length; i++) {
      String key = widget.tours.keys.elementAt(i);
      if (widget.tours[key]!.category[widget.keyword]) {
        mapp.putIfAbsent(key, () => widget.tours[key]!);
      }
    }

    return mapp.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  widget.headerText,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 270,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: mapp.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = mapp.keys.elementAt(index);
                      return Row(children: [
                        GestureDetector(
                          onTap: () {
                            List<MiniLocal>? localizat =
                                mapp["key"]?.localizations!;
                            String currentCode = widget.locale.languageCode;
                            String? vid;
                            if (localizat != null) {
                              if (localizat.isNotEmpty) {
                                localizat.forEach((element) {
                                  if (element.code.contains("en")) {
                                    vid = element.id;
                                  } else if (element.code.contains("ru")) {
                                    vid = element.id;
                                  } else if (element.code.contains("ar")) {
                                    vid = element.id;
                                  } else if (element.code.contains("de")) {
                                    vid = element.id;
                                  } else if (element.code.contains("es")) {
                                    vid = element.id;
                                  } else if (element.code.contains("fr")) {
                                    vid = element.id;
                                  } else if (element.code.contains("it")) {
                                    vid = element.id;
                                  } else if (element.code.contains("th")) {
                                    vid = element.id;
                                  } else if (element.code.contains("tr")) {
                                    vid = element.id;
                                  } else {
                                    vid = element.id;
                                  }
                                });
                              }
                            }

                            pushNewScreen(context,
                                screen: TourDetailScreen(), withNavBar: false);
                            context
                                .read<DetailTourProvider>()
                                .getTourDetails(vid ?? mapp[key]!.tourID);
                          },
                          child: TourHomeItem(
                            image: mapp[key]!.photoURL,
                            currency: '\$',
                            name: mapp[key]!.name,
                            price: mapp[key]!.price,
                            rate: mapp[key]!.rating,
                            reviewCount: mapp[key]!.reviews!,
                            duration: mapp[key]!.duration,
                            reviews: mapp[key]!.reviews!,
                            id: key,
                          ),
                        ),
                        SizedBox(
                          width: 17,
                        )
                      ]);
                    }),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          );
  }
}
