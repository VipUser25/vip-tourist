import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  List<File> files = [];
  List<String> filePaths = [];
  late RoundedLoadingButtonController controller;
  late RoundedLoadingButtonController controller2;
  late TextEditingController socialNetworkController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool resetAfterDuration = true;
  @override
  void initState() {
    // TODO: implement initState
    controller = RoundedLoadingButtonController();
    controller2 = RoundedLoadingButtonController();
    socialNetworkController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).becomeGuide,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  S.of(context).toBecomeGuideNew,
                  style: TextStyle(fontSize: 20, color: GREEN_GRAY),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              paragraphTile(number: "1", text: S.of(context).provideLink),
              const SizedBox(
                height: 25,
              ),
              Form(
                key: formKey,
                child: TextFormField(
                  controller: socialNetworkController,
                  validator: (value) {
                    if (value != null) {
                      if (value.isEmpty ||
                          value.length == 0 ||
                          value == "" ||
                          value == " ") {
                        return S.of(context).fieldShouldntBe;
                      } else if (value.length < 8) {
                        return S.of(context).invalid;
                      } else {
                        return null;
                      }
                    } else {
                      return S.of(context).fieldShouldntBe;
                    }
                  },
                  decoration: InputDecoration(
                      hintStyle: TextStyle(color: GRAY),
                      hintText: S.of(context).socialNetworkEx,
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
                      )),
                  enabled: true,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              sendSocialLinkToVerify(),
              const SizedBox(
                height: 25,
              ),
              paragraphTile(number: "2", text: S.of(context).uploadDoc),
              const SizedBox(
                height: 15,
              ),
              paragraph(S.of(context).guideBecomeDocOne),
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
              paragraph(S.of(context).guideBecomeDocThree),
              SizedBox(
                height: 25,
              ),
              files.isEmpty ? uploadDocuments() : customGridViewBuilder(),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                    onPressed: () async {
                      OkCancelResult result = await showOkCancelAlertDialog(
                        context: context,
                        message: S.of(context).wantToBecomeTourist,
                        okLabel: S.of(context).yes,
                        barrierDismissible: false,
                        cancelLabel: S.of(context).cancel,
                        useActionSheetForCupertino: true,
                      );
                      if (result == OkCancelResult.ok) {
                        bool havePred =
                            await context.read<AuthProvider>().haveOffers();
                        if (havePred) {
                          EasyLoading.showError(S.of(context).errorOccured);
                        } else {
                          EasyLoading.show(status: S.of(context).loading);
                          bool temp = await context
                              .read<AuthProvider>()
                              .becomeTourist();
                          if (temp) {
                            await context.read<AuthProvider>().updateUser();
                            EasyLoading.showSuccess(
                                S.of(context).youSuccessTourist);
                          } else {
                            EasyLoading.showError(
                                S.of(context).errorOccuredTryAgain);
                          }
                        }
                      }
                    },
                    child: Text(
                      S.of(context).wantToBecomeTourist,
                      style: TextStyle(
                          color: PRIMARY,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.5),
                    )),
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }

  Widget paragraphTile({required String number, required String text}) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: GREEN_GRAY,
          radius: 12,
          child: Text(
            number,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                color: GREEN_GRAY, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget paragraph(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: GREEN_GRAY, fontSize: 16, fontWeight: FontWeight.w400),
    );
  }

  Widget uploadDocuments() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size.fromHeight(double.infinity),
        ),
        onPressed: () async {
          if (Platform.isAndroid) {
            final ImagePicker _picker = ImagePicker();
            List<XFile>? images = await _picker.pickMultiImage();
            if (images != null) {
              for (int i = 0; i < images.length; i++) {
                setState(() {
                  filePaths.add(images[i].path);
                  files.add(File(images[i].path));
                });
              }
            } else {}
          } else {
            final ImagePicker _picker = ImagePicker();
            XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                filePaths.add(image.path);
                files.add(File(image.path));
              });
            } else {}
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Text(
            S.of(context).uploadDoc,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget customGridViewBuilder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          S.of(context).selectedPics,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
        ),
        SizedBox(
          height: 15,
        ),
        GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: files.length,
            itemBuilder: (ctx, i) {
              return Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: RED,
                  ),
                  onPressed: () {
                    setState(() {
                      files.removeAt(i);
                      filePaths.removeAt(i);
                    });
                  },
                ),
                height: 200,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(
                      File(files[i].path),
                    ),
                  ),
                ),
              );
            }),
        SizedBox(
          height: 5,
        ),
        addMorePhoto(),
        SizedBox(
          height: 20,
        ),
        sendToVerifyButton(),
      ],
    );
  }

  Widget addMorePhoto() {
    return TextButton(
        onPressed: () async {
          if (Platform.isAndroid) {
            final ImagePicker _picker = ImagePicker();
            List<XFile>? images = await _picker.pickMultiImage();
            for (int i = 0; i < images!.length; i++) {
              setState(() {
                filePaths.add(images[i].path);
                files.add(File(images[i].path));
              });
            }
          } else {
            final ImagePicker _picker = ImagePicker();
            XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              setState(() {
                filePaths.add(image.path);
                files.add(File(image.path));
              });
            }
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt,
              color: PRIMARY,
            ),
            Text(
              "   " + S.of(context).addMorePics,
              style: TextStyle(fontWeight: FontWeight.bold, color: PRIMARY),
            )
          ],
        ));
  }

  Widget sendToVerifyButton() {
    return RoundedLoadingButton(
      width: double.maxFinite,
      onPressed: () async {
        controller.start();

        if (files.length == 2 || files.length > 2) {
          int data = await context.read<AuthProvider>().verifyUser(filePaths);
          if (data == 200) {
            await context.read<AuthProvider>().updateUser();
            controller.reset();

            Navigator.pop(context);
            controller.success();
            EasyLoading.showSuccess(S.of(context).docSentTag,
                duration: Duration(seconds: 4));
          } else if (data == 999) {
            controller.reset();
            print('lol no photo selected');
          } else {
            controller.error();
            controller.reset();
            EasyLoading.showError(
              S.of(context).errorOccured,
              duration: Duration(seconds: 4),
            );
          }
          setState(() {
            files = [];
            filePaths = [];
          });
        } else {
          controller.reset();
          EasyLoading.showInfo(S.of(context).min4files);
        }
      },
      child: Text(
        S.of(context).sendToVerify,
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
      ),
      color: PRIMARY,
      height: 60,
      borderRadius: 10,
      controller: controller,
    );
  }

  Widget sendSocialLinkToVerify() {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80),
      child: RoundedLoadingButton(
        resetDuration: Duration(milliseconds: 1500),
        successColor: PRIMARY,
        resetAfterDuration: resetAfterDuration,
        onPressed: () async {
          controller2.start();
          if (formKey.currentState!.validate()) {
            bool res = await context
                .read<AuthProvider>()
                .sendSocialLink(socialNetworkController.text);
            if (res) {
              setState(() {
                resetAfterDuration = false;
              });
              controller2.success();
              EasyLoading.showSuccess(S.of(context).succesfullySent,
                  duration: Duration(seconds: 2));
            } else {
              controller2.error();
              //await Future.delayed(Duration(milliseconds: 500));

              EasyLoading.showError(S.of(context).somethingWentWrong,
                  duration: Duration(seconds: 2));
            }
          } else {
            controller2.error();
            //await Future.delayed(Duration(milliseconds: 500));

          }
        },
        child: Text(
          S.of(context).sendToPublish,
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        color: PRIMARY,
        height: 60,
        borderRadius: 10,
        controller: controller2,
      ),
    );
  }
}
