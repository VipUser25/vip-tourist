import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/login_provider.dart';
import 'package:vip_tourist/logic/utility/validators.dart';
import 'package:vip_tourist/presentation/screens/auth_screens/signup_screen.dart';
import 'package:vip_tourist/presentation/screens/auth_screens/forgot_password_screen.dart';

import '../../../logic/utility/constants.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool isShown = true;
  late RoundedLoadingButtonController controller;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  @override
  void initState() {
    controller = RoundedLoadingButtonController();

    emailController = TextEditingController(
        text: context.read<LoginProvider>().emailSuggestion);

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
          S.of(context).logIn,
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
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                emailField(context, data),
                SizedBox(
                  height: 20,
                ),
                passwordField(context, data),
                SizedBox(
                  height: 30,
                ),
                loginButton(context),
                SizedBox(
                  height: 15,
                ),
                noAccountRow()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailField(BuildContext ctx, S data) {
    return Column(
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
                  fontSize: 16, fontWeight: FontWeight.bold, color: GREEN_GRAY),
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Theme(
          data: Theme.of(ctx).copyWith(
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            autofocus: false,
            enableSuggestions: true,
            enableIMEPersonalizedLearning: true,
            controller: emailController,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            onChanged: (value) =>
                context.read<LoginProvider>().changeEmailField(value),
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
      ],
    );
  }

  Widget passwordField(BuildContext ctx, S data) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.lock,
              color: GRAY,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).password,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: GREEN_GRAY),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                pushNewScreen(context, screen: ForgotPasswordScreen());
              },
              child: Text(
                S.of(context).forgotPassword,
                style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: PRIMARY),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Theme(
          data: Theme.of(ctx).copyWith(
            primaryColor: Colors.black,
          ),
          child: TextFormField(
            onChanged: (value) =>
                context.read<LoginProvider>().changePasswordField(value),
            autofocus: false,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            validator: Validator.passwordValidator(data),
            decoration: InputDecoration(
              hintText: S.of(context).enterPassword,
              hintStyle: TextStyle(fontSize: 16, color: GRAY),
              suffixIcon: IconButton(
                icon: Icon(
                  isShown ? Icons.remove_red_eye : Icons.security,
                  color: PRIMARY,
                ),
                onPressed: () {
                  setState(() {
                    isShown = !isShown;
                  });
                },
              ),
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
            keyboardType: TextInputType.visiblePassword,
            obscureText: isShown,
          ),
        ),
      ],
    );
  }

  Widget forgotButton() {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const ForgotPasswordScreen(),
          ),
        );
      },
      child: Text(
        S.of(context).forgotPassword,
        style: TextStyle(
            color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget loginButton(BuildContext ctx) {
    String val;
    return RoundedLoadingButton(
      width: double.maxFinite,
      height: 60,
      color: PRIMARY,
      borderRadius: 10,
      onPressed: () async {
        controller.start();
        if (formKey.currentState!.validate()) {
          print("SRABATYVAET??");

          val = await context.read<LoginProvider>().logIn();

          if (val == 'user-not-found') {
            controller.error();
            controller.reset();
            showOkAlertDialog(
                context: context,
                message: S.of(context).userIsNotFound,
                barrierDismissible: false);
          } else if (val == 'wrong-password') {
            controller.error();
            controller.reset();
            showOkAlertDialog(
                context: context,
                message: S.of(context).wrongPasswordProvided,
                barrierDismissible: false);
          } else if (val == 'email-not-verified') {
            controller.error();
            controller.reset();
            showOkAlertDialog(
                context: context,
                message: S.of(context).accountIsNotVerified,
                barrierDismissible: false);
          } else {
            await context.read<AuthProvider>().updateUser();
            await context.read<AuthProvider>().refreshFcm();
            controller.success();
            Navigator.pop(context);
            Navigator.pop(context);
          }
        } else {
          controller.reset();
          return;
        }
      },
      controller: controller,
      child: Text(
        S.of(context).logIn,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  Widget noAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Text(S.of(context).dontHaveAccount,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const SignUpScreen(),
                  ),
                );
              },
              child: Text(
                S.of(context).signUp,
                style: TextStyle(
                    color: PRIMARY, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
