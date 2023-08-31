import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:octo_image/octo_image.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/offer_edit_provider.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offer_edit_screen.dart';

class OfferEditItem extends StatefulWidget {
  final CustomOffer data;
  const OfferEditItem({Key? key, required this.data}) : super(key: key);

  @override
  _OfferEditItemState createState() => _OfferEditItemState();
}

class _OfferEditItemState extends State<OfferEditItem> {
  @override
  Widget build(BuildContext context) {
    // SimpleFontelicoProgressDialog dialog =
    //     SimpleFontelicoProgressDialog(context: context, barrierDimisable: true);

    return Container(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            spreadRadius: -2.8,
            color: Colors.black,
            offset: Offset(2, 2),
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        minVerticalPadding: 1,
        onTap: () async {
          if ((widget.data.remarkBody == null ||
              widget.data.remarkTitle == null)) {
            await context
                .read<OfferEditProvider>()
                .getTourDetails(widget.data.tourID);
            // dialog.hide();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      OfferEditScreen(offerID: widget.data.tourID)),
            );
          } else {
            OkCancelResult? result = await showOkCancelAlertDialog(
                context: context,
                okLabel: S.of(context).ok,
                cancelLabel: S.of(context).cancel,
                title: widget.data.remarkTitle ?? "",
                message: widget.data.remarkBody ?? "",
                barrierDismissible: false);
            if (result == OkCancelResult.ok) {
              await context
                  .read<OfferEditProvider>()
                  .getTourDetails(widget.data.tourID);
              // dialog.hide();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        OfferEditScreen(offerID: widget.data.tourID)),
              );
            }
          }
        },
        leading: GestureDetector(
          onTap: () => showAFullPhoto(context, widget.data.photo!),
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.data.photo!),
          ),
        ),
        title: Text(widget.data.tourName,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          S.of(context).status +
              ": " +
              (widget.data.approved
                  ? S.of(context).active
                  : S.of(context).onConsider) +
              ", " +
              "widget.data.subtitle",
          style: TextStyle(fontSize: 13),
        ),
        trailing:
            (widget.data.remarkBody == null || widget.data.remarkTitle == null)
                ? IconButton(
                    onPressed: () async {
                      // dialog.show(
                      //     message: S.of(context).loading,
                      //     type: SimpleFontelicoProgressDialogType.hurricane);
                      await context
                          .read<OfferEditProvider>()
                          .getTourDetails(widget.data.tourID);
                      // dialog.hide();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OfferEditScreen(offerID: widget.data.tourID)),
                      );
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      OkCancelResult? result = await showOkCancelAlertDialog(
                          context: context,
                          okLabel: S.of(context).ok,
                          cancelLabel: S.of(context).cancel,
                          title: widget.data.remarkTitle,
                          message: widget.data.remarkBody,
                          barrierDismissible: false);
                      if (result == OkCancelResult.ok) {
                        await context
                            .read<OfferEditProvider>()
                            .getTourDetails(widget.data.tourID);
                        // dialog.hide();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  OfferEditScreen(offerID: widget.data.tourID)),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.warning,
                      color: Colors.yellow[700],
                      size: 28,
                    ),
                  ),
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
}
