import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/presentation/widgets/commentary_builder.dart';
import 'package:vip_tourist/presentation/widgets/commentary_builder_two.dart';

import '../../../logic/utility/constants.dart';

class MoreReviewScreen extends StatefulWidget {
  const MoreReviewScreen({Key? key}) : super(key: key);

  @override
  _MoreReviewScreenState createState() => _MoreReviewScreenState();
}

class _MoreReviewScreenState extends State<MoreReviewScreen> {
  bool isTranslated = false;
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        heroTag: "1",
        onPressed: () async {
          if (isTranslated) {
            setState(() {
              isTranslated = !isTranslated;
            });
          } else {
            EasyLoading.show(status: S.of(context).loading);
            await context
                .read<DetailTourProvider>()
                .translate(locale.languageCode);
            setState(() {
              isTranslated = !isTranslated;
            });
            EasyLoading.dismiss();
          }
          print("IS TEXT TRANSLATED?");
          print(isTranslated);
          print("ORIGINAL");
          print(context.read<DetailTourProvider>().reviews[0].messageBody);
          print(context.read<DetailTourProvider>().reviews[1].messageBody);
          print(context.read<DetailTourProvider>().reviews[2].messageBody);
          print("TRANSLATION");
          print(context.read<DetailTourProvider>().tranlations[0].messageBody);
          print(context.read<DetailTourProvider>().tranlations[1].messageBody);
          print(context.read<DetailTourProvider>().tranlations[2].messageBody);
        },
        backgroundColor: PRIMARY,
        child: isTranslated
            ? Icon(
                Icons.restart_alt_outlined,
                color: Colors.white,
              )
            : Icon(
                Icons.translate,
                color: Colors.white,
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
          title: Text(
            S.of(context).reviews,
          ),
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
        body: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 70),
          child: SingleChildScrollView(child: getScreen()),
        ),
      ),
    );
  }

  Widget getScreen() {
    if (isTranslated) {
      return CommentaryBuildeTwo();
    } else {
      return CommentaryBuilder();
    }
  }
}
