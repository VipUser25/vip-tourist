import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import '../../logic/providers/home_tour_provider.dart';
import '../../logic/providers/localization_provider.dart';
import '../../logic/providers/tour_addition_provider.dart';
import 'add_tour_screen.dart';

class TourDefineScreen extends StatefulWidget {
  const TourDefineScreen({Key? key}) : super(key: key);

  @override
  _TourDefineScreenState createState() => _TourDefineScreenState();
}

class _TourDefineScreenState extends State<TourDefineScreen> {
  int n = 12;
  String text = "";
  final citiesController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    citiesController.addListener(() {
      if (citiesController.position.maxScrollExtent ==
          citiesController.offset) {
        print("MAX SCROLL EVENT SRABATYBAET??");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(S.of(context).addTour),
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: CustomRefreshIndicator(
        onRefresh: () async {
          setState(() {
            n = n + 12;
          });
        },
        reversed: true,
        builder: (BuildContext context, Widget child,
            IndicatorController controller) {
          return child;
        },
        child: SingleChildScrollView(
          controller: citiesController,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).selectCity,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: GREEN_BLACK,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autofocus: false,
                  enableSuggestions: true,
                  enableIMEPersonalizedLearning: true,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  onChanged: (value) {
                    setState(() {
                      text = value;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                    ),
                    hintText: S.of(context).findCity,
                    labelStyle: TextStyle(color: GRAY, fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: GRAY),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<Map<String, List<MiniCity>>>(
                  future: context.read<TourAdditionProvider>().getCities(
                      localeCode: locale.languageCode, text: text, n: n),
                  builder: (contextt, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height / 3),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height /
                                      11.5),
                              child: CircularProgressIndicator(
                                valueColor:
                                    new AlwaysStoppedAnimation<Color>(PRIMARY),
                              ),
                            ),
                          ),
                        );

                      default:
                        if (snapshot.hasError ||
                            snapshot.data == null ||
                            snapshot.data!.isEmpty) {
                          return emptyList(context: context);
                        } else {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int j) {
                              String key = snapshot.data!.keys.elementAt(j);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  staticTile(""),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    key,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data![key]!.length + 1,
                                    itemBuilder: (BuildContext context, int i) {
                                      if (i == snapshot.data![key]!.length) {
                                        return Container();
                                      } else {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            InkWell(
                                              splashColor: Colors.white,
                                              focusColor: Colors.white,
                                              hoverColor: Colors.white,
                                              highlightColor: Colors.white,
                                              onTap: () {
                                                print("CHECK FUCK");
                                                print(snapshot.data![key]![i]);
                                                pushNewScreen(context,
                                                    screen: AddTourScreen(
                                                        cityID: snapshot
                                                            .data![key]![i]
                                                            .cityID),
                                                    withNavBar: false);
                                              },
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              snapshot
                                                                  .data![key]![
                                                                      i]
                                                                  .flag),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Text(
                                                      snapshot.data![key]![i]
                                                          .cityName,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color:
                                                              Colors.grey[850],
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.black,
                                                      size: 24,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            // Divider(
                                            //   thickness: 0.5,
                                            //   color: GRAY,
                                            // )
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                    }
                  },
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget emptyList({required BuildContext context}) {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 7,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25),
          child: OctoImage(
            image: AssetImage('assets/city.png'),
            height: 224,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15),
          child: Text(
            S.of(context).noCitiesFound,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: GREEN_BLACK),
          ),
        ),
      ],
    ),
  );
}

Widget staticTile(String text) {
  return Container(
    width: double.maxFinite,
    height: 7,
    color: LIGHT_GRAY,
    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
  );
}
// return ListView.builder(
//                           physics: NeverScrollableScrollPhysics(),
//                           shrinkWrap: true,
//                           scrollDirection: Axis.vertical,
//                           itemCount: snapshot.data!.length + 1,
//                           itemBuilder: (ctx, i) {
                            // if (i == snapshot.data!.length) {
                            //   return Container(
                            //     width: 90,
                            //     height: 150,
                            //     child: IconButton(
                            //       padding: EdgeInsets.symmetric(horizontal: 1),
                            //       icon: Icon(
                            //         Icons.arrow_downward_rounded,
                            //         color: PRIMARY,
                            //         size: 40,
                            //       ),
                            //       onPressed: () async {
                            //         setState(() {
                            //           n = n + 7;
                            //         });
                            //       },
                            //     ),
                            //   );
                            // } else {
                            //   return Column(
                            //     children: [
                            //       const SizedBox(
                            //         height: 10,
                            //       ),
                            //       GestureDetector(
                            //         onTap: () {
                            //           print("CHECK FUCK");
                            //           print(snapshot.data![i].cityID);
                            //           pushNewScreen(context,
                            //               screen: AddTourScreen(
                            //                   cityID: snapshot.data![i].cityID),
                            //               withNavBar: false);
                            //         },
                            //         child: Row(
                            //           children: [
                            //             Container(
                            //               width: 60,
                            //               height: 30,
                            //               decoration: BoxDecoration(
                            //                 borderRadius:
                            //                     BorderRadius.circular(5),
                            //                 image: DecorationImage(
                            //                     image: NetworkImage(
                            //                         snapshot.data![i].flag)),
                            //               ),
                            //             ),
                            //             const SizedBox(
                            //               width: 20,
                            //             ),
                            //             Text(
                            //               snapshot.data![i].cityName,
                            //               style: TextStyle(
                            //                   fontSize: 18,
                            //                   color: Colors.grey[850],
                            //                   fontWeight: FontWeight.w500),
                            //             ),
                            //             Spacer(),
                            //             Icon(
                            //               Icons.arrow_forward_ios,
                            //               color: GRAY,
                            //               size: 20.5,
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //       const SizedBox(
                            //         height: 10,
                            //       ),
                            //       Divider(
                            //         thickness: 0.5,
                            //         color: GRAY,
                            //       )
                            //     ],
                            //   );
                            // }
//                           },
//                         );