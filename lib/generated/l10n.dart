// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Tomorrow`
  String get tommorow {
    return Intl.message(
      'Tomorrow',
      name: 'tommorow',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name of the city or tour`
  String get enterCity {
    return Intl.message(
      'Enter the name of the city or tour',
      name: 'enterCity',
      desc: '',
      args: [],
    );
  }

  /// `Explore on the map`
  String get discover {
    return Intl.message(
      'Explore on the map',
      name: 'discover',
      desc: '',
      args: [],
    );
  }

  /// `All tours and tickets`
  String get allTours {
    return Intl.message(
      'All tours and tickets',
      name: 'allTours',
      desc: '',
      args: [],
    );
  }

  /// `Favourites`
  String get wishlist {
    return Intl.message(
      'Favourites',
      name: 'wishlist',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get booking {
    return Intl.message(
      'Orders',
      name: 'booking',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur`
  String get lorem {
    return Intl.message(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur',
      name: 'lorem',
      desc: '',
      args: [],
    );
  }

  /// `Where would you like to go?`
  String get nextExp {
    return Intl.message(
      'Where would you like to go?',
      name: 'nextExp',
      desc: '',
      args: [],
    );
  }

  /// `Choose a tour`
  String get findThings {
    return Intl.message(
      'Choose a tour',
      name: 'findThings',
      desc: '',
      args: [],
    );
  }

  /// `I can't find a booking ticket`
  String get cantFind {
    return Intl.message(
      'I can\'t find a booking ticket',
      name: 'cantFind',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notification {
    return Intl.message(
      'Notifications',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Support Service`
  String get support {
    return Intl.message(
      'Support Service',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `About the app`
  String get aboutApp {
    return Intl.message(
      'About the app',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Help Center`
  String get helpCenter {
    return Intl.message(
      'Help Center',
      name: 'helpCenter',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get chatWithUs {
    return Intl.message(
      'Contact us',
      name: 'chatWithUs',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get feedback {
    return Intl.message(
      'Reviews',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Rate the app`
  String get rateApp {
    return Intl.message(
      'Rate the app',
      name: 'rateApp',
      desc: '',
      args: [],
    );
  }

  /// `Leave feedback`
  String get leaveFeedback {
    return Intl.message(
      'Leave feedback',
      name: 'leaveFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Rules`
  String get legal {
    return Intl.message(
      'Rules',
      name: 'legal',
      desc: '',
      args: [],
    );
  }

  /// `Operating rules`
  String get termsOfUse {
    return Intl.message(
      'Operating rules',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Go out`
  String get logout {
    return Intl.message(
      'Go out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found`
  String get noSuggestions {
    return Intl.message(
      'Nothing found',
      name: 'noSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email format`
  String get invalidEmailForm {
    return Intl.message(
      'Invalid Email format',
      name: 'invalidEmailForm',
      desc: '',
      args: [],
    );
  }

  /// `Required field *`
  String get required {
    return Intl.message(
      'Required field *',
      name: 'required',
      desc: '',
      args: [],
    );
  }

  /// `Required field * Password`
  String get passwordIsRequired {
    return Intl.message(
      'Required field * Password',
      name: 'passwordIsRequired',
      desc: '',
      args: [],
    );
  }

  /// `The password must contain at least 8 characters`
  String get password8symbolsLong {
    return Intl.message(
      'The password must contain at least 8 characters',
      name: 'password8symbolsLong',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get logIn {
    return Intl.message(
      'Enter',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `User not found`
  String get userIsNotFound {
    return Intl.message(
      'User not found',
      name: 'userIsNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Invalid account password`
  String get wrongPasswordProvided {
    return Intl.message(
      'Invalid account password',
      name: 'wrongPasswordProvided',
      desc: '',
      args: [],
    );
  }

  /// `The account is not activated. Check your email`
  String get accountIsNotVerified {
    return Intl.message(
      'The account is not activated. Check your email',
      name: 'accountIsNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `No account? `
  String get dontHaveAccount {
    return Intl.message(
      'No account? ',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get signUp {
    return Intl.message(
      'Register',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we will send you a link to restore your password`
  String get sendLinkToVerify {
    return Intl.message(
      'Enter your email address and we will send you a link to restore your password',
      name: 'sendLinkToVerify',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred`
  String get errorOccured {
    return Intl.message(
      'An error occurred',
      name: 'errorOccured',
      desc: '',
      args: [],
    );
  }

  /// `A link to change the password has been sent to your email`
  String get linkSendToChange {
    return Intl.message(
      'A link to change the password has been sent to your email',
      name: 'linkSendToChange',
      desc: '',
      args: [],
    );
  }

  /// `Restore password`
  String get resetPassword {
    return Intl.message(
      'Restore password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Travel around the world, book tours and enjoy the moment!`
  String get tagOne {
    return Intl.message(
      'Travel around the world, book tours and enjoy the moment!',
      name: 'tagOne',
      desc: '',
      args: [],
    );
  }

  /// `Select the account type`
  String get chooseAccountType {
    return Intl.message(
      'Select the account type',
      name: 'chooseAccountType',
      desc: '',
      args: [],
    );
  }

  /// `Guide`
  String get guide {
    return Intl.message(
      'Guide',
      name: 'guide',
      desc: '',
      args: [],
    );
  }

  /// `Tourist`
  String get tourist {
    return Intl.message(
      'Tourist',
      name: 'tourist',
      desc: '',
      args: [],
    );
  }

  /// `I want to be notified about promotions`
  String get receiveTips {
    return Intl.message(
      'I want to be notified about promotions',
      name: 'receiveTips',
      desc: '',
      args: [],
    );
  }

  /// `We will send special offers and promotions to your email. You can unsubscribe from the mailing list at any time. You can find out more in the  privacy policy.`
  String get weSendText {
    return Intl.message(
      'We will send special offers and promotions to your email. You can unsubscribe from the mailing list at any time. You can find out more in the  privacy policy.',
      name: 'weSendText',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Unreliable password`
  String get weakPassword {
    return Intl.message(
      'Unreliable password',
      name: 'weakPassword',
      desc: '',
      args: [],
    );
  }

  /// `An account with such an email already exists`
  String get emailAlreadyInUse {
    return Intl.message(
      'An account with such an email already exists',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, try again`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong, try again',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `We have sent you an email with a link for account activations`
  String get sendToActivate {
    return Intl.message(
      'We have sent you an email with a link for account activations',
      name: 'sendToActivate',
      desc: '',
      args: [],
    );
  }

  /// `By continuing, you agree to our terms of the document`
  String get byProceedingYouConfirm {
    return Intl.message(
      'By continuing, you agree to our terms of the document',
      name: 'byProceedingYouConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Tour`
  String get tour {
    return Intl.message(
      'Tour',
      name: 'tour',
      desc: '',
      args: [],
    );
  }

  /// `Owner's name`
  String get ownerName {
    return Intl.message(
      'Owner\'s name',
      name: 'ownerName',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Ticket ID`
  String get bookingID {
    return Intl.message(
      'Ticket ID',
      name: 'bookingID',
      desc: '',
      args: [],
    );
  }

  /// `Number of people`
  String get maxPpl {
    return Intl.message(
      'Number of people',
      name: 'maxPpl',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Valid`
  String get valid {
    return Intl.message(
      'Valid',
      name: 'valid',
      desc: '',
      args: [],
    );
  }

  /// `Not valid`
  String get invalid {
    return Intl.message(
      'Not valid',
      name: 'invalid',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get tapToOpen {
    return Intl.message(
      'Open',
      name: 'tapToOpen',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message(
      'Owner',
      name: 'owner',
      desc: '',
      args: [],
    );
  }

  /// `Ticket for`
  String get ticketFor {
    return Intl.message(
      'Ticket for',
      name: 'ticketFor',
      desc: '',
      args: [],
    );
  }

  /// `Adult`
  String get adult {
    return Intl.message(
      'Adult',
      name: 'adult',
      desc: '',
      args: [],
    );
  }

  /// `Kid`
  String get child {
    return Intl.message(
      'Kid',
      name: 'child',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personalInfo {
    return Intl.message(
      'Personal information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name`
  String get enterYourName {
    return Intl.message(
      'Enter your name',
      name: 'enterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number (with WhatsApp or Telegram)`
  String get mobile {
    return Intl.message(
      'Mobile number (with WhatsApp or Telegram)',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mobile number`
  String get enterMobile {
    return Intl.message(
      'Enter your mobile number',
      name: 'enterMobile',
      desc: '',
      args: [],
    );
  }

  /// `Verification status`
  String get verStatus {
    return Intl.message(
      'Verification status',
      name: 'verStatus',
      desc: '',
      args: [],
    );
  }

  /// `Verified`
  String get verified {
    return Intl.message(
      'Verified',
      name: 'verified',
      desc: '',
      args: [],
    );
  }

  /// `Not verified`
  String get unverified {
    return Intl.message(
      'Not verified',
      name: 'unverified',
      desc: '',
      args: [],
    );
  }

  /// `Become a guide`
  String get becomeGuide {
    return Intl.message(
      'Become a guide',
      name: 'becomeGuide',
      desc: '',
      args: [],
    );
  }

  /// `Nameless`
  String get unnamed {
    return Intl.message(
      'Nameless',
      name: 'unnamed',
      desc: '',
      args: [],
    );
  }

  /// `Choose a language`
  String get choseLang {
    return Intl.message(
      'Choose a language',
      name: 'choseLang',
      desc: '',
      args: [],
    );
  }

  /// `Log in or register`
  String get logOrSignUp {
    return Intl.message(
      'Log in or register',
      name: 'logOrSignUp',
      desc: '',
      args: [],
    );
  }

  /// `To become a guide of a new tour or a supplier of an existing one, you need to download the following documents:`
  String get guideBecomeDocText {
    return Intl.message(
      'To become a guide of a new tour or a supplier of an existing one, you need to download the following documents:',
      name: 'guideBecomeDocText',
      desc: '',
      args: [],
    );
  }

  /// `Your country's ID card, both sides`
  String get guideBecomeDocOne {
    return Intl.message(
      'Your country\'s ID card, both sides',
      name: 'guideBecomeDocOne',
      desc: '',
      args: [],
    );
  }

  /// `Your selfie from your tour`
  String get guideBecomeDocTwo {
    return Intl.message(
      'Your selfie from your tour',
      name: 'guideBecomeDocTwo',
      desc: '',
      args: [],
    );
  }

  /// `Document confirming the address`
  String get guideBecomeDocThree {
    return Intl.message(
      'Document confirming the address',
      name: 'guideBecomeDocThree',
      desc: '',
      args: [],
    );
  }

  /// `Upload documents`
  String get uploadDoc {
    return Intl.message(
      'Upload documents',
      name: 'uploadDoc',
      desc: '',
      args: [],
    );
  }

  /// `Selected photos`
  String get selectedPics {
    return Intl.message(
      'Selected photos',
      name: 'selectedPics',
      desc: '',
      args: [],
    );
  }

  /// `Add more photos`
  String get addMorePics {
    return Intl.message(
      'Add more photos',
      name: 'addMorePics',
      desc: '',
      args: [],
    );
  }

  /// `The documents have been sent for verification, we will soon send a response to your email. `
  String get docsSentSuccess {
    return Intl.message(
      'The documents have been sent for verification, we will soon send a response to your email. ',
      name: 'docsSentSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Send for verification`
  String get sendToVerify {
    return Intl.message(
      'Send for verification',
      name: 'sendToVerify',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Study`
  String get explore {
    return Intl.message(
      'Study',
      name: 'explore',
      desc: '',
      args: [],
    );
  }

  /// `Buy tickets from`
  String get bookNowFrom {
    return Intl.message(
      'Buy tickets from',
      name: 'bookNowFrom',
      desc: '',
      args: [],
    );
  }

  /// `Meeting place`
  String get meetingPoint {
    return Intl.message(
      'Meeting place',
      name: 'meetingPoint',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Copy Address`
  String get getDirect {
    return Intl.message(
      'Copy Address',
      name: 'getDirect',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Full description`
  String get fullDesc {
    return Intl.message(
      'Full description',
      name: 'fullDesc',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get durationAndValid {
    return Intl.message(
      'Duration',
      name: 'durationAndValid',
      desc: '',
      args: [],
    );
  }

  /// `Tour guide`
  String get liveTour {
    return Intl.message(
      'Tour guide',
      name: 'liveTour',
      desc: '',
      args: [],
    );
  }

  /// `Date and time`
  String get dateAndTime {
    return Intl.message(
      'Date and time',
      name: 'dateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Price per adult`
  String get adultPrice {
    return Intl.message(
      'Price per adult',
      name: 'adultPrice',
      desc: '',
      args: [],
    );
  }

  /// `Price per child`
  String get childPrice {
    return Intl.message(
      'Price per child',
      name: 'childPrice',
      desc: '',
      args: [],
    );
  }

  /// `Included`
  String get whatIncluded {
    return Intl.message(
      'Included',
      name: 'whatIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Not included`
  String get whatNotIncluded {
    return Intl.message(
      'Not included',
      name: 'whatNotIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Prepare in advance (Optional)`
  String get prerequisites {
    return Intl.message(
      'Prepare in advance (Optional)',
      name: 'prerequisites',
      desc: '',
      args: [],
    );
  }

  /// `Forbidden`
  String get prohibs {
    return Intl.message(
      'Forbidden',
      name: 'prohibs',
      desc: '',
      args: [],
    );
  }

  /// `On a note`
  String get note {
    return Intl.message(
      'On a note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `Cancellation Policy`
  String get cancellationPolicy {
    return Intl.message(
      'Cancellation Policy',
      name: 'cancellationPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Precautions for Covid-19`
  String get covidPrecautions {
    return Intl.message(
      'Precautions for Covid-19',
      name: 'covidPrecautions',
      desc: '',
      args: [],
    );
  }

  /// `All surfaces touched by customers are cleaned regularly`
  String get covidOne {
    return Intl.message(
      'All surfaces touched by customers are cleaned regularly',
      name: 'covidOne',
      desc: '',
      args: [],
    );
  }

  /// `you must maintain a social distance`
  String get covidTwo {
    return Intl.message(
      'you must maintain a social distance',
      name: 'covidTwo',
      desc: '',
      args: [],
    );
  }

  /// `The number of participants of the tour is limited in order to avoid the accumulation of a large number of people`
  String get covidThree {
    return Intl.message(
      'The number of participants of the tour is limited in order to avoid the accumulation of a large number of people',
      name: 'covidThree',
      desc: '',
      args: [],
    );
  }

  /// `You need to wear a protective mask that you brought with you`
  String get covidFour {
    return Intl.message(
      'You need to wear a protective mask that you brought with you',
      name: 'covidFour',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get review {
    return Intl.message(
      'Feedback',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Successfully`
  String get success {
    return Intl.message(
      'Successfully',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Successfully`
  String get successfull {
    return Intl.message(
      'Successfully',
      name: 'successfull',
      desc: '',
      args: [],
    );
  }

  /// `Not successful`
  String get unsuccess {
    return Intl.message(
      'Not successful',
      name: 'unsuccess',
      desc: '',
      args: [],
    );
  }

  /// `Not successful`
  String get unsuccessfull {
    return Intl.message(
      'Not successful',
      name: 'unsuccessfull',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `Activity selection`
  String get activity {
    return Intl.message(
      'Activity selection',
      name: 'activity',
      desc: '',
      args: [],
    );
  }

  /// `Variants`
  String get options {
    return Intl.message(
      'Variants',
      name: 'options',
      desc: '',
      args: [],
    );
  }

  /// `Number of tickets`
  String get participants {
    return Intl.message(
      'Number of tickets',
      name: 'participants',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Buy a ticket for`
  String get bookNowFor {
    return Intl.message(
      'Buy a ticket for',
      name: 'bookNowFor',
      desc: '',
      args: [],
    );
  }

  /// `About the tour`
  String get aboutActiv {
    return Intl.message(
      'About the tour',
      name: 'aboutActiv',
      desc: '',
      args: [],
    );
  }

  /// `Tourist reviews`
  String get customerReview {
    return Intl.message(
      'Tourist reviews',
      name: 'customerReview',
      desc: '',
      args: [],
    );
  }

  /// `No reviews`
  String get noReviews {
    return Intl.message(
      'No reviews',
      name: 'noReviews',
      desc: '',
      args: [],
    );
  }

  /// `Verified user`
  String get verifiedCustomers {
    return Intl.message(
      'Verified user',
      name: 'verifiedCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Evaluation`
  String get rating {
    return Intl.message(
      'Evaluation',
      name: 'rating',
      desc: '',
      args: [],
    );
  }

  /// `Other reviews`
  String get seeAllReviews {
    return Intl.message(
      'Other reviews',
      name: 'seeAllReviews',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get desc {
    return Intl.message(
      'Description',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Duration`
  String get duration {
    return Intl.message(
      'Duration',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Add a tour`
  String get addTour {
    return Intl.message(
      'Add a tour',
      name: 'addTour',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Guided tour`
  String get guidedTour {
    return Intl.message(
      'Guided tour',
      name: 'guidedTour',
      desc: '',
      args: [],
    );
  }

  /// `Private tour`
  String get privateTour {
    return Intl.message(
      'Private tour',
      name: 'privateTour',
      desc: '',
      args: [],
    );
  }

  /// `One-day tour`
  String get oneDay {
    return Intl.message(
      'One-day tour',
      name: 'oneDay',
      desc: '',
      args: [],
    );
  }

  /// `Nature`
  String get natuer {
    return Intl.message(
      'Nature',
      name: 'natuer',
      desc: '',
      args: [],
    );
  }

  /// `Entrance ticket`
  String get ticketMustHave {
    return Intl.message(
      'Entrance ticket',
      name: 'ticketMustHave',
      desc: '',
      args: [],
    );
  }

  /// `Water activities`
  String get onWater {
    return Intl.message(
      'Water activities',
      name: 'onWater',
      desc: '',
      args: [],
    );
  }

  /// `Package tour (several excursions in one)`
  String get packageTour {
    return Intl.message(
      'Package tour (several excursions in one)',
      name: 'packageTour',
      desc: '',
      args: [],
    );
  }

  /// `Small groups`
  String get smallGroups {
    return Intl.message(
      'Small groups',
      name: 'smallGroups',
      desc: '',
      args: [],
    );
  }

  /// `Suitable for the disabled`
  String get invalidFriend {
    return Intl.message(
      'Suitable for the disabled',
      name: 'invalidFriend',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `With snow`
  String get worldWar {
    return Intl.message(
      'With snow',
      name: 'worldWar',
      desc: '',
      args: [],
    );
  }

  /// `Outdoors`
  String get openAir {
    return Intl.message(
      'Outdoors',
      name: 'openAir',
      desc: '',
      args: [],
    );
  }

  /// `Street art`
  String get StreetArt {
    return Intl.message(
      'Street art',
      name: 'StreetArt',
      desc: '',
      args: [],
    );
  }

  /// `Adrenaline`
  String get adrenaline {
    return Intl.message(
      'Adrenaline',
      name: 'adrenaline',
      desc: '',
      args: [],
    );
  }

  /// `Architecture`
  String get architecture {
    return Intl.message(
      'Architecture',
      name: 'architecture',
      desc: '',
      args: [],
    );
  }

  /// `Meal`
  String get food {
    return Intl.message(
      'Meal',
      name: 'food',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `For couples`
  String get forCouples {
    return Intl.message(
      'For couples',
      name: 'forCouples',
      desc: '',
      args: [],
    );
  }

  /// `For children`
  String get forKids {
    return Intl.message(
      'For children',
      name: 'forKids',
      desc: '',
      args: [],
    );
  }

  /// `Museums`
  String get museums {
    return Intl.message(
      'Museums',
      name: 'museums',
      desc: '',
      args: [],
    );
  }

  /// `A few-day tour`
  String get memorials {
    return Intl.message(
      'A few-day tour',
      name: 'memorials',
      desc: '',
      args: [],
    );
  }

  /// `Parks`
  String get parks {
    return Intl.message(
      'Parks',
      name: 'parks',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get galleries {
    return Intl.message(
      'Gallery',
      name: 'galleries',
      desc: '',
      args: [],
    );
  }

  /// `Air tour`
  String get squares {
    return Intl.message(
      'Air tour',
      name: 'squares',
      desc: '',
      args: [],
    );
  }

  /// `Theaters`
  String get theaters {
    return Intl.message(
      'Theaters',
      name: 'theaters',
      desc: '',
      args: [],
    );
  }

  /// `Night time entertainment`
  String get castles {
    return Intl.message(
      'Night time entertainment',
      name: 'castles',
      desc: '',
      args: [],
    );
  }

  /// `Towers`
  String get towers {
    return Intl.message(
      'Towers',
      name: 'towers',
      desc: '',
      args: [],
    );
  }

  /// `Airports`
  String get airpots {
    return Intl.message(
      'Airports',
      name: 'airpots',
      desc: '',
      args: [],
    );
  }

  /// `Entrance ticket`
  String get bycicle {
    return Intl.message(
      'Entrance ticket',
      name: 'bycicle',
      desc: '',
      args: [],
    );
  }

  /// `Minivan`
  String get minivan {
    return Intl.message(
      'Minivan',
      name: 'minivan',
      desc: '',
      args: [],
    );
  }

  /// `Send for publications`
  String get sendToPublish {
    return Intl.message(
      'Send for publications',
      name: 'sendToPublish',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Catalog`
  String get catalog {
    return Intl.message(
      'Catalog',
      name: 'catalog',
      desc: '',
      args: [],
    );
  }

  /// `Sort by`
  String get sortBy {
    return Intl.message(
      'Sort by',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Number of reviews`
  String get reviewCount {
    return Intl.message(
      'Number of reviews',
      name: 'reviewCount',
      desc: '',
      args: [],
    );
  }

  /// `Price increase`
  String get priceAsc {
    return Intl.message(
      'Price increase',
      name: 'priceAsc',
      desc: '',
      args: [],
    );
  }

  /// `Descending prices`
  String get priceDesc {
    return Intl.message(
      'Descending prices',
      name: 'priceDesc',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `No data available`
  String get noData {
    return Intl.message(
      'No data available',
      name: 'noData',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found`
  String get noDataFound {
    return Intl.message(
      'Nothing found',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Enter`
  String get enter {
    return Intl.message(
      'Enter',
      name: 'enter',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get select {
    return Intl.message(
      'Choose',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Enter the name of the city`
  String get enterCityName {
    return Intl.message(
      'Enter the name of the city',
      name: 'enterCityName',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Book tours, events and tickets to visit attractions anywhere in the world.`
  String get findCompare {
    return Intl.message(
      'Book tours, events and tickets to visit attractions anywhere in the world.',
      name: 'findCompare',
      desc: '',
      args: [],
    );
  }

  /// `Skip`
  String get skip {
    return Intl.message(
      'Skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get done {
    return Intl.message(
      'Complete',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Free cancellation`
  String get freeCancel {
    return Intl.message(
      'Free cancellation',
      name: 'freeCancel',
      desc: '',
      args: [],
    );
  }

  /// `Special measures are being taken to ensure safety and protect health.`
  String get covidTag {
    return Intl.message(
      'Special measures are being taken to ensure safety and protect health.',
      name: 'covidTag',
      desc: '',
      args: [],
    );
  }

  /// `Use the mobile version of the voucher or print it out`
  String get mobileTicketing {
    return Intl.message(
      'Use the mobile version of the voucher or print it out',
      name: 'mobileTicketing',
      desc: '',
      args: [],
    );
  }

  /// `Paper and mobile vouchers are accepted`
  String get vouchersMustBe {
    return Intl.message(
      'Paper and mobile vouchers are accepted',
      name: 'vouchersMustBe',
      desc: '',
      args: [],
    );
  }

  /// `Prompt confirmation`
  String get instantConf {
    return Intl.message(
      'Prompt confirmation',
      name: 'instantConf',
      desc: '',
      args: [],
    );
  }

  /// `Check`
  String get check {
    return Intl.message(
      'Check',
      name: 'check',
      desc: '',
      args: [],
    );
  }

  /// `Check availability`
  String get checkAvail {
    return Intl.message(
      'Check availability',
      name: 'checkAvail',
      desc: '',
      args: [],
    );
  }

  /// `Details and specifics`
  String get detailsAndHig {
    return Intl.message(
      'Details and specifics',
      name: 'detailsAndHig',
      desc: '',
      args: [],
    );
  }

  /// `Top`
  String get top {
    return Intl.message(
      'Top',
      name: 'top',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Cost`
  String get totalAmount {
    return Intl.message(
      'Cost',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get billing {
    return Intl.message(
      'Payment',
      name: 'billing',
      desc: '',
      args: [],
    );
  }

  /// `Route`
  String get route {
    return Intl.message(
      'Route',
      name: 'route',
      desc: '',
      args: [],
    );
  }

  /// `Hour`
  String get hour {
    return Intl.message(
      'Hour',
      name: 'hour',
      desc: '',
      args: [],
    );
  }

  /// `Hours`
  String get hours {
    return Intl.message(
      'Hours',
      name: 'hours',
      desc: '',
      args: [],
    );
  }

  /// `Sort`
  String get sort {
    return Intl.message(
      'Sort',
      name: 'sort',
      desc: '',
      args: [],
    );
  }

  /// `Public transport`
  String get pubTransport {
    return Intl.message(
      'Public transport',
      name: 'pubTransport',
      desc: '',
      args: [],
    );
  }

  /// `Limousine`
  String get limousine {
    return Intl.message(
      'Limousine',
      name: 'limousine',
      desc: '',
      args: [],
    );
  }

  /// `By car`
  String get car {
    return Intl.message(
      'By car',
      name: 'car',
      desc: '',
      args: [],
    );
  }

  /// `Cruise`
  String get cruise {
    return Intl.message(
      'Cruise',
      name: 'cruise',
      desc: '',
      args: [],
    );
  }

  /// `Choose a city`
  String get selectCity {
    return Intl.message(
      'Choose a city',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `Choose a city to start your journey!`
  String get chooseCityToStart {
    return Intl.message(
      'Choose a city to start your journey!',
      name: 'chooseCityToStart',
      desc: '',
      args: [],
    );
  }

  /// `Come to`
  String get comeAt {
    return Intl.message(
      'Come to',
      name: 'comeAt',
      desc: '',
      args: [],
    );
  }

  /// `This is your meeting place, please don't be late!`
  String get mtPointDontBe {
    return Intl.message(
      'This is your meeting place, please don\'t be late!',
      name: 'mtPointDontBe',
      desc: '',
      args: [],
    );
  }

  /// `Change the language`
  String get changeLanguage {
    return Intl.message(
      'Change the language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message(
      'Russian',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `German`
  String get german {
    return Intl.message(
      'German',
      name: 'german',
      desc: '',
      args: [],
    );
  }

  /// `Thai`
  String get thai {
    return Intl.message(
      'Thai',
      name: 'thai',
      desc: '',
      args: [],
    );
  }

  /// `Turkish`
  String get turkish {
    return Intl.message(
      'Turkish',
      name: 'turkish',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `Arabian`
  String get arabian {
    return Intl.message(
      'Arabian',
      name: 'arabian',
      desc: '',
      args: [],
    );
  }

  /// `Spanish`
  String get spanish {
    return Intl.message(
      'Spanish',
      name: 'spanish',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get italian {
    return Intl.message(
      'Italian',
      name: 'italian',
      desc: '',
      args: [],
    );
  }

  /// `Account balance`
  String get accountBalance {
    return Intl.message(
      'Account balance',
      name: 'accountBalance',
      desc: '',
      args: [],
    );
  }

  /// `Search by city`
  String get lookCity {
    return Intl.message(
      'Search by city',
      name: 'lookCity',
      desc: '',
      args: [],
    );
  }

  /// `Notification Settings`
  String get notifSettings {
    return Intl.message(
      'Notification Settings',
      name: 'notifSettings',
      desc: '',
      args: [],
    );
  }

  /// `Select tour categories`
  String get chooseCategories {
    return Intl.message(
      'Select tour categories',
      name: 'chooseCategories',
      desc: '',
      args: [],
    );
  }

  /// `Enter the duration of the tour in hours *`
  String get enterDuration {
    return Intl.message(
      'Enter the duration of the tour in hours *',
      name: 'enterDuration',
      desc: '',
      args: [],
    );
  }

  /// `4 hours`
  String get durationExample {
    return Intl.message(
      '4 hours',
      name: 'durationExample',
      desc: '',
      args: [],
    );
  }

  /// `Enter the ticket price per adult *`
  String get enterAdult {
    return Intl.message(
      'Enter the ticket price per adult *',
      name: 'enterAdult',
      desc: '',
      args: [],
    );
  }

  /// `Enter the ticket price per child (optional)`
  String get enterChild {
    return Intl.message(
      'Enter the ticket price per child (optional)',
      name: 'enterChild',
      desc: '',
      args: [],
    );
  }

  /// `Select a date`
  String get selectDate {
    return Intl.message(
      'Select a date',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  /// `Enter a note or additional information (optional)`
  String get enterNotes {
    return Intl.message(
      'Enter a note or additional information (optional)',
      name: 'enterNotes',
      desc: '',
      args: [],
    );
  }

  /// `Additional information about the tour`
  String get notesExample {
    return Intl.message(
      'Additional information about the tour',
      name: 'notesExample',
      desc: '',
      args: [],
    );
  }

  /// `Enter the meeting point (width, length, get from Google map) separated by commas *`
  String get enterLatLng {
    return Intl.message(
      'Enter the meeting point (width, length, get from Google map) separated by commas *',
      name: 'enterLatLng',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo`
  String get uploadPhotos {
    return Intl.message(
      'Upload a photo',
      name: 'uploadPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Recommendations`
  String get recomemndations {
    return Intl.message(
      'Recommendations',
      name: 'recomemndations',
      desc: '',
      args: [],
    );
  }

  /// `Bestseller`
  String get bestseller {
    return Intl.message(
      'Bestseller',
      name: 'bestseller',
      desc: '',
      args: [],
    );
  }

  /// `Tour details`
  String get tourDetails {
    return Intl.message(
      'Tour details',
      name: 'tourDetails',
      desc: '',
      args: [],
    );
  }

  /// `Notifications and messages about your orders and other news will be stored here`
  String get notifTag {
    return Intl.message(
      'Notifications and messages about your orders and other news will be stored here',
      name: 'notifTag',
      desc: '',
      args: [],
    );
  }

  /// `Guides from all over the world cooperate with us`
  String get introTagOne {
    return Intl.message(
      'Guides from all over the world cooperate with us',
      name: 'introTagOne',
      desc: '',
      args: [],
    );
  }

  /// `The VIP Tourist app is designed to purchase tourist excursions anywhere in the world, which means both abroad and in your city. If you haven't found the city or tour you need, tell us about it, and it will appear within a few days! After the appearance, we will definitely notify you with a push notification. Here you can Plan your tours in advance by purchasing tickets with a QR code, which you can save in your phone. We work for your comfort and convenience! We offer you to get acquainted with our `
  String get introTagTwo {
    return Intl.message(
      'The VIP Tourist app is designed to purchase tourist excursions anywhere in the world, which means both abroad and in your city. If you haven\'t found the city or tour you need, tell us about it, and it will appear within a few days! After the appearance, we will definitely notify you with a push notification. Here you can Plan your tours in advance by purchasing tickets with a QR code, which you can save in your phone. We work for your comfort and convenience! We offer you to get acquainted with our ',
      name: 'introTagTwo',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to VIP Tourist`
  String get welcomeIntro {
    return Intl.message(
      'Welcome to VIP Tourist',
      name: 'welcomeIntro',
      desc: '',
      args: [],
    );
  }

  /// `Select the interface language`
  String get selectLanguage {
    return Intl.message(
      'Select the interface language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Choose currency`
  String get selectCurrency {
    return Intl.message(
      'Choose currency',
      name: 'selectCurrency',
      desc: '',
      args: [],
    );
  }

  /// `privacy policy`
  String get privacyPolicyContext {
    return Intl.message(
      'privacy policy',
      name: 'privacyPolicyContext',
      desc: '',
      args: [],
    );
  }

  /// `Tours`
  String get tours {
    return Intl.message(
      'Tours',
      name: 'tours',
      desc: '',
      args: [],
    );
  }

  /// `Explore the world by finding tours around the world!`
  String get introTagThree {
    return Intl.message(
      'Explore the world by finding tours around the world!',
      name: 'introTagThree',
      desc: '',
      args: [],
    );
  }

  /// `Tickets`
  String get tickets {
    return Intl.message(
      'Tickets',
      name: 'tickets',
      desc: '',
      args: [],
    );
  }

  /// `Buy tickets and use the QR code for maximum convenience`
  String get introTagFour {
    return Intl.message(
      'Buy tickets and use the QR code for maximum convenience',
      name: 'introTagFour',
      desc: '',
      args: [],
    );
  }

  /// `You can join our team of guides and start selling your own tours`
  String get introTagFive {
    return Intl.message(
      'You can join our team of guides and start selling your own tours',
      name: 'introTagFive',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Notification successfully updated`
  String get notificationUpdatedSuccessfully {
    return Intl.message(
      'Notification successfully updated',
      name: 'notificationUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get noInternetCon {
    return Intl.message(
      'No internet connection',
      name: 'noInternetCon',
      desc: '',
      args: [],
    );
  }

  /// `This tour must be confirmed by a guide. After confirmation, we will notify you`
  String get guideConfirm {
    return Intl.message(
      'This tour must be confirmed by a guide. After confirmation, we will notify you',
      name: 'guideConfirm',
      desc: '',
      args: [],
    );
  }

  /// `The booking number is copied to the clipboard!`
  String get bookingIDisCopied {
    return Intl.message(
      'The booking number is copied to the clipboard!',
      name: 'bookingIDisCopied',
      desc: '',
      args: [],
    );
  }

  /// `Rate the guide`
  String get rateGuide {
    return Intl.message(
      'Rate the guide',
      name: 'rateGuide',
      desc: '',
      args: [],
    );
  }

  /// `Rate the guide's services. Click on the star to set your rating. Add more description here if you want.`
  String get rateGuideTag {
    return Intl.message(
      'Rate the guide\'s services. Click on the star to set your rating. Add more description here if you want.',
      name: 'rateGuideTag',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get submit {
    return Intl.message(
      'Send',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment here. `
  String get rateGuideTagTwo {
    return Intl.message(
      'Write your comment here. ',
      name: 'rateGuideTagTwo',
      desc: '',
      args: [],
    );
  }

  /// `You can cancel the order no later than 24 hours before the start of the tour, then you can get a refund to your account`
  String get cancelupToTwentyFour {
    return Intl.message(
      'You can cancel the order no later than 24 hours before the start of the tour, then you can get a refund to your account',
      name: 'cancelupToTwentyFour',
      desc: '',
      args: [],
    );
  }

  /// `Enter the supported languages (separated by a vertical line character (|) *`
  String get enterLanguages {
    return Intl.message(
      'Enter the supported languages (separated by a vertical line character (|) *',
      name: 'enterLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Russian|English|Italian`
  String get languageExample {
    return Intl.message(
      'Russian|English|Italian',
      name: 'languageExample',
      desc: '',
      args: [],
    );
  }

  /// `What is forbidden on the tour?  (through the vertical line symbol (|) (optional)`
  String get enterProhibs {
    return Intl.message(
      'What is forbidden on the tour?  (through the vertical line symbol (|) (optional)',
      name: 'enterProhibs',
      desc: '',
      args: [],
    );
  }

  /// `alcohol|smoking| pets`
  String get prohibsExample {
    return Intl.message(
      'alcohol|smoking| pets',
      name: 'prohibsExample',
      desc: '',
      args: [],
    );
  }

  /// `What should a tourist take with him on a tour? (through the vertical line symbol (|) (optional)`
  String get enterPrereq {
    return Intl.message(
      'What should a tourist take with him on a tour? (through the vertical line symbol (|) (optional)',
      name: 'enterPrereq',
      desc: '',
      args: [],
    );
  }

  /// `glasses/panama hat|sunscreen`
  String get prereqExample {
    return Intl.message(
      'glasses/panama hat|sunscreen',
      name: 'prereqExample',
      desc: '',
      args: [],
    );
  }

  /// `List what is included in the tour? (via the vertical line symbol (|) (optional)`
  String get enterIncluded {
    return Intl.message(
      'List what is included in the tour? (via the vertical line symbol (|) (optional)',
      name: 'enterIncluded',
      desc: '',
      args: [],
    );
  }

  /// `pick-up and drop-off | souvenirs | live tour`
  String get includedExample {
    return Intl.message(
      'pick-up and drop-off | souvenirs | live tour',
      name: 'includedExample',
      desc: '',
      args: [],
    );
  }

  /// `List what is NOT included in the tour? (via the vertical line symbol (|) (optional)`
  String get enterNotIncluded {
    return Intl.message(
      'List what is NOT included in the tour? (via the vertical line symbol (|) (optional)',
      name: 'enterNotIncluded',
      desc: '',
      args: [],
    );
  }

  /// `food|drinks|photos (available for purchase)`
  String get notIncludedExample {
    return Intl.message(
      'food|drinks|photos (available for purchase)',
      name: 'notIncludedExample',
      desc: '',
      args: [],
    );
  }

  /// `My Sales`
  String get mySales {
    return Intl.message(
      'My Sales',
      name: 'mySales',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your booking`
  String get confirmBooking {
    return Intl.message(
      'Confirm your booking',
      name: 'confirmBooking',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Perhaps you are not the guide of this tour or something else has gone wrong!`
  String get warnTag {
    return Intl.message(
      'An error occurred. Perhaps you are not the guide of this tour or something else has gone wrong!',
      name: 'warnTag',
      desc: '',
      args: [],
    );
  }

  /// `Scan the code`
  String get scanCode {
    return Intl.message(
      'Scan the code',
      name: 'scanCode',
      desc: '',
      args: [],
    );
  }

  /// `Barcode Type:`
  String get barcodeType {
    return Intl.message(
      'Barcode Type:',
      name: 'barcodeType',
      desc: '',
      args: [],
    );
  }

  /// `Data`
  String get data {
    return Intl.message(
      'Data',
      name: 'data',
      desc: '',
      args: [],
    );
  }

  /// `The tour is activated!`
  String get tourIsActivated {
    return Intl.message(
      'The tour is activated!',
      name: 'tourIsActivated',
      desc: '',
      args: [],
    );
  }

  /// `Only show`
  String get showOnly {
    return Intl.message(
      'Only show',
      name: 'showOnly',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed by you`
  String get confirmedByYou {
    return Intl.message(
      'Confirmed by you',
      name: 'confirmedByYou',
      desc: '',
      args: [],
    );
  }

  /// `Activated`
  String get activated {
    return Intl.message(
      'Activated',
      name: 'activated',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get canceled {
    return Intl.message(
      'Cancelled',
      name: 'canceled',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for confirmation`
  String get waitingForConfirm {
    return Intl.message(
      'Waiting for confirmation',
      name: 'waitingForConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Show all`
  String get showAll {
    return Intl.message(
      'Show all',
      name: 'showAll',
      desc: '',
      args: [],
    );
  }

  /// `Venue`
  String get placeOfThe {
    return Intl.message(
      'Venue',
      name: 'placeOfThe',
      desc: '',
      args: [],
    );
  }

  /// ` Could not copy the address`
  String get couldntCopy {
    return Intl.message(
      ' Could not copy the address',
      name: 'couldntCopy',
      desc: '',
      args: [],
    );
  }

  /// `Choose a meeting place with a tourist. (If the link is not active, it means you marked the transfer above)`
  String get chooseMeetingPoint {
    return Intl.message(
      'Choose a meeting place with a tourist. (If the link is not active, it means you marked the transfer above)',
      name: 'chooseMeetingPoint',
      desc: '',
      args: [],
    );
  }

  /// `This is your meeting place! `
  String get meetPntTagOne {
    return Intl.message(
      'This is your meeting place! ',
      name: 'meetPntTagOne',
      desc: '',
      args: [],
    );
  }

  /// `Drag this pink marker to assign a meeting place`
  String get meetPntTagTwo {
    return Intl.message(
      'Drag this pink marker to assign a meeting place',
      name: 'meetPntTagTwo',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phoneNumber {
    return Intl.message(
      'Phone number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `No phone number`
  String get noPhoneNumber {
    return Intl.message(
      'No phone number',
      name: 'noPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Select categories`
  String get selectCategories {
    return Intl.message(
      'Select categories',
      name: 'selectCategories',
      desc: '',
      args: [],
    );
  }

  /// `Currently you don't have any recommended tours`
  String get favTag {
    return Intl.message(
      'Currently you don\'t have any recommended tours',
      name: 'favTag',
      desc: '',
      args: [],
    );
  }

  /// `Choose a tour`
  String get pickUpTours {
    return Intl.message(
      'Choose a tour',
      name: 'pickUpTours',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message(
      'Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `My offers`
  String get myOffers {
    return Intl.message(
      'My offers',
      name: 'myOffers',
      desc: '',
      args: [],
    );
  }

  /// `Enter the transfer price`
  String get enterPriceForTransf {
    return Intl.message(
      'Enter the transfer price',
      name: 'enterPriceForTransf',
      desc: '',
      args: [],
    );
  }

  /// `Always available, cycle tour`
  String get alwaysAvailable {
    return Intl.message(
      'Always available, cycle tour',
      name: 'alwaysAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Transfer`
  String get transfer {
    return Intl.message(
      'Transfer',
      name: 'transfer',
      desc: '',
      args: [],
    );
  }

  /// `Food, snacks`
  String get foodsnacks {
    return Intl.message(
      'Food, snacks',
      name: 'foodsnacks',
      desc: '',
      args: [],
    );
  }

  /// `Specify what kind of food you will offer`
  String get enterFoodSnacks {
    return Intl.message(
      'Specify what kind of food you will offer',
      name: 'enterFoodSnacks',
      desc: '',
      args: [],
    );
  }

  /// `Enter the duration of the tour in hours*`
  String get enterHours {
    return Intl.message(
      'Enter the duration of the tour in hours*',
      name: 'enterHours',
      desc: '',
      args: [],
    );
  }

  /// `hamburger with chicken, juice, apples`
  String get enterFoodEx {
    return Intl.message(
      'hamburger with chicken, juice, apples',
      name: 'enterFoodEx',
      desc: '',
      args: [],
    );
  }

  /// `With transfer`
  String get withTransfer {
    return Intl.message(
      'With transfer',
      name: 'withTransfer',
      desc: '',
      args: [],
    );
  }

  /// `With food and snacks`
  String get withFood {
    return Intl.message(
      'With food and snacks',
      name: 'withFood',
      desc: '',
      args: [],
    );
  }

  /// `There are no offers on your list. You can apply to create a new tour`
  String get nOffersTag {
    return Intl.message(
      'There are no offers on your list. You can apply to create a new tour',
      name: 'nOffersTag',
      desc: '',
      args: [],
    );
  }

  /// `The address is copied to the clipboard!`
  String get addresIsCopied {
    return Intl.message(
      'The address is copied to the clipboard!',
      name: 'addresIsCopied',
      desc: '',
      args: [],
    );
  }

  /// `The tour has been sent to the moderator for review. (You can view and edit your tour in your profile, in the My offers`
  String get toursIsSentTag {
    return Intl.message(
      'The tour has been sent to the moderator for review. (You can view and edit your tour in your profile, in the My offers',
      name: 'toursIsSentTag',
      desc: '',
      args: [],
    );
  }

  /// `Go to offers`
  String get goToOffers {
    return Intl.message(
      'Go to offers',
      name: 'goToOffers',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Number of people`
  String get numberOfPpl {
    return Intl.message(
      'Number of people',
      name: 'numberOfPpl',
      desc: '',
      args: [],
    );
  }

  /// `People are not selected`
  String get noPeople {
    return Intl.message(
      'People are not selected',
      name: 'noPeople',
      desc: '',
      args: [],
    );
  }

  /// `Children`
  String get children {
    return Intl.message(
      'Children',
      name: 'children',
      desc: '',
      args: [],
    );
  }

  /// `Adults`
  String get adults {
    return Intl.message(
      'Adults',
      name: 'adults',
      desc: '',
      args: [],
    );
  }

  /// `Final price / When paying, this amount will be converted to Russian rubles.`
  String get overall {
    return Intl.message(
      'Final price / When paying, this amount will be converted to Russian rubles.',
      name: 'overall',
      desc: '',
      args: [],
    );
  }

  /// `By clicking on the Next button, you will be redirected to the Yookassa payment service, where you will complete the purchase`
  String get billingTag {
    return Intl.message(
      'By clicking on the Next button, you will be redirected to the Yookassa payment service, where you will complete the purchase',
      name: 'billingTag',
      desc: '',
      args: [],
    );
  }

  /// `The payment was successfully made! (Your QR ticket will be generated in the Orders tab. It will need to be shown at the venue of the tour. It is advisable to save it in your phone) `
  String get successPayment {
    return Intl.message(
      'The payment was successfully made! (Your QR ticket will be generated in the Orders tab. It will need to be shown at the venue of the tour. It is advisable to save it in your phone) ',
      name: 'successPayment',
      desc: '',
      args: [],
    );
  }

  /// `You will be redirected to the booking screen`
  String get orderScreenRedirect {
    return Intl.message(
      'You will be redirected to the booking screen',
      name: 'orderScreenRedirect',
      desc: '',
      args: [],
    );
  }

  /// `You can see your orders in the Orders tab`
  String get youCanOrders {
    return Intl.message(
      'You can see your orders in the Orders tab',
      name: 'youCanOrders',
      desc: '',
      args: [],
    );
  }

  /// `Activate`
  String get activate {
    return Intl.message(
      'Activate',
      name: 'activate',
      desc: '',
      args: [],
    );
  }

  /// `Excuse me`
  String get sorry {
    return Intl.message(
      'Excuse me',
      name: 'sorry',
      desc: '',
      args: [],
    );
  }

  /// `Choose a certain tour to provide your offer, or create a new one`
  String get addTourTag {
    return Intl.message(
      'Choose a certain tour to provide your offer, or create a new one',
      name: 'addTourTag',
      desc: '',
      args: [],
    );
  }

  /// `Create an offer for an existing tour`
  String get createOffer {
    return Intl.message(
      'Create an offer for an existing tour',
      name: 'createOffer',
      desc: '',
      args: [],
    );
  }

  /// `Create a new tour`
  String get createNewTour {
    return Intl.message(
      'Create a new tour',
      name: 'createNewTour',
      desc: '',
      args: [],
    );
  }

  /// `Add an offer`
  String get addOffer {
    return Intl.message(
      'Add an offer',
      name: 'addOffer',
      desc: '',
      args: [],
    );
  }

  /// `The offer is sent for verification. You can edit it here.`
  String get offerIsSent {
    return Intl.message(
      'The offer is sent for verification. You can edit it here.',
      name: 'offerIsSent',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get Currency {
    return Intl.message(
      'Currency',
      name: 'Currency',
      desc: '',
      args: [],
    );
  }

  /// `Your attached card`
  String get yourAttachedCard {
    return Intl.message(
      'Your attached card',
      name: 'yourAttachedCard',
      desc: '',
      args: [],
    );
  }

  /// `Get the balance`
  String get getTheBalance {
    return Intl.message(
      'Get the balance',
      name: 'getTheBalance',
      desc: '',
      args: [],
    );
  }

  /// `Card Name`
  String get cardName {
    return Intl.message(
      'Card Name',
      name: 'cardName',
      desc: '',
      args: [],
    );
  }

  /// `Card number`
  String get cardNumber {
    return Intl.message(
      'Card number',
      name: 'cardNumber',
      desc: '',
      args: [],
    );
  }

  /// `IBAN `
  String get ibanAccount {
    return Intl.message(
      'IBAN ',
      name: 'ibanAccount',
      desc: '',
      args: [],
    );
  }

  /// `We need to save information about your bank account in order to be able to transfer funds. We only store the card name and card number. Additional information is available in the privacy policy.`
  String get bankTag {
    return Intl.message(
      'We need to save information about your bank account in order to be able to transfer funds. We only store the card name and card number. Additional information is available in the privacy policy.',
      name: 'bankTag',
      desc: '',
      args: [],
    );
  }

  /// `The card has been saved successfully`
  String get cardSaved {
    return Intl.message(
      'The card has been saved successfully',
      name: 'cardSaved',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation of the withdrawal request`
  String get withdrawalConfirm {
    return Intl.message(
      'Confirmation of the withdrawal request',
      name: 'withdrawalConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Get the balance`
  String get getBalance {
    return Intl.message(
      'Get the balance',
      name: 'getBalance',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get card {
    return Intl.message(
      'Map',
      name: 'card',
      desc: '',
      args: [],
    );
  }

  /// `First you need to attach the bank card information in your profile!`
  String get cardAttachAlarm {
    return Intl.message(
      'First you need to attach the bank card information in your profile!',
      name: 'cardAttachAlarm',
      desc: '',
      args: [],
    );
  }

  /// `Enter the ticket price for an adult and a child`
  String get enterTicketPrices {
    return Intl.message(
      'Enter the ticket price for an adult and a child',
      name: 'enterTicketPrices',
      desc: '',
      args: [],
    );
  }

  /// `Choose currency`
  String get chooseCurrency {
    return Intl.message(
      'Choose currency',
      name: 'chooseCurrency',
      desc: '',
      args: [],
    );
  }

  /// `The entry field should not be empty`
  String get fieldShouldntBe {
    return Intl.message(
      'The entry field should not be empty',
      name: 'fieldShouldntBe',
      desc: '',
      args: [],
    );
  }

  /// `Your price per tour`
  String get yourPriceForTour {
    return Intl.message(
      'Your price per tour',
      name: 'yourPriceForTour',
      desc: '',
      args: [],
    );
  }

  /// `Final price / When paying, this amount will be converted to rus.rub`
  String get totalPrice {
    return Intl.message(
      'Final price / When paying, this amount will be converted to rus.rub',
      name: 'totalPrice',
      desc: '',
      args: [],
    );
  }

  /// `Commission for using our service.`
  String get comissionTag {
    return Intl.message(
      'Commission for using our service.',
      name: 'comissionTag',
      desc: '',
      args: [],
    );
  }

  /// `Enter prices in US dollars. If the price of a children's ticket is the same as an adult, then it is not necessary to enter it. If there are free tickets, write about it in the description`
  String get usdTag {
    return Intl.message(
      'Enter prices in US dollars. If the price of a children\'s ticket is the same as an adult, then it is not necessary to enter it. If there are free tickets, write about it in the description',
      name: 'usdTag',
      desc: '',
      args: [],
    );
  }

  /// `With commission`
  String get withComission {
    return Intl.message(
      'With commission',
      name: 'withComission',
      desc: '',
      args: [],
    );
  }

  /// `Total amount for adults`
  String get overallTotalAdult {
    return Intl.message(
      'Total amount for adults',
      name: 'overallTotalAdult',
      desc: '',
      args: [],
    );
  }

  /// `Total amount for the child`
  String get overallTotalChild {
    return Intl.message(
      'Total amount for the child',
      name: 'overallTotalChild',
      desc: '',
      args: [],
    );
  }

  /// `Enter the transfer price in dollars`
  String get transferPriceInfo {
    return Intl.message(
      'Enter the transfer price in dollars',
      name: 'transferPriceInfo',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred. Try again! `
  String get errorOccuredTryAgain {
    return Intl.message(
      'An error occurred. Try again! ',
      name: 'errorOccuredTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `There are no tours available in this city or another mistake has occurred!`
  String get noToursHomeScreenTag {
    return Intl.message(
      'There are no tours available in this city or another mistake has occurred!',
      name: 'noToursHomeScreenTag',
      desc: '',
      args: [],
    );
  }

  /// `Enter the transfer price in dollars, if this price is not already included in the tour. This service is to bring/take back a tourist`
  String get priceForTransferTag {
    return Intl.message(
      'Enter the transfer price in dollars, if this price is not already included in the tour. This service is to bring/take back a tourist',
      name: 'priceForTransferTag',
      desc: '',
      args: [],
    );
  }

  /// `The website is on maintenance, if you have an urgent question, please contact us.`
  String get workisunderway {
    return Intl.message(
      'The website is on maintenance, if you have an urgent question, please contact us.',
      name: 'workisunderway',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get home {
    return Intl.message(
      'Main',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Activation status`
  String get activationStatus {
    return Intl.message(
      'Activation status',
      name: 'activationStatus',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `The QR code is saved in the gallery!`
  String get qrCodeSaved {
    return Intl.message(
      'The QR code is saved in the gallery!',
      name: 'qrCodeSaved',
      desc: '',
      args: [],
    );
  }

  /// `You have already rated!`
  String get youHaveAlreadeRate {
    return Intl.message(
      'You have already rated!',
      name: 'youHaveAlreadeRate',
      desc: '',
      args: [],
    );
  }

  /// `Personal Notifications`
  String get personalNotif {
    return Intl.message(
      'Personal Notifications',
      name: 'personalNotif',
      desc: '',
      args: [],
    );
  }

  /// `General notifications`
  String get generalNotif {
    return Intl.message(
      'General notifications',
      name: 'generalNotif',
      desc: '',
      args: [],
    );
  }

  /// `Delete this notification?`
  String get deleteThisNotif {
    return Intl.message(
      'Delete this notification?',
      name: 'deleteThisNotif',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Your price for the transfer`
  String get yourPriceForTransfer {
    return Intl.message(
      'Your price for the transfer',
      name: 'yourPriceForTransfer',
      desc: '',
      args: [],
    );
  }

  /// `On consideration`
  String get onConsider {
    return Intl.message(
      'On consideration',
      name: 'onConsider',
      desc: '',
      args: [],
    );
  }

  /// `First you have to pass `
  String get youHaveToVerify {
    return Intl.message(
      'First you have to pass ',
      name: 'youHaveToVerify',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to become a tourist?`
  String get wantToBecomeTourist {
    return Intl.message(
      'Do you want to become a tourist?',
      name: 'wantToBecomeTourist',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Now you are a tourist!`
  String get youSuccessTourist {
    return Intl.message(
      'Now you are a tourist!',
      name: 'youSuccessTourist',
      desc: '',
      args: [],
    );
  }

  /// `To become a full-fledged guide`
  String get toBecomeFull {
    return Intl.message(
      'To become a full-fledged guide',
      name: 'toBecomeFull',
      desc: '',
      args: [],
    );
  }

  /// `Rate the tour. Click on the star to set your rating. Add more description here if you want.`
  String get rateTourTag {
    return Intl.message(
      'Rate the tour. Click on the star to set your rating. Add more description here if you want.',
      name: 'rateTourTag',
      desc: '',
      args: [],
    );
  }

  /// `You can't leave more than 1 review!`
  String get onlyOneReview {
    return Intl.message(
      'You can\'t leave more than 1 review!',
      name: 'onlyOneReview',
      desc: '',
      args: [],
    );
  }

  /// `Not defined`
  String get undefined {
    return Intl.message(
      'Not defined',
      name: 'undefined',
      desc: '',
      args: [],
    );
  }

  /// `Due to tax deductions, the interest rate may change at the discretion of the VIPtourist administration`
  String get commissionTag {
    return Intl.message(
      'Due to tax deductions, the interest rate may change at the discretion of the VIPtourist administration',
      name: 'commissionTag',
      desc: '',
      args: [],
    );
  }

  /// `You can send your request to add a certain city`
  String get youCanSendInquiry {
    return Intl.message(
      'You can send your request to add a certain city',
      name: 'youCanSendInquiry',
      desc: '',
      args: [],
    );
  }

  /// `I would like to add a new city`
  String get subjectOne {
    return Intl.message(
      'I would like to add a new city',
      name: 'subjectOne',
      desc: '',
      args: [],
    );
  }

  /// `Save as Draft`
  String get saveDraft {
    return Intl.message(
      'Save as Draft',
      name: 'saveDraft',
      desc: '',
      args: [],
    );
  }

  /// `Erase`
  String get erase {
    return Intl.message(
      'Erase',
      name: 'erase',
      desc: '',
      args: [],
    );
  }

  /// `The documents have been uploaded successfully! You will be notified shortly.`
  String get docSentTag {
    return Intl.message(
      'The documents have been uploaded successfully! You will be notified shortly.',
      name: 'docSentTag',
      desc: '',
      args: [],
    );
  }

  /// `I can't find my ticket (booking number)`
  String get cantFindMyTicket {
    return Intl.message(
      'I can\'t find my ticket (booking number)',
      name: 'cantFindMyTicket',
      desc: '',
      args: [],
    );
  }

  /// `I'd like to leave feedback`
  String get wantToLeaveFeedback {
    return Intl.message(
      'I\'d like to leave feedback',
      name: 'wantToLeaveFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Erase data?`
  String get eraseFields {
    return Intl.message(
      'Erase data?',
      name: 'eraseFields',
      desc: '',
      args: [],
    );
  }

  /// `Draft saved!`
  String get draftSaved {
    return Intl.message(
      'Draft saved!',
      name: 'draftSaved',
      desc: '',
      args: [],
    );
  }

  /// `Attention!  Work is currently underway. If you are guide, you can apply now for placement of your tour on our service. We will notifty you as soon as its becomes possible to purchase tours.`
  String get lastfirst {
    return Intl.message(
      'Attention!  Work is currently underway. If you are guide, you can apply now for placement of your tour on our service. We will notifty you as soon as its becomes possible to purchase tours.',
      name: 'lastfirst',
      desc: '',
      args: [],
    );
  }

  /// `Send a request to add a city`
  String get touristyouCanSendInquiry {
    return Intl.message(
      'Send a request to add a city',
      name: 'touristyouCanSendInquiry',
      desc: '',
      args: [],
    );
  }

  /// `I would like to ask you to add this city:  `
  String get texttouristaddcity {
    return Intl.message(
      'I would like to ask you to add this city:  ',
      name: 'texttouristaddcity',
      desc: '',
      args: [],
    );
  }

  /// `The screenshot of your page from a social network with the address of the guide's work page.`
  String get fourthdocument {
    return Intl.message(
      'The screenshot of your page from a social network with the address of the guide\'s work page.',
      name: 'fourthdocument',
      desc: '',
      args: [],
    );
  }

  /// `Upload beatiful photos of your tour`
  String get photos {
    return Intl.message(
      'Upload beatiful photos of your tour',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Meeting point address`
  String get meetingPntAdress {
    return Intl.message(
      'Meeting point address',
      name: 'meetingPntAdress',
      desc: '',
      args: [],
    );
  }

  /// `Loading..`
  String get loading {
    return Intl.message(
      'Loading..',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Email`
  String get signInWithEmail {
    return Intl.message(
      'Sign in with Email',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `City addition request`
  String get cityAddRequest {
    return Intl.message(
      'City addition request',
      name: 'cityAddRequest',
      desc: '',
      args: [],
    );
  }

  /// `Attention!  Work is currently underway. If you are guide, you can apply now for placement of your tour on our service.`
  String get freshTag1 {
    return Intl.message(
      'Attention!  Work is currently underway. If you are guide, you can apply now for placement of your tour on our service.',
      name: 'freshTag1',
      desc: '',
      args: [],
    );
  }

  /// `We will notifty you as soon as its becomes possible to purchase tours.`
  String get freshTag2 {
    return Intl.message(
      'We will notifty you as soon as its becomes possible to purchase tours.',
      name: 'freshTag2',
      desc: '',
      args: [],
    );
  }

  /// `The VIP Tourist app is designed to purchase tourist excursions anywhere in the world, which means both abroad and in your city. Guides from all over the world cooperate with us. `
  String get introNew1 {
    return Intl.message(
      'The VIP Tourist app is designed to purchase tourist excursions anywhere in the world, which means both abroad and in your city. Guides from all over the world cooperate with us. ',
      name: 'introNew1',
      desc: '',
      args: [],
    );
  }

  /// `If you haven't found the city or tour you need, tell us about it, and it will appear within a few days! After the appearance, we will definitely notify you with a push notification. `
  String get introNew2 {
    return Intl.message(
      'If you haven\'t found the city or tour you need, tell us about it, and it will appear within a few days! After the appearance, we will definitely notify you with a push notification. ',
      name: 'introNew2',
      desc: '',
      args: [],
    );
  }

  /// `We offer you to get acquainted with our `
  String get introNew3 {
    return Intl.message(
      'We offer you to get acquainted with our ',
      name: 'introNew3',
      desc: '',
      args: [],
    );
  }

  /// `Driver will pick you up`
  String get driverWillPickUp {
    return Intl.message(
      'Driver will pick you up',
      name: 'driverWillPickUp',
      desc: '',
      args: [],
    );
  }

  /// `Tour is sent for verification. You can edit it here.`
  String get tourIsSent {
    return Intl.message(
      'Tour is sent for verification. You can edit it here.',
      name: 'tourIsSent',
      desc: '',
      args: [],
    );
  }

  /// `My tours`
  String get myTours {
    return Intl.message(
      'My tours',
      name: 'myTours',
      desc: '',
      args: [],
    );
  }

  /// `Popular cities`
  String get popularCities {
    return Intl.message(
      'Popular cities',
      name: 'popularCities',
      desc: '',
      args: [],
    );
  }

  /// `Popular tours`
  String get popularTours {
    return Intl.message(
      'Popular tours',
      name: 'popularTours',
      desc: '',
      args: [],
    );
  }

  /// `First enter your phone number, please!`
  String get mobilenotifi {
    return Intl.message(
      'First enter your phone number, please!',
      name: 'mobilenotifi',
      desc: '',
      args: [],
    );
  }

  /// `Hints`
  String get hints {
    return Intl.message(
      'Hints',
      name: 'hints',
      desc: '',
      args: [],
    );
  }

  /// `Edit tour`
  String get editTour {
    return Intl.message(
      'Edit tour',
      name: 'editTour',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `You have already rated the app!`
  String get uHaveAlreadyRated {
    return Intl.message(
      'You have already rated the app!',
      name: 'uHaveAlreadyRated',
      desc: '',
      args: [],
    );
  }

  /// `I would like to ask you to add this city/tour: `
  String get texttouristaddcity2 {
    return Intl.message(
      'I would like to ask you to add this city/tour: ',
      name: 'texttouristaddcity2',
      desc: '',
      args: [],
    );
  }

  /// `Send a request to add a city or tour`
  String get touristyouCanSendInquiry2 {
    return Intl.message(
      'Send a request to add a city or tour',
      name: 'touristyouCanSendInquiry2',
      desc: '',
      args: [],
    );
  }

  /// `Notifi...`
  String get notif {
    return Intl.message(
      'Notifi...',
      name: 'notif',
      desc: '',
      args: [],
    );
  }

  /// `We work for your comfort and convenience! `
  String get weWorkForU {
    return Intl.message(
      'We work for your comfort and convenience! ',
      name: 'weWorkForU',
      desc: '',
      args: [],
    );
  }

  /// `You must upload minimum 2 files!`
  String get min4files {
    return Intl.message(
      'You must upload minimum 2 files!',
      name: 'min4files',
      desc: '',
      args: [],
    );
  }

  /// `Here you can Plan your tours in advance by purchasing tickets with a QR code, which you can save in your phone. `
  String get introNew4 {
    return Intl.message(
      'Here you can Plan your tours in advance by purchasing tickets with a QR code, which you can save in your phone. ',
      name: 'introNew4',
      desc: '',
      args: [],
    );
  }

  /// `Seats available`
  String get seatsAvailable {
    return Intl.message(
      'Seats available',
      name: 'seatsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `per person`
  String get perPerson {
    return Intl.message(
      'per person',
      name: 'perPerson',
      desc: '',
      args: [],
    );
  }

  /// `Adventure`
  String get adventure {
    return Intl.message(
      'Adventure',
      name: 'adventure',
      desc: '',
      args: [],
    );
  }

  /// `Small group`
  String get smallGroup {
    return Intl.message(
      'Small group',
      name: 'smallGroup',
      desc: '',
      args: [],
    );
  }

  /// `No transfer`
  String get noTransfer {
    return Intl.message(
      'No transfer',
      name: 'noTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Hunting`
  String get hunting {
    return Intl.message(
      'Hunting',
      name: 'hunting',
      desc: '',
      args: [],
    );
  }

  /// `Fishing`
  String get fishing {
    return Intl.message(
      'Fishing',
      name: 'fishing',
      desc: '',
      args: [],
    );
  }

  /// `Night tour`
  String get night {
    return Intl.message(
      'Night tour',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  /// `Game`
  String get game {
    return Intl.message(
      'Game',
      name: 'game',
      desc: '',
      args: [],
    );
  }

  /// `Only transfer`
  String get onlyTransfer {
    return Intl.message(
      'Only transfer',
      name: 'onlyTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Few days tour`
  String get fewDaysTrip {
    return Intl.message(
      'Few days tour',
      name: 'fewDaysTrip',
      desc: '',
      args: [],
    );
  }

  /// `Tour for one person`
  String get onePersonTour {
    return Intl.message(
      'Tour for one person',
      name: 'onePersonTour',
      desc: '',
      args: [],
    );
  }

  /// `Private tour for group`
  String get privateTourForGroup {
    return Intl.message(
      'Private tour for group',
      name: 'privateTourForGroup',
      desc: '',
      args: [],
    );
  }

  /// `Tour for small groups`
  String get smallGroupedTour {
    return Intl.message(
      'Tour for small groups',
      name: 'smallGroupedTour',
      desc: '',
      args: [],
    );
  }

  /// `Invalid format. Enter numbers!`
  String get invalidFormatTag {
    return Intl.message(
      'Invalid format. Enter numbers!',
      name: 'invalidFormatTag',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of available seats`
  String get enterSeats {
    return Intl.message(
      'Enter number of available seats',
      name: 'enterSeats',
      desc: '',
      args: [],
    );
  }

  /// `Upload car photo`
  String get uploadCarPhoto {
    return Intl.message(
      'Upload car photo',
      name: 'uploadCarPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Preview image of tour`
  String get previewImage {
    return Intl.message(
      'Preview image of tour',
      name: 'previewImage',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal request, guide didn't confirm my order`
  String get withdrawalRequestTag {
    return Intl.message(
      'Withdrawal request, guide didn\'t confirm my order',
      name: 'withdrawalRequestTag',
      desc: '',
      args: [],
    );
  }

  /// `You have to upload car photo if you include transfer`
  String get noCarPhotoSelectedWarn {
    return Intl.message(
      'You have to upload car photo if you include transfer',
      name: 'noCarPhotoSelectedWarn',
      desc: '',
      args: [],
    );
  }

  /// `Photo of car`
  String get carPhoto {
    return Intl.message(
      'Photo of car',
      name: 'carPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Days`
  String get days {
    return Intl.message(
      'Days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `Day`
  String get day {
    return Intl.message(
      'Day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `Active tours`
  String get activeTours {
    return Intl.message(
      'Active tours',
      name: 'activeTours',
      desc: '',
      args: [],
    );
  }

  /// `Draft`
  String get draft {
    return Intl.message(
      'Draft',
      name: 'draft',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get monday {
    return Intl.message(
      'Monday',
      name: 'monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message(
      'Tuesday',
      name: 'tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message(
      'Wednesday',
      name: 'wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get thursday {
    return Intl.message(
      'Thursday',
      name: 'thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get friday {
    return Intl.message(
      'Friday',
      name: 'friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get saturday {
    return Intl.message(
      'Saturday',
      name: 'saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get sunday {
    return Intl.message(
      'Sunday',
      name: 'sunday',
      desc: '',
      args: [],
    );
  }

  /// `Mn`
  String get mn {
    return Intl.message(
      'Mn',
      name: 'mn',
      desc: '',
      args: [],
    );
  }

  /// `Tu`
  String get tu {
    return Intl.message(
      'Tu',
      name: 'tu',
      desc: '',
      args: [],
    );
  }

  /// `Wd`
  String get wd {
    return Intl.message(
      'Wd',
      name: 'wd',
      desc: '',
      args: [],
    );
  }

  /// `Th`
  String get th {
    return Intl.message(
      'Th',
      name: 'th',
      desc: '',
      args: [],
    );
  }

  /// `Fr`
  String get fr {
    return Intl.message(
      'Fr',
      name: 'fr',
      desc: '',
      args: [],
    );
  }

  /// `St`
  String get st {
    return Intl.message(
      'St',
      name: 'st',
      desc: '',
      args: [],
    );
  }

  /// `Sn`
  String get sn {
    return Intl.message(
      'Sn',
      name: 'sn',
      desc: '',
      args: [],
    );
  }

  /// `Select days of week of tours`
  String get selectDaysOfWeek {
    return Intl.message(
      'Select days of week of tours',
      name: 'selectDaysOfWeek',
      desc: '',
      args: [],
    );
  }

  /// `Free tour`
  String get freeTour {
    return Intl.message(
      'Free tour',
      name: 'freeTour',
      desc: '',
      args: [],
    );
  }

  /// `My tour is free`
  String get myTourIsFree {
    return Intl.message(
      'My tour is free',
      name: 'myTourIsFree',
      desc: '',
      args: [],
    );
  }

  /// `Notes about free tickets for tour (Optional)`
  String get notesAboutFreeTour {
    return Intl.message(
      'Notes about free tickets for tour (Optional)',
      name: 'notesAboutFreeTour',
      desc: '',
      args: [],
    );
  }

  /// `Tour schedule`
  String get tourSchedule {
    return Intl.message(
      'Tour schedule',
      name: 'tourSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Every week`
  String get everyWeek {
    return Intl.message(
      'Every week',
      name: 'everyWeek',
      desc: '',
      args: [],
    );
  }

  /// `Time of the tour`
  String get timeOfTour {
    return Intl.message(
      'Time of the tour',
      name: 'timeOfTour',
      desc: '',
      args: [],
    );
  }

  /// `Include the transfer price in adults and children ticket price above in dollars`
  String get transferPriceInfo2 {
    return Intl.message(
      'Include the transfer price in adults and children ticket price above in dollars',
      name: 'transferPriceInfo2',
      desc: '',
      args: [],
    );
  }

  /// `Geolocation is turned off!`
  String get geolocationOff {
    return Intl.message(
      'Geolocation is turned off!',
      name: 'geolocationOff',
      desc: '',
      args: [],
    );
  }

  /// `Select date and time`
  String get selectDateAndTime {
    return Intl.message(
      'Select date and time',
      name: 'selectDateAndTime',
      desc: '',
      args: [],
    );
  }

  /// `Children tickets are free`
  String get freeChildTicketEx {
    return Intl.message(
      'Children tickets are free',
      name: 'freeChildTicketEx',
      desc: '',
      args: [],
    );
  }

  /// `You have to select days of week if your tour is cycled!`
  String get daysOfWeekNotSelected {
    return Intl.message(
      'You have to select days of week if your tour is cycled!',
      name: 'daysOfWeekNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Ready! Your tour has been sent to verification`
  String get tourSendTag1 {
    return Intl.message(
      'Ready! Your tour has been sent to verification',
      name: 'tourSendTag1',
      desc: '',
      args: [],
    );
  }

  /// `It usually takes from 30 minutes to 2 hours.`
  String get tourSendTag2 {
    return Intl.message(
      'It usually takes from 30 minutes to 2 hours.',
      name: 'tourSendTag2',
      desc: '',
      args: [],
    );
  }

  /// `Tours are scheduled by these days`
  String get toursAreScheduled {
    return Intl.message(
      'Tours are scheduled by these days',
      name: 'toursAreScheduled',
      desc: '',
      args: [],
    );
  }

  /// `From 0 to $9.99 = $2`
  String get commission0 {
    return Intl.message(
      'From 0 to \$9.99 = \$2',
      name: 'commission0',
      desc: '',
      args: [],
    );
  }

  /// `From $10 to $30.99 = 20%.`
  String get commission1 {
    return Intl.message(
      'From \$10 to \$30.99 = 20%.',
      name: 'commission1',
      desc: '',
      args: [],
    );
  }

  /// `From $31 to $39.99 = $7`
  String get commission2 {
    return Intl.message(
      'From \$31 to \$39.99 = \$7',
      name: 'commission2',
      desc: '',
      args: [],
    );
  }

  /// `From $40 to $130.99 = 18%.`
  String get commission3 {
    return Intl.message(
      'From \$40 to \$130.99 = 18%.',
      name: 'commission3',
      desc: '',
      args: [],
    );
  }

  /// `From $131 to $230.99 = $30.`
  String get commission4 {
    return Intl.message(
      'From \$131 to \$230.99 = \$30.',
      name: 'commission4',
      desc: '',
      args: [],
    );
  }

  /// `From $231 to $500.99 = 13%.`
  String get commission5 {
    return Intl.message(
      'From \$231 to \$500.99 = 13%.',
      name: 'commission5',
      desc: '',
      args: [],
    );
  }

  /// `From $501 and above = 10%.`
  String get commission6 {
    return Intl.message(
      'From \$501 and above = 10%.',
      name: 'commission6',
      desc: '',
      args: [],
    );
  }

  /// `Notes about free ticket for tour`
  String get notesAboutFreeTour2 {
    return Intl.message(
      'Notes about free ticket for tour',
      name: 'notesAboutFreeTour2',
      desc: '',
      args: [],
    );
  }

  /// `Required fields`
  String get requiredFields {
    return Intl.message(
      'Required fields',
      name: 'requiredFields',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message(
      'Optional',
      name: 'optional',
      desc: '',
      args: [],
    );
  }

  /// `Turkish, english`
  String get languageEx {
    return Intl.message(
      'Turkish, english',
      name: 'languageEx',
      desc: '',
      args: [],
    );
  }

  /// `Choose supported languages`
  String get chooseLanguages {
    return Intl.message(
      'Choose supported languages',
      name: 'chooseLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Enter tour name`
  String get uShouldEnterTour {
    return Intl.message(
      'Enter tour name',
      name: 'uShouldEnterTour',
      desc: '',
      args: [],
    );
  }

  /// `Enter tour description`
  String get uShouldEnterDescription {
    return Intl.message(
      'Enter tour description',
      name: 'uShouldEnterDescription',
      desc: '',
      args: [],
    );
  }

  /// `Enter duration`
  String get uShouldEnterDuration {
    return Intl.message(
      'Enter duration',
      name: 'uShouldEnterDuration',
      desc: '',
      args: [],
    );
  }

  /// `Enter number of available seats`
  String get uShouldEnterSeats {
    return Intl.message(
      'Enter number of available seats',
      name: 'uShouldEnterSeats',
      desc: '',
      args: [],
    );
  }

  /// `You should select tour languages`
  String get uShouldEnterLanguages {
    return Intl.message(
      'You should select tour languages',
      name: 'uShouldEnterLanguages',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields`
  String get pleaseEnter {
    return Intl.message(
      'Please fill in all fields',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  /// `Get some glasses and cold water`
  String get prereqEx {
    return Intl.message(
      'Get some glasses and cold water',
      name: 'prereqEx',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is included in tour? (Optional)`
  String get enterIncludedNew {
    return Intl.message(
      'Enter what is included in tour? (Optional)',
      name: 'enterIncludedNew',
      desc: '',
      args: [],
    );
  }

  /// `Food and drink`
  String get includedEx {
    return Intl.message(
      'Food and drink',
      name: 'includedEx',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is not included in tour? (optional)`
  String get enterNotIncludedNew {
    return Intl.message(
      'Enter what is not included in tour? (optional)',
      name: 'enterNotIncludedNew',
      desc: '',
      args: [],
    );
  }

  /// `Transfer and food`
  String get notIncludedEx {
    return Intl.message(
      'Transfer and food',
      name: 'notIncludedEx',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is prohibited  on tour? (optional)`
  String get enterProhibsNew {
    return Intl.message(
      'Enter what is prohibited  on tour? (optional)',
      name: 'enterProhibsNew',
      desc: '',
      args: [],
    );
  }

  /// `Alcohol and smoking`
  String get prohibsEx {
    return Intl.message(
      'Alcohol and smoking',
      name: 'prohibsEx',
      desc: '',
      args: [],
    );
  }

  /// `Select a time`
  String get selectTime {
    return Intl.message(
      'Select a time',
      name: 'selectTime',
      desc: '',
      args: [],
    );
  }

  /// `You must upload tour photos!`
  String get uMustUploadPhotos {
    return Intl.message(
      'You must upload tour photos!',
      name: 'uMustUploadPhotos',
      desc: '',
      args: [],
    );
  }

  /// `You must upload photos!`
  String get uMustUploadPhotos2 {
    return Intl.message(
      'You must upload photos!',
      name: 'uMustUploadPhotos2',
      desc: '',
      args: [],
    );
  }

  /// `Describe the sights, describe the tour so that the tourist would be interested in that`
  String get descEx {
    return Intl.message(
      'Describe the sights, describe the tour so that the tourist would be interested in that',
      name: 'descEx',
      desc: '',
      args: [],
    );
  }

  /// `step`
  String get step {
    return Intl.message(
      'step',
      name: 'step',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get izz {
    return Intl.message(
      'of',
      name: 'izz',
      desc: '',
      args: [],
    );
  }

  /// `You must choose at least one adult ticket!`
  String get atLeastOneAdult {
    return Intl.message(
      'You must choose at least one adult ticket!',
      name: 'atLeastOneAdult',
      desc: '',
      args: [],
    );
  }

  /// `ПУТЕШЕСТВИЕ УЖЕ НАЧАЛОСЬ`
  String get adventureHasStarted {
    return Intl.message(
      'ПУТЕШЕСТВИЕ УЖЕ НАЧАЛОСЬ',
      name: 'adventureHasStarted',
      desc: '',
      args: [],
    );
  }

  /// `Больше 100 стран мира в одном приложении. Выбирай и бронируй!`
  String get signInOptionTag {
    return Intl.message(
      'Больше 100 стран мира в одном приложении. Выбирай и бронируй!',
      name: 'signInOptionTag',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Recently watched`
  String get recentlyWatched {
    return Intl.message(
      'Recently watched',
      name: 'recentlyWatched',
      desc: '',
      args: [],
    );
  }

  /// `Look tours on map`
  String get lookToursOnMap {
    return Intl.message(
      'Look tours on map',
      name: 'lookToursOnMap',
      desc: '',
      args: [],
    );
  }

  /// `All categories`
  String get allCategories {
    return Intl.message(
      'All categories',
      name: 'allCategories',
      desc: '',
      args: [],
    );
  }

  /// `Package`
  String get package {
    return Intl.message(
      'Package',
      name: 'package',
      desc: '',
      args: [],
    );
  }

  /// `One day`
  String get oneDay2 {
    return Intl.message(
      'One day',
      name: 'oneDay2',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private2 {
    return Intl.message(
      'Private',
      name: 'private2',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Prerequisites`
  String get prerequisites2 {
    return Intl.message(
      'Prerequisites',
      name: 'prerequisites2',
      desc: '',
      args: [],
    );
  }

  /// `Buy now`
  String get buyNow {
    return Intl.message(
      'Buy now',
      name: 'buyNow',
      desc: '',
      args: [],
    );
  }

  /// `Overall`
  String get overall2 {
    return Intl.message(
      'Overall',
      name: 'overall2',
      desc: '',
      args: [],
    );
  }

  /// `Overall sum will be converted to US dollars`
  String get overllWillBeConverted {
    return Intl.message(
      'Overall sum will be converted to US dollars',
      name: 'overllWillBeConverted',
      desc: '',
      args: [],
    );
  }

  /// `By clicking on the Next button, you will be redirected to the Connectpay payment service, where you will complete the purchase`
  String get billingTagNew {
    return Intl.message(
      'By clicking on the Next button, you will be redirected to the Connectpay payment service, where you will complete the purchase',
      name: 'billingTagNew',
      desc: '',
      args: [],
    );
  }

  /// `Sign in or register`
  String get signInOrRegister {
    return Intl.message(
      'Sign in or register',
      name: 'signInOrRegister',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message(
      'Confirmed',
      name: 'confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Not confirmed`
  String get notConfirmed {
    return Intl.message(
      'Not confirmed',
      name: 'notConfirmed',
      desc: '',
      args: [],
    );
  }

  /// `Copied to clipboard`
  String get copiedToClipboard {
    return Intl.message(
      'Copied to clipboard',
      name: 'copiedToClipboard',
      desc: '',
      args: [],
    );
  }

  /// `From 18 years old`
  String get from18yo {
    return Intl.message(
      'From 18 years old',
      name: 'from18yo',
      desc: '',
      args: [],
    );
  }

  /// `Under 18 years old`
  String get under18yo {
    return Intl.message(
      'Under 18 years old',
      name: 'under18yo',
      desc: '',
      args: [],
    );
  }

  /// `Scan ticket`
  String get scanTicket {
    return Intl.message(
      'Scan ticket',
      name: 'scanTicket',
      desc: '',
      args: [],
    );
  }

  /// `Enter email`
  String get enterEmail {
    return Intl.message(
      'Enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter password`
  String get enterPassword {
    return Intl.message(
      'Enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get newMobile {
    return Intl.message(
      'Phone number',
      name: 'newMobile',
      desc: '',
      args: [],
    );
  }

  /// `To become a guide you need to:`
  String get toBecomeGuideNew {
    return Intl.message(
      'To become a guide you need to:',
      name: 'toBecomeGuideNew',
      desc: '',
      args: [],
    );
  }

  /// `Provide link to a profile in one of the social networks (with your tours information)`
  String get provideLink {
    return Intl.message(
      'Provide link to a profile in one of the social networks (with your tours information)',
      name: 'provideLink',
      desc: '',
      args: [],
    );
  }

  /// `Instagram, Facebook or Twitter`
  String get socialNetworkEx {
    return Intl.message(
      'Instagram, Facebook or Twitter',
      name: 'socialNetworkEx',
      desc: '',
      args: [],
    );
  }

  /// `No card`
  String get noCard {
    return Intl.message(
      'No card',
      name: 'noCard',
      desc: '',
      args: [],
    );
  }

  /// `I'd like to get my balance`
  String get getBalanceNew {
    return Intl.message(
      'I\'d like to get my balance',
      name: 'getBalanceNew',
      desc: '',
      args: [],
    );
  }

  /// `Confirm ticket`
  String get confirmTicket {
    return Intl.message(
      'Confirm ticket',
      name: 'confirmTicket',
      desc: '',
      args: [],
    );
  }

  /// `Ticket is canceled`
  String get ticketIsCanceled {
    return Intl.message(
      'Ticket is canceled',
      name: 'ticketIsCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Tourist has already used ticket`
  String get touristUsedTicket {
    return Intl.message(
      'Tourist has already used ticket',
      name: 'touristUsedTicket',
      desc: '',
      args: [],
    );
  }

  /// `Tourist hasn't used ticket yet`
  String get touristDidntUseTicket {
    return Intl.message(
      'Tourist hasn\'t used ticket yet',
      name: 'touristDidntUseTicket',
      desc: '',
      args: [],
    );
  }

  /// `You confirmed ticket`
  String get uConfirmedTicket {
    return Intl.message(
      'You confirmed ticket',
      name: 'uConfirmedTicket',
      desc: '',
      args: [],
    );
  }

  /// `Find city`
  String get findCity {
    return Intl.message(
      'Find city',
      name: 'findCity',
      desc: '',
      args: [],
    );
  }

  /// `Describe your tour`
  String get describeUrTour {
    return Intl.message(
      'Describe your tour',
      name: 'describeUrTour',
      desc: '',
      args: [],
    );
  }

  /// `Enter tour name`
  String get enterTourName {
    return Intl.message(
      'Enter tour name',
      name: 'enterTourName',
      desc: '',
      args: [],
    );
  }

  /// `Additional`
  String get additional {
    return Intl.message(
      'Additional',
      name: 'additional',
      desc: '',
      args: [],
    );
  }

  /// `Prepare in advance`
  String get prerequisitesNew {
    return Intl.message(
      'Prepare in advance',
      name: 'prerequisitesNew',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is included in tour?`
  String get enterIncluded2 {
    return Intl.message(
      'Enter what is included in tour?',
      name: 'enterIncluded2',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is not included in tour?`
  String get enterNotIncluded2 {
    return Intl.message(
      'Enter what is not included in tour?',
      name: 'enterNotIncluded2',
      desc: '',
      args: [],
    );
  }

  /// `Enter what is prohibited  on tour?`
  String get enterProhibs2 {
    return Intl.message(
      'Enter what is prohibited  on tour?',
      name: 'enterProhibs2',
      desc: '',
      args: [],
    );
  }

  /// `Enter a note or additional information`
  String get enterNotes2 {
    return Intl.message(
      'Enter a note or additional information',
      name: 'enterNotes2',
      desc: '',
      args: [],
    );
  }

  /// `Ticket price`
  String get ticketPrice {
    return Intl.message(
      'Ticket price',
      name: 'ticketPrice',
      desc: '',
      args: [],
    );
  }

  /// `Without commission`
  String get withoutComission {
    return Intl.message(
      'Without commission',
      name: 'withoutComission',
      desc: '',
      args: [],
    );
  }

  /// `Main photos`
  String get mainPhotos {
    return Intl.message(
      'Main photos',
      name: 'mainPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Can't launch Whatsapp!`
  String get cantLaunchWhatsapp {
    return Intl.message(
      'Can\'t launch Whatsapp!',
      name: 'cantLaunchWhatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Can't launch Viber!`
  String get cantLaunchViber {
    return Intl.message(
      'Can\'t launch Viber!',
      name: 'cantLaunchViber',
      desc: '',
      args: [],
    );
  }

  /// `Can't launch Telegram!`
  String get cantLaunchTelegram {
    return Intl.message(
      'Can\'t launch Telegram!',
      name: 'cantLaunchTelegram',
      desc: '',
      args: [],
    );
  }

  /// `There are no purchased tickets`
  String get noPurchasedTickets {
    return Intl.message(
      'There are no purchased tickets',
      name: 'noPurchasedTickets',
      desc: '',
      args: [],
    );
  }

  /// `You can apply to create a new tour`
  String get applyForTourTag {
    return Intl.message(
      'You can apply to create a new tour',
      name: 'applyForTourTag',
      desc: '',
      args: [],
    );
  }

  /// `Enter city or tour`
  String get enterCityOrTour {
    return Intl.message(
      'Enter city or tour',
      name: 'enterCityOrTour',
      desc: '',
      args: [],
    );
  }

  /// `No cities found`
  String get noCitiesFound {
    return Intl.message(
      'No cities found',
      name: 'noCitiesFound',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `You want to save draft?`
  String get wantSaveDraft {
    return Intl.message(
      'You want to save draft?',
      name: 'wantSaveDraft',
      desc: '',
      args: [],
    );
  }

  /// `No saved draft`
  String get noSavedDraft {
    return Intl.message(
      'No saved draft',
      name: 'noSavedDraft',
      desc: '',
      args: [],
    );
  }

  /// `Tour is not found`
  String get tourNotFound {
    return Intl.message(
      'Tour is not found',
      name: 'tourNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Sent`
  String get succesfullySent {
    return Intl.message(
      'Successfully Sent',
      name: 'succesfullySent',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'tr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
