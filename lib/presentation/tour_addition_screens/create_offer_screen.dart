import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/presentation/tour_addition_screens/add_offer_screen.dart';

class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({Key? key}) : super(key: key);

  @override
  _CreateOfferScreenState createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  String? text = "";
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          S.of(context).addOffer,
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
                    labelText: S.of(context).enterCity,
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
              FutureBuilder<Map<String, TourCityMix>>(
                future: context.read<TourAdditionProvider>().getCitiesAndTours(
                    localeCode: locale.languageCode, text: text),
                builder: (contextt, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );

                    default:
                      if (snapshot.hasError ||
                          snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        return Center(
                          child: Text(S.of(context).noDataFound),
                        );
                      } else {
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (ctx, i) {
                            String key = snapshot.data!.keys.elementAt(i);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 3.0),
                              child: Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    snapshot.data![key]!.tourName +
                                        ", " +
                                        snapshot.data![key]!.cityName,
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey[850],
                                        fontWeight: FontWeight.w500),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      //logic here
                                      pushNewScreen(context,
                                          screen: AddOfferScreen(tourID: key),
                                          withNavBar: false);
                                    },
                                    icon: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.grey[850],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
