import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/register_provider.dart';
import 'package:vip_tourist/logic/utility/validators.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';
import 'package:vip_tourist/presentation/screens/terms_user_screen.dart';

import '../../../logic/providers/login_provider.dart';
import '../../../logic/utility/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late bool isShown;
  bool isTourist = false;
  late bool getPromo;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late RoundedLoadingButtonController controller2;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  @override
  void initState() {
    // TODO: implement initState
    getPromo = false;
    isShown = true;
    controller2 = RoundedLoadingButtonController();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final data = S.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).signUp,
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
            child: Column(children: [
              SizedBox(
                height: 5,
              ),
              Text(
                data.chooseAccountType,
                style: TextStyle(fontSize: 18, color: GREEN_GRAY),
              ),
              SizedBox(
                height: 30,
              ),
              accountSelection(context),
              SizedBox(
                height: 20,
              ),
              emailField(context, data),
              SizedBox(
                height: 20,
              ),
              passwordField(context, data),
              SizedBox(
                height: 20,
              ),
              getPromotions(context),
              SizedBox(
                height: 6.5,
              ),
              privacyPolicy(context),
              SizedBox(
                height: 27,
              ),
              signupButton(context, locale),
              SizedBox(
                height: 10,
              ),
              useTerms(context),
              SizedBox(
                height: 6.5,
              ),
            ]),
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
            key: const Key('signUpForm_emailInput_textField'),
            onChanged: (value) => context
                .read<RegisterProvider>()
                .changeEmailRegisterField(value),
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
            onChanged: (value) => context
                .read<RegisterProvider>()
                .changePasswordRegisterField(value),
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

  Widget accountSelection(BuildContext ctx) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isTourist = true;
            });
          },
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.8, color: isTourist ? PRIMARY : Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/newTourist.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  S.of(context).tourist,
                  style: TextStyle(
                      fontSize: 18,
                      color: isTourist ? PRIMARY : Colors.grey,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(
              () {
                isTourist = false;
              },
            );
          },
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 1.8, color: isTourist ? Colors.grey : PRIMARY),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/newGuide.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(S.of(context).guide,
                    style: TextStyle(
                        fontSize: 18,
                        color: isTourist ? Colors.grey : PRIMARY,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget getPromotions(BuildContext ctx) {
    return SwitchListTile(
      contentPadding: EdgeInsets.all(0.1),
      value: getPromo,
      activeColor: PRIMARY,
      onChanged: (value) {
        setState(() {
          getPromo = !getPromo;
        });
      },
      title: Text(
        S.of(context).receiveTips,
        style: TextStyle(
            color: GREEN_BLACK, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget privacyPolicy(BuildContext ctx) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: S.of(context).weSendText,
            style: TextStyle(color: GREEN_GRAY, fontSize: 13),
          ),
          TextSpan(
              text: " " + S.of(context).privacyPolicy,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  pushNewScreen(context,
                      screen: PolicyPrivacyScreen(), withNavBar: false);
                },
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget signupButton(BuildContext ctx, Locale locale) {
    String val;
    return RoundedLoadingButton(
      width: double.maxFinite,
      color: PRIMARY,
      borderRadius: 10,
      height: 60,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          controller2.start();
          val = await context
              .read<RegisterProvider>()
              .signUp(getPromo, isTourist, locale);
          controller2.reset();
          if (val == 'weak-password') {
            await EasyLoading.showError(
              S.of(context).weakPassword,
              duration: Duration(seconds: 3),
            );
          } else if (val == 'email-already-in-use') {
            await EasyLoading.showError(
              S.of(context).emailAlreadyInUse,
              duration: Duration(seconds: 3),
            );
          } else if (val == 'error') {
            await EasyLoading.showError(
              S.of(context).somethingWentWrong,
              duration: Duration(seconds: 3),
            );
          } else {
            Navigator.pop(context);
            EasyLoading.showSuccess(S.of(context).sendToActivate);
          }
        }
      },
      controller: controller2,
      child: Text(
        S.of(context).signUp,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  Widget useTerms(BuildContext ctx) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: S.of(context).byProceedingYouConfirm,
            style: TextStyle(color: GREEN_GRAY, fontSize: 13),
          ),
          TextSpan(
              text: " " + S.of(context).termsOfUse,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  pushNewScreen(context,
                      screen: TermsUseScreen(), withNavBar: false);
                },
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget haveAccount(ctx) {
    return Row(
      children: [
        SizedBox(
          width: 80,
        ),
        Text(S.of(context).alreadyHaveAccount,
            style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w600)),
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          child: Text(
            S.of(context).logIn,
            style: TextStyle(
                color: Colors.blue[600],
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
