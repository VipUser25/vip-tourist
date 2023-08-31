import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbauth;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:vip_tourist/logic/models/custom_return.dart';
import 'package:vip_tourist/logic/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthProvider with ChangeNotifier {
  UserModel user = UserModel.empty;
  late final FirebaseAuth? firebaseAuth;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  bool _isAuth = false;
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  AuthProvider() {
    firebaseAuth = FirebaseAuth.instance;
    FirebaseAuth.instance.authStateChanges().listen((User? userF) async {
      if (userF == null) {
        user = UserModel.empty;
        print('User is currently signed out!');

        _isAuth = false;
      } else {
        user = await userF.toUser;

        print('User is signed in!');
        _isAuth = true;
      }
    });
    notifyListeners();
  }

  bool get isAuth {
    return _isAuth;
  }

  Future<void> updateUser() async {
    User? userQ = FirebaseAuth.instance.currentUser;
    user = await userQ!.toUser;
    notifyListeners();
  }

  Future<String> signUp(
      {required String email,
      required String password,
      required bool receiveTips,
      required bool isTourist,
      required Locale locale}) async {
    int? val;
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _isAuth = true;
      notifyListeners();
      verifyEmail();
      val = await registrateUser(
          userCredential: userCredential,
          isTourist: isTourist,
          receiveTips: receiveTips,
          localeCode: locale);
    } on FirebaseAuthException catch (e) {
      _isAuth = false;
      notifyListeners();
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return 'weak-password';
      } else if (e.code == 'email-already-in-use' || val == 400) {
        print('The account already exists for that email.');
        return 'email-already-in-use';
      } else if (val != 201) {
        return 'error';
      }
    } catch (e) {
      print(e);
    }

    return 'no';
  }

  Future<void> verifyEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<String> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final tempUser = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (tempUser.user!.emailVerified) {
        _isAuth = true;
        notifyListeners();
        print('AUTHENTICATED!!');

        return 'no';
      } else {
        _isAuth = false;
        notifyListeners();
        print('UNAUTHENTICATED!!');

        return 'email-not-verified';
      }
    } on FirebaseAuthException catch (e) {
      print('UNAUTHENTICATED!!');
      _isAuth = false;
      notifyListeners();
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'user-not-found';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'wrong-password';
      }
    }

    return 'no';
  }

  Future<CustomReturn> logInWithGoogle() async {
    String? vap;
    UserCredential userCredential;

    try {
      final googleUser = await googleSignIn.signIn().catchError((error) {
        print("GOOGLE AUTH PROBLEM IS");
        print(error);
      });
      print("LOOKING FOR ERROR...");
      print(googleUser?.email);
      final googleAuth = await googleUser?.authentication;
      final credential = fbauth.GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      User? userQ = userCredential.user;

      _isAuth = true;
      notifyListeners();

      vap = await doesUserExist(userCredential.user!.uid);
      print("LOOKING FOR ERROR...");

      return CustomReturn(
          error: vap,
          email: userQ!.email,
          name: userQ.displayName,
          number: userQ.phoneNumber,
          uid: userQ.uid,
          photo: userQ.photoURL);
    } on Exception {
      _isAuth = false;
      notifyListeners();
      return CustomReturn(
          email: '', name: '', error: 'error', number: '', uid: '', photo: '');
    }
  }

  Future<CustomReturn> logInWithApple() async {
    String? vap;
    UserCredential userCredential;

    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );
      userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      User? userQ = userCredential.user;

      _isAuth = true;
      notifyListeners();

      vap = await doesUserExist(userCredential.user!.uid);
      print("LOOKING FOR ERROR...");

      return CustomReturn(
          error: vap,
          email: userQ!.email,
          name: userQ.displayName,
          number: userQ.phoneNumber,
          uid: userQ.uid,
          photo: userQ.photoURL);
    } on Exception {
      _isAuth = false;
      notifyListeners();
      return CustomReturn(
          email: '', name: '', error: 'error', number: '', uid: '', photo: '');
    }
  }

  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future signOut() async {
    firebaseAuth!.signOut();
    googleSignIn.signOut();
    user = UserModel.empty;
    _isAuth = false;

    notifyListeners();
    print('LOGED OUT');
    return Future.delayed(Duration.zero);
  }

  Future<String> doesUserExist(String uid) async {
    var url = Uri.parse("$CONST_URL/profiles/$uid");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return 'EXISTS!';
    } else if (response.statusCode == 404) {
      return 'user-not-found';
    } else {
      return 'error';
    }
  }

  Future<int> registrateUser(
      {required UserCredential userCredential,
      required bool receiveTips,
      required bool isTourist,
      required Locale localeCode}) async {
    String locale = "en";
    if (localeCode.languageCode.contains("en")) {
      locale = "en";
    } else if (localeCode.languageCode.contains("ru")) {
      locale = "ru-RU";
    } else if (localeCode.languageCode.contains("ar")) {
      locale = "ar-AE";
    } else if (localeCode.languageCode.contains("de")) {
      locale = "de-DE";
    } else if (localeCode.languageCode.contains("es")) {
      locale = "es-ES";
    } else if (localeCode.languageCode.contains("fr")) {
      locale = "fr-FR";
    } else if (localeCode.languageCode.contains("it")) {
      locale = "it-IT";
    } else if (localeCode.languageCode.contains("th")) {
      locale = "th-TH";
    } else if (localeCode.languageCode.contains("tr")) {
      locale = "tr-TR";
    } else {
      locale = "en";
    }
    User? userT = userCredential.user;
    var url = Uri.parse('$CONST_URL/profiles');
    String? vapidKey = await FirebaseMessaging.instance.getToken();
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "uid": userT!.uid,
          "email": userT.email,
          "name": userT.displayName,
          "phone_number": userT.phoneNumber,
          "is_tourist": isTourist,
          "is_verified": false,
          "get_promo": receiveTips,
          "locale": locale,
          "fcm_token": vapidKey ?? ""
        },
      ),
    );
    print("ERROR FIXING LOOKING:");
    print(isTourist);
    return response.statusCode;
  }

  Future<int> registrateUser2(
      {required String uid,
      required String email,
      required String name,
      required String number,
      required bool receiveTips,
      required bool isTourist,
      required String photo,
      required Locale localeCode}) async {
    String locale = "en";
    if (localeCode.languageCode.contains("en")) {
      locale = "en";
    } else if (localeCode.languageCode.contains("ru")) {
      locale = "ru-RU";
    } else if (localeCode.languageCode.contains("ar")) {
      locale = "ar-AE";
    } else if (localeCode.languageCode.contains("de")) {
      locale = "de-DE";
    } else if (localeCode.languageCode.contains("es")) {
      locale = "es-ES";
    } else if (localeCode.languageCode.contains("fr")) {
      locale = "fr-FR";
    } else if (localeCode.languageCode.contains("it")) {
      locale = "it-IT";
    } else if (localeCode.languageCode.contains("th")) {
      locale = "th-TH";
    } else if (localeCode.languageCode.contains("tr")) {
      locale = "tr-TR";
    } else {
      locale = "en";
    }
    var url = Uri.parse('$CONST_URL/profiles');
    String? vapidKey = await FirebaseMessaging.instance.getToken();
    var response = await http.post(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode({
        "uid": uid,
        "email": email,
        "name": name,
        "phone_number": number,
        "is_tourist": isTourist,
        "is_verified": false,
        "get_promo": receiveTips,
        "photo_url": photo,
        "locale": locale,
        "fcm_token": vapidKey ?? ""
      }),
    );
    return response.statusCode;
  }

  Future<void> setProfileUpdated() async {
    String currentId = user.idd!;
    var url = Uri.parse("$CONST_URL/profiles/$currentId");
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "profileUpdated": "true",
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
  }

  Future<bool> sendSocialLink(String link) async {
    bool isGood = false;
    String currentId = user.id!;
    var url = Uri.parse("$CONST_URL/profiles/$currentId");
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "socialLink": link,
        },
      ),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      isGood = true;
    }
    return isGood;
  }

  Future<int> updateNamePhone(String name, String number, bool hasWhatsapp,
      bool hasViber, bool hasTelegram) async {
    String currentId = user.getIdd!;

    var url = Uri.parse("$CONST_URL/profiles/$currentId");
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "name": name,
          "phone_number": number,
          "hasWhatsapp": hasWhatsapp,
          "hasViber": hasViber,
          "hasTelegram": hasTelegram
        },
      ),
    );
    user.setName(name);
    user.setPhoneNumber(number);
    return response.statusCode;
  }

  Future<int> updatePhoto(String result) async {
    final ImagePicker _picker = ImagePicker();
    final file;
    XFile? img;
    if (result == 'Gallery') {
      img = await _picker.pickImage(source: ImageSource.gallery);
    } else if (result == 'Camera') {
      img = await _picker.pickImage(source: ImageSource.camera);
    }

    if (img != null) {
      file = File(img.path);

      String currentId = user.getIdd!;
      var url = Uri.parse("$CONST_URL/profiles/$currentId");

      final data =
          Cloudinary(CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUD_NAME);

      final response = await data.uploadFile(
        filePath: file.path,
        resourceType: CloudinaryResourceType.image,
      );
      if (response.statusCode == 200) {
        var resp = await http.put(
          url,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode(
            {"photo_url": response.url},
          ),
        );
        return resp.statusCode;
      } else {
        return response.statusCode!;
      }
    } else {
      return 999;
    }
  }

  Future<int> deletePhotoRequest() async {
    String id = user.getIdd!;
    print("USER IDD BELLOW!");
    print(id);
    var url = Uri.parse("$CONST_URL/profiles/$id");
    var response = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {"photo_url": ""},
      ),
    );
    return response.statusCode;
  }

  Future<String> getUserPhotoURL() async {
    String temp;
    String uid = user.getUid;
    var url = Uri.parse("$CONST_URL/profiles/$uid");
    var response = await http.get(url);
    final body = jsonDecode(response.body);
    temp = body["photo_url"] ?? "";
    return temp;
  }

  Future<bool> becomeTourist() async {
    bool temp = true;
    String currentId = user.id ?? " ";
    List<String> empty = ["no url"];
    print("becoming tourist...");
    print(currentId);

    var url = Uri.parse("$CONST_URL/profiles/$currentId");
    var resp = await http.put(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
      body: jsonEncode(
        {
          "documents_urls": {
            "urls": ["no url"]
          },
          "is_tourist": true,
          "is_verified": false
        },
      ),
    );
    print(resp.statusCode);
    if (resp.statusCode != 200) {
      temp = false;
    }
    return temp;
  }

  Future<int> verifyUser(List<String> list) async {
    if (list.isNotEmpty) {
      String currentId = user.getIdd!;

      final data =
          Cloudinary(CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET, CLOUD_NAME);

      List<CloudinaryResponse> responses = await data.uploadFiles(
        filePaths: list,
        resourceType: CloudinaryResourceType.image,
      );
      List<String> paths = [];
      bool noError = true;
      responses.forEach((element) {
        if (element.statusCode == 200) {
          paths.add(element.url!);
        } else {
          noError = false;
        }
      });
      if (noError) {
        var url = Uri.parse("$CONST_URL/profiles/$currentId");
        var resp = await http.put(
          url,
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
          body: jsonEncode(
            {
              "documents_urls": {"urls": paths},
              "is_tourist": false
            },
          ),
        );
        return resp.statusCode;
      } else {
        return 400;
      }
    } else {
      return 999;
    }
  }

  Future<UserModel> getUser() async {
    UserModel tempModel;
    String uid = user.getUid;

    String email = user.getEmail!;
    if (uid.isEmpty) {
      tempModel = UserModel.empty;
    } else {
      var url = Uri.parse("$CONST_URL/profiles/$uid");
      var response = await http.get(url);

      var body = jsonDecode(response.body);
      print(body);
      tempModel = UserModel(
        haveDocuments: haveDocuments(body["documents_urls"] ?? {"urls": []}),
        balance: body["balance"].toString(),
        uid: uid,
        email: email,
        name: body["name"],
        photo: body["photo_url"],
        hasTelegram: body["hasTelegram"],
        hasViber: body["hasViber"],
        hasWhatsapp: body["hasWhatsapp"],
        phoneNumber: body["phone_number"],
        getPromo: body["get_promo"] ?? false,
        isTourist: body["is_tourist"] ?? true,
        isVerified: body["is_verified"] ?? false,
      );
    }

    return tempModel;
  }

  Future<void> refreshFcm() async {
    String? fcm = await FirebaseMessaging.instance.getToken();

    String? id = user.id;

    if (id != null) {
      if (fcm != null) {
        var url = Uri.parse("$CONST_URL/profiles/$id");
        var response = await http.put(
          url,
          body: jsonEncode(
            {"fcm_token": fcm},
          ),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json"
          },
        );
        print("REFRESHED FCM TOKEN RESULT");
        print(response.statusCode);
      }
    }
  }

  bool haveDocuments(Map<String, dynamic> data) {
    bool temp = false;
    try {
      print("COUNTING DOCS...");
      List<dynamic> qqq = data["urls"]! as List<dynamic>;
      if (qqq.length > 0) {
        temp = true;
      }
    } catch (e) {}

    return temp;
  }

  Future<bool> haveOffers() async {
    String id = user.uid;
    bool havePred = true;
    var url = Uri.parse("$CONST_URL/profiles/$id");
    var response = await http.get(
      url,
      headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      },
    );
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 202 ||
        response.statusCode == 203) {
      dynamic bdy = jsonDecode(response.body) as dynamic;
      List<dynamic> list = bdy["tours"] as List<dynamic>;
      print("CHECKING PREDOHRANITEL");
      print(list);

      if (list.isEmpty) {
        havePred = false;
      }
    }

    return havePred;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

extension on fbauth.User {
  Future<UserModel> get toUser async {
    final CustomResponse response = await getUserFromBack();
    final body = response.body;
    if (response.hasData) {
      return UserModel(
        uid: uid,
        email: email!,
        name: body!["name"],
        photo: body["photo_url"],
        phoneNumber: body["phone_number"],
        getPromo: body["get_promo"] ?? false,
        isTourist: body["is_tourist"],
        isVerified: body["is_verified"],
        hasTelegram: body["hasTelegram"],
        hasViber: body["hasViber"],
        hasWhatsapp: body["hasWhatsapp"],
        idd: body["id"],
        balance: body["balance"].toString(),
        haveDocuments: haveDocuments(
          body["documents_urls"] ?? {"urls": []},
        ),
      );
    } else {
      return UserModel(
          uid: uid,
          email: email!,
          name: displayName,
          phoneNumber: phoneNumber,
          photo: photoURL,
          balance: "0.0",
          hasTelegram: false,
          hasViber: false,
          hasWhatsapp: false,
          haveDocuments: false);
    }
  }

  Future<CustomResponse> getUserFromBack() async {
    var url = Uri.parse("$CONST_URL/profiles/$uid");
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "charset": "utf-8"
    });
    if (response.statusCode != 200) {
      return CustomResponse(hasData: false);
    } else {
      return CustomResponse(hasData: true, body: jsonDecode(response.body));
    }
  }

  bool haveDocuments(Map<String, dynamic> data) {
    bool temp = false;
    try {
      print("COUNTING DOCS...");
      List<dynamic> qqq = data["urls"]! as List<dynamic>;
      if (qqq.length > 0) {
        temp = true;
      }
    } catch (e) {}

    return temp;
  }
}

class CustomResponse {
  final bool hasData;
  final Map<String, dynamic>? body;

  CustomResponse({required this.hasData, this.body});
}
