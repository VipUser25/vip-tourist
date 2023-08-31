import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/order.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:vip_tourist/logic/providers/user_profile_look_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/user_profile_look_screen.dart';

class OrderItem extends StatefulWidget {
  final Order order;
  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  late bool activated;
  late bool canceled;
  late bool sellerConfirmed;

  @override
  void initState() {
    // TODO: implement initState
    activated = widget.order.activated;
    canceled = widget.order.canceled;
    sellerConfirmed = widget.order.sellerConfirmed;
    super.initState();
  }

  Widget build(BuildContext context) {
    print("ACTIVATED CHECK");
    print(activated);
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 1.7, color: LIGHT_GRAY)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.order.tourName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold),
                ),
              ),
              leftPopUpButton()
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "x1  " + widget.order.price.toString() + "\$",
            style: TextStyle(
              fontSize: 16,
              color: GREEN_GRAY,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            widget.order.sellerName,
            style: TextStyle(
              fontSize: 16,
              color: GRAY,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: LIGHT_GRAY),
          ),
          getLowerWidget()
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  Future<void> showAFullPhoto(BuildContext cont, String image) async {
    showDialog<void>(
      barrierDismissible: true,
      context: cont,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OctoImage(
                image: NetworkImage(image),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getTitle({required String sellerName, required double price}) {
    return sellerName + ", " + "x1, " + price.toString() + "\$";
  }

  String getSubtitle({required DateTime date, required String tourName}) {
    return tourName + ", " + DateFormat("dd MMMM, yyyy, HH:mm").format(date);
  }

  Widget getLowerWidget() {
    if (!canceled && !sellerConfirmed) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle_fill,
              color: RED,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).confirmTicket,
              style: TextStyle(color: RED, fontSize: 16),
            )
          ],
        ),
      );
    } else if (canceled) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Icon(
              CupertinoIcons.exclamationmark_circle_fill,
              color: RED,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).ticketIsCanceled,
              style: TextStyle(color: RED, fontSize: 16),
            )
          ],
        ),
      );
    } else if (activated && sellerConfirmed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.person_fill,
                color: GREEN_GRAY,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).touristUsedTicket,
                style: TextStyle(color: GREEN_GRAY, fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: LIGHT_GRAY),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: PRIMARY,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).uConfirmedTicket,
                style: TextStyle(color: PRIMARY, fontSize: 16),
              )
            ],
          ),
        ],
      );
    } else if (sellerConfirmed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.person_fill,
                color: GRAY,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).touristDidntUseTicket,
                style: TextStyle(color: GRAY, fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            decoration: BoxDecoration(color: LIGHT_GRAY),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: PRIMARY,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                S.of(context).uConfirmedTicket,
                style: TextStyle(color: PRIMARY, fontSize: 16),
              )
            ],
          ),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget leftPopUpButton() {
    if (sellerConfirmed || canceled) {
      return Container(
        height: 1,
        width: 1,
      );
    } else {
      return PopupMenuButton(
        icon: Icon(
          Icons.more_horiz,
          color: GREEN_BLACK,
        ),
        onSelected: (bool value) async {
          if (value) {
            bool res = await context
                .read<PurchaseOrderProvider>()
                .confirmBooking(offerID: widget.order.orderID);

            if (res) {
              setState(() {
                sellerConfirmed = true;
              });
              showOkAlertDialog(
                context: context,
                message: S.of(context).successfull,
              );
            } else {
              showOkAlertDialog(
                  context: context, message: S.of(context).errorOccured);
            }
          } else {
            bool res = await context
                .read<PurchaseOrderProvider>()
                .cancelBooking(offerID: widget.order.orderID);
            if (res) {
              setState(() {
                canceled = true;
              });
              showOkAlertDialog(
                context: context,
                message: S.of(context).successfull,
              );
            } else {
              showOkAlertDialog(
                  context: context, message: S.of(context).errorOccured);
            }
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            child: Text(S.of(context).confirmBooking),
            value: true,
          ),
          PopupMenuItem(
            child: Text(S.of(context).cancel),
            value: false,
          )
        ],
      );
    }
  }

  Widget oldOne() {
    return ListTile(
      minVerticalPadding: 1,
      onTap: () async {},
      leading: GestureDetector(
        child: GestureDetector(
          onTap: () {
            pushNewScreen(context,
                screen: UserProfileLookScreen(), withNavBar: false);
            context
                .read<UserProfileLookProvider>()
                .getUser(id: widget.order.buyerID);
          },
          child: CircleAvatar(
            child: Text(widget.order.sellerName[0].toUpperCase()),
          ),
        ),
      ),
      title: Text(
        getTitle(
            sellerName: widget.order.sellerName, price: widget.order.price),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        getSubtitle(date: widget.order.date, tourName: widget.order.tourName),
        style: TextStyle(fontSize: 13),
      ),
      trailing: (sellerConfirmed || canceled)
          ? Container(
              height: 1,
              width: 1,
            )
          : PopupMenuButton(
              icon: Icon(Icons.more_horiz),
              onSelected: (bool value) async {
                if (value) {
                  bool res = await context
                      .read<PurchaseOrderProvider>()
                      .confirmBooking(offerID: widget.order.orderID);

                  if (res) {
                    setState(() {
                      sellerConfirmed = true;
                    });
                    showOkAlertDialog(
                      context: context,
                      message: S.of(context).successfull,
                    );
                  } else {
                    showOkAlertDialog(
                        context: context, message: S.of(context).errorOccured);
                  }
                } else {
                  bool res = await context
                      .read<PurchaseOrderProvider>()
                      .cancelBooking(offerID: widget.order.orderID);
                  if (res) {
                    setState(() {
                      canceled = true;
                    });
                    showOkAlertDialog(
                      context: context,
                      message: S.of(context).successfull,
                    );
                  } else {
                    showOkAlertDialog(
                        context: context, message: S.of(context).errorOccured);
                  }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text(S.of(context).confirmBooking),
                  value: true,
                ),
                PopupMenuItem(
                  child: Text(S.of(context).cancel),
                  value: false,
                )
              ],
            ),
    );
  }
}
