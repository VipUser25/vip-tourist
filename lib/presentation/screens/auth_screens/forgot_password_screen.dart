import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/reset_password_provider.dart';
import 'package:vip_tourist/logic/utility/validators.dart';
import 'package:provider/provider.dart';

import '../../../logic/providers/login_provider.dart';
import '../../../logic/utility/constants.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  @override
  void initState() {
    // TODO: implement initState
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).forgotPassword,
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
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.mail,
                  color: GRAY,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "E-mail",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GREEN_GRAY),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.black,
              ),
              child: TextFormField(
                autofocus: false,
                enableSuggestions: true,
                enableIMEPersonalizedLearning: true,
                controller: emailController,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                onChanged: (value) => context
                    .read<ResetPasswordProvider>()
                    .changeEmailField(value),
                validator: Validator.emailvalidator(data),
                decoration: InputDecoration(
                  hintText: S.of(context).enterEmail,
                  hintStyle: TextStyle(fontSize: 16, color: GRAY),
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
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              S.of(context).sendLinkToVerify,
              style: TextStyle(color: GREEN_GRAY, fontSize: 16),
            ),
            SizedBox(
              height: 17,
            ),
            ElevatedButton(
              onPressed: () async {
                String val;
                if (formKey.currentState!.validate()) {
                  val = await context
                      .read<ResetPasswordProvider>()
                      .resetPassword();

                  if (val == 'error') {
                    showOkAlertDialog(
                        context: context,
                        message: data.errorOccured,
                        barrierDismissible: false);
                  } else {
                    Navigator.pop(context);
                    showOkAlertDialog(
                        context: context,
                        message: S.of(context).linkSendToChange,
                        barrierDismissible: false);
                  }
                }
              },
              child: Text(
                data.resetPassword,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
