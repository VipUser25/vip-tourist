import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/home_cities_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/login_provider.dart';
import 'package:vip_tourist/logic/providers/notification_provider.dart';
import 'package:vip_tourist/logic/providers/offer_edit_provider.dart';
import 'package:vip_tourist/logic/providers/payment_cards_provider.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:vip_tourist/logic/providers/reset_password_provider.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';
import 'package:vip_tourist/logic/providers/tour_addition_provider.dart';
import 'package:vip_tourist/logic/providers/user_profile_look_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/logic/utility/temp_currency.dart';
import 'package:vip_tourist/presentation/screens/first_intro_screen.dart';
import 'package:vip_tourist/presentation/screens/splash_screen.dart';
import 'generated/l10n.dart';
import 'logic/providers/cool_stepper_provider.dart';
import 'logic/providers/detail_tour_provider.dart';
import 'logic/providers/filter_tour_provider.dart';
import 'logic/providers/register_provider.dart';
import 'logic/providers/weather_provider.dart';
import 'presentation/screens/bottom_navigation_bart.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart';

//app version 1.0.5+6 == (27.06.22 ver

//a few bug fixes left
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel", "High Importance Notifications",
    description: "This channel is userd for important notifications.",
    importance: Importance.high,
    playSound: true);
final ThemeData nunito = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: PRIMARY,
      textStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      fixedSize: const Size.fromWidth(double.maxFinite),
      padding: const EdgeInsets.only(
        top: 19,
        bottom: 19,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    hintStyle: TextStyle(color: GRAY),
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: GRAY,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: GRAY,
        width: 1,
        style: BorderStyle.solid,
      ),
    ),
  ),
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagesBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("NOTIFICATION BELLOW");
  print(message.notification!.title);
  print(message.notification!.body);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagesBackgroundHandler);
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
  }

  await flutterLocalNotificationsPlugin //this one
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  CurrencyProvider currencyProvider = CurrencyProvider();
  try {
    await currencyProvider.loadCurrencies();
  } catch (e) {
    currencyProvider.setEuro(EURO);

    currencyProvider.setDirham(DIRHAM);

    currencyProvider.setRouble(ROUBLE);

    currencyProvider.setBaht(BAHT);

    currencyProvider.setLira(LIRA);

    currencyProvider.setLira(GBP);
  }

  await currencyProvider.loadCurrency();
  await currencyProvider.loadFirstTime();
  AuthProvider authProvider = AuthProvider();
  LocalizationProvider localizationProvider = LocalizationProvider();
  CoolStepperProvider coolStepperProvider = CoolStepperProvider();
  TourAdditionProvider tourAdditionProvider = TourAdditionProvider();
  await tourAdditionProvider.loadSaved();
  await coolStepperProvider.loadDataFromLocale();

  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();

  Stripe.publishableKey =
      "pk_live_51LTLGFHjKdPqo5Jrb7RHMQanKvdmYb8eO8nDpJxN5zT0CuLrP003yM6zD6f9tVRR27XMAwpAsmoiQQbXDSFZMVtw004lw7RP1P";

  runApp(
    MyApp(
      authProvider: authProvider,
      currencyProvider: currencyProvider,
      localizationProvider: localizationProvider,
      coolStepperProvider: coolStepperProvider,
      tourAdditionProvider: tourAdditionProvider,
      initialLink: initialLink,
    ),
  );
}

//
class MyApp extends StatefulWidget {
  final AuthProvider authProvider;
  final LocalizationProvider localizationProvider;
  final CurrencyProvider currencyProvider;
  final CoolStepperProvider coolStepperProvider;
  final TourAdditionProvider tourAdditionProvider;
  final PendingDynamicLinkData? initialLink;
  const MyApp(
      {Key? key,
      required this.authProvider,
      required this.currencyProvider,
      required this.localizationProvider,
      required this.coolStepperProvider,
      required this.tourAdditionProvider,
      this.initialLink})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then(
          (value) => print("TOKEN IS " + value!),
        );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => widget.authProvider,
        ),
        ChangeNotifierProvider(
          create: (ctx) => LoginProvider(authProvider: widget.authProvider),
        ),
        ChangeNotifierProvider(
          create: (ctx) => RegisterProvider(authProvider: widget.authProvider),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OfferEditProvider(authData: widget.authProvider),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ResetPasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CurrencyProvider(),
        ),
        ListenableProvider(
          create: (ctx) => HomeScreenTourProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DetailTourProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FilterTourProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PurchaseOrderProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WishlistProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => widget.tourAdditionProvider,
        ),
        ChangeNotifierProvider(
          create: (ctx) => widget.currencyProvider,
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProfileLookProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => NotificationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WeatherProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => widget.coolStepperProvider,
        ),
        ChangeNotifierProvider(
          create: (ctx) => HomeCitiesProvider(
              localizationProvider: widget.localizationProvider),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PaymentCardsProvider(authData: widget.authProvider),
        ),
      ],
      child: ChangeNotifierProvider(
        create: (BuildContext context) => widget.localizationProvider,
        child: Builder(
          builder: (context) => MaterialApp(
              builder: EasyLoading.init(),
              theme: nunito,
              locale: Provider.of<LocalizationProvider>(context, listen: true)
                  .currentLocale,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                Locale('en', ''), // English, no country code
                Locale('ru', ''), // Russian, no country code
                Locale('de', ''), // German, no country code
                Locale('th', ''), // Thai, no country code
                Locale('tr', ''), // Turkish, no country code
                Locale('fr', ''), // French, no country code
                Locale('ar', ''), // Arabic, no country code
                Locale('es', ''), // Spanish, no country code
                Locale('it', ''), // Italian, no country code
              ],
              debugShowCheckedModeBanner: false,
              home:
                  // widget.currencyProvider.isFirstTime!
                  //     ?
                  FirstIntroScreen(
                dynamicLink: widget.initialLink,
              )
              // : BottomNavigationBart(
              //     authData: widget.authProvider,
              //     dynamicLink: widget.initialLink,
              //   ),
              ),
        ),
      ),
    );
  }

  // Widget getScreen() {
  //   if (widget.currencyProvider.isFirstTime!) {
  //     return AnimatedSplashScreen(
  //         splash: Icons.home, nextScreen: FirstIntroScreen());
  //   } else {
  //     return AnimatedSplashScreen(
  //       splash: Icons.home,
  //       nextScreen: BottomNavigationBart(
  //         authData: widget.authProvider,
  //       ),
  //     );
  //   }
  // }
}
