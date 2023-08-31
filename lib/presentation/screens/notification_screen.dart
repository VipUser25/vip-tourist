import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/notification.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/notification_provider.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/utility/city_tour_search.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/widgets/notification_item.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String? filter;
  bool err = false;
  String msgErr = '';
  @override
  Widget build(BuildContext context) {
    Locale locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final authData = Provider.of<AuthProvider>(context);
    final data = Provider.of<NotificationProvider>(context);
    final sdata = Provider.of<HomeScreenTourProvider>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          // leading: IconButton(
          //     icon: Icon(
          //       Icons.abc_outlined,
          //       color: Colors.pink,
          //     ),
          //     onPressed: () async {
          //       await
          //     }),
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
              color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
          title: Text(
            S.of(context).notifications,
          ),
          toolbarHeight: 60,
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60.0),
          child: FloatingActionButton(
            onPressed: () => _showMultiSelect(context),
            elevation: 2,
            backgroundColor: Colors.white,
            mini: true,
            child: Icon(
              Icons.sort,
              size: 20,
              color: GREEN_BLACK,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
        body: FutureBuilder<List<MyNotification>>(
          builder: (ctx, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[650],
                  ),
                );

              default:
                if (snapshot.hasError ||
                    snapshot.data == null ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: emptyList(data: sdata, locale: locale),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, i) {
                      return NotificationItem(
                        notification: MyNotification(
                            isPersonal: snapshot.data![i].isPersonal,
                            dateTime: snapshot.data![i].dateTime,
                            uid: authData.user.getUid,
                            body: snapshot.data![i].body,
                            title: snapshot.data![i].title,
                            notificationID: snapshot.data![i].notificationID),
                      );
                    },
                    itemCount: snapshot.data!.length,
                    shrinkWrap: true,
                  );
                }
            }
          },
          future:
              data.getNotifications(uid: authData.user.getUid, filter: filter),
        )
        //,
        );
  }

  void whatsAppOpen() async {}
  Widget emptyList(
      {required HomeScreenTourProvider data, required Locale locale}) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25),
            child: OctoImage(
              image: AssetImage('assets/emptyNotifs.png'),
              height: 224,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Text(
              S.of(context).notifTag,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GREEN_BLACK),
            ),
          ),
          SizedBox(
            height: 43,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromHeight(double.infinity)),
              onPressed: () {
                bool? res;
                try {
                  res = !context.read<AuthProvider>().user.isTourist;
                } catch (e) {}

                showSearch(
                  context: context,
                  delegate: CityTourSearch(
                      data: data,
                      locale: locale,
                      search: S.of(context).enterCity,
                      suggestCities: data.suggestedList,
                      isGuide: res),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: Text(S.of(context).pickUpTours),
              ))
        ],
      ),
    );
  }

  void _showMultiSelect(BuildContext context) async {
    String? t = await showConfirmationDialog(
      context: context,
      initialSelectedActionKey: filter,
      title: S.of(context).showOnly,
      actions: [
        AlertDialogAction(key: "general", label: S.of(context).generalNotif),
        AlertDialogAction(key: "personal", label: S.of(context).personalNotif),
        AlertDialogAction(key: "all", label: S.of(context).showAll),
      ],
      okLabel: S.of(context).ok,
      cancelLabel: S.of(context).cancel,
    );
    setState(() {
      filter = t;
    });
  }
}
