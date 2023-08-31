import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/notification.dart';
import 'package:vip_tourist/logic/providers/notification_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class NotificationItem extends StatelessWidget {
  final MyNotification notification;
  const NotificationItem({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(4.0, 4.0),
              blurRadius: 15.0,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4.0, -4.0),
              blurRadius: 15.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 21.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.notifications,
                    size: 40.0,
                    color: notification.isPersonal ? PRIMARY : Colors.blue[600],
                  ),
                  SizedBox(width: 24.0),
                  GestureDetector(
                    onTap: () {
                      showOkAlertDialog(
                        context: context,
                        title: notification.title,
                        message: notification.body,
                        okLabel: S.of(context).ok,
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            DateFormat("dd MMMM, yyyy, HH:mm")
                                .format(notification.dateTime),
                            maxLines: 1,
                            style:
                                TextStyle(fontSize: 17.0, color: GREEN_BLACK),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            notification.body,
                            style: TextStyle(
                              color: GREEN_GRAY,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              PopupMenuButton(
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text(S.of(context).open,
                        style: TextStyle(color: GREEN_BLACK, fontSize: 14)),
                    onTap: () {
                      showOkAlertDialog(
                          context: context,
                          title: notification.title,
                          message: notification.body,
                          okLabel: S.of(context).ok);
                    },
                    value: false,
                  ),
                  PopupMenuItem(
                    child: Text(S.of(context).delete),
                    value: false,
                    textStyle: TextStyle(color: RED, fontSize: 14),
                    onTap: () async {
                      OkCancelResult result = await showOkCancelAlertDialog(
                        context: context,
                        message: S.of(context).deleteThisNotif,
                        okLabel: S.of(context).delete,
                        barrierDismissible: false,
                        cancelLabel: S.of(context).cancel,
                        useActionSheetForCupertino: true,
                        isDestructiveAction: true,
                      );
                      if (result == OkCancelResult.ok) {
                        context.read<NotificationProvider>().deleteNotification(
                            notifID: notification.notificationID);
                        context.read<NotificationProvider>().trigger();
                      }
                    },
                  ),
                ],
                icon: Icon(Icons.more_horiz_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Flexible(
//                 child: Row(
//                   children: [
//                     IconButton(
//                       onPressed: () async {
                        // OkCancelResult result = await showOkCancelAlertDialog(
                        //   context: context,
                        //   message: S.of(context).deleteThisNotif,
                        //   okLabel: S.of(context).delete,
                        //   barrierDismissible: false,
                        //   cancelLabel: S.of(context).cancel,
                        //   useActionSheetForCupertino: true,
                        //   isDestructiveAction: true,
                        // );
                        // if (result == OkCancelResult.ok) {
                        //   context
                        //       .read<NotificationProvider>()
                        //       .deleteNotification(
                        //           notifID: notification.notificationID);
                        //   context.read<NotificationProvider>().trigger();
                        // } else {}
//                       },
//                       icon: Icon(Icons.delete, size: 30.0, color: Colors.red),
//                     ),
//                     Flexible(
//                       child: IconButton(
//                         padding: EdgeInsets.only(left: 1),
//                         onPressed: () {
                          // showOkAlertDialog(
                          //     context: context,
                          //     title: notification.title,
                          //     message: notification.body,
                          //     okLabel: S.of(context).ok);
//                         },
//                         icon: Icon(
//                           Icons.arrow_forward_ios_rounded,
//                           size: 30.0,
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )