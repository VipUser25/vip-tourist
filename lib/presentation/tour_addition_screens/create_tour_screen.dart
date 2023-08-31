import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/add_tour_screen.dart';

class CreateTourScreen extends StatefulWidget {
  const CreateTourScreen({Key? key}) : super(key: key);

  @override
  _CreateTourScreenState createState() => _CreateTourScreenState();
}

class _CreateTourScreenState extends State<CreateTourScreen> {
  int n = 7;
  String text = "";
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          S.of(context).addTour,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Card(
                child: TextFormField(
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
                    suffixIcon: Icon(Icons.search),
                    prefixIcon: Icon(
                      Icons.location_city,
                    ),
                    labelText: S.of(context).enterCityName,
                    labelStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // FutureBuilder<List<MiniCity>>(
              //   future: context.read<TourAdditionProvider>().getCities(
              //       localeCode: locale.languageCode, text: text, n: n),
              //   builder: (contextt, snapshot) {
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.waiting:
              //         return Padding(
              //           padding: EdgeInsets.only(
              //               top: MediaQuery.of(context).size.height / 3),
              //           child: Center(
              //             child: Padding(
              //               padding: EdgeInsets.only(
              //                   top: MediaQuery.of(context).size.height / 11.5),
              //               child: CircularProgressIndicator(),
              //             ),
              //           ),
              //         );

              //       default:
              //         if (snapshot.hasError ||
              //             snapshot.data == null ||
              //             snapshot.data!.isEmpty) {
              //           return Padding(
              //             padding: const EdgeInsets.only(top: 20.0),
              //             child: MaterialButton(
              //               onPressed: () {
              //                 pushNewScreen(context,
              //                     screen: AddTourScreen(
              //                       requestedCity: text,
              //                     ),
              //                     withNavBar: false);
              //               },
              //               child: Text(
              //                 S.of(context).next,
              //                 style: TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 17,
              //                     fontWeight: FontWeight.w500),
              //               ),
              //               color: Colors.blue[600],
              //               minWidth: double.maxFinite,
              //               padding: EdgeInsets.only(top: 12.5, bottom: 12.5),
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(20),
              //               ),
              //             ),
              //           );
              //         } else {
              //           return ListView.builder(
              //             physics: NeverScrollableScrollPhysics(),
              //             shrinkWrap: true,
              //             scrollDirection: Axis.vertical,
              //             itemCount: snapshot.data!.length + 1,
              //             itemBuilder: (ctx, i) {
              //               if (i == snapshot.data!.length) {
              //                 return Container(
              //                   width: 90,
              //                   height: 150,
              //                   child: IconButton(
              //                     padding: EdgeInsets.symmetric(horizontal: 1),
              //                     icon: Icon(
              //                       Icons.arrow_downward_rounded,
              //                       color: Colors.blue[600],
              //                       size: 40,
              //                     ),
              //                     onPressed: () async {
              //                       setState(() {
              //                         n = n + 7;
              //                       });
              //                     },
              //                   ),
              //                 );
              //               } else {
              //                 return Padding(
              //                   padding: const EdgeInsets.only(bottom: 8.0),
              //                   child: Card(
              //                     color: Colors.white,
              //                     child: ListTile(
              //                       leading: Container(
              //                         width: 80,
              //                         height: 30,
              //                         decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(15),
              //                           image: DecorationImage(
              //                               image: NetworkImage(
              //                                   snapshot.data![i].flag)),
              //                         ),
              //                       ),
              //                       title: GestureDetector(
              //                         onTap: () {
              //                           pushNewScreen(context,
              //                               screen: AddTourScreen(
              //                                   cityID:
              //                                       snapshot.data![i].cityID),
              //                               withNavBar: false);
              //                         },
              //                         child: Text(
              //                           snapshot.data![i].cityName,
              //                           style: TextStyle(
              //                               fontSize: 18,
              //                               color: Colors.grey[850],
              //                               fontWeight: FontWeight.w500),
              //                         ),
              //                       ),
              //                       trailing: IconButton(
              //                         onPressed: () {
              //                           pushNewScreen(context,
              //                               screen: AddTourScreen(
              //                                   cityID:
              //                                       snapshot.data![i].cityID),
              //                               withNavBar: false);
              //                         },
              //                         icon: Icon(
              //                           Icons.arrow_forward_ios,
              //                           color: Colors.grey[850],
              //                         ),
              //                       ),
              //                     ),
              //                   ),
              //                 );
              //               }
              //             },
              //           );
              //         }
              //     }
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
