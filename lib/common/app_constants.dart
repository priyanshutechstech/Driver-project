import 'dart:io';

import '../db/app_database.dart';
import '../features/language/domain/models/language_listing_model.dart';

class AppConstants {
  static const String title = 'techtaxii';
  static const String baseUrl = 'https://taxi.techstecks.com/';
  static String firbaseApiKey = (Platform.isAndroid)
      ? "AIzaSyCrGkqE82upU2JeVvkJna6SvWEfIR3qjfc"
      : "ios firebase api key";
  static String firebaseAppId = (Platform.isAndroid)
      ? "1:881705936806:android:6e4a2f4f775f4bf9ad1167"
      : "ios firebase app id";
  static String firebasemessagingSenderId =
      (Platform.isAndroid) ? "881705936806" : "ios firebase sender id";
  static String firebaseProjectId =
      (Platform.isAndroid) ? "taxi-1d933" : "ios firebase project id";

  static String mapKey = (Platform.isAndroid)
      ? 'AIzaSyBL78YVfLK26y9t28QjL8IHoAkNCWoD_go'
      : 'ios map key';

  static const String stripPublishKey = '';

  static List<LocaleLanguageList> languageList = [
    LocaleLanguageList(name: 'English', lang: 'en'),
    LocaleLanguageList(name: 'Arabic', lang: 'ar'),
    LocaleLanguageList(name: 'Azerbaijani', lang: 'az'),
    LocaleLanguageList(name: 'French', lang: 'fr'),
    LocaleLanguageList(name: 'Spanish', lang: 'es'),
    LocaleLanguageList(name: 'Albanian', lang: 'sq'),
    LocaleLanguageList(name: 'Vietnamese', lang: 'vi'),
  ];
  static String packageName = '';
  static String signKey = '';
}

bool showBubbleIcon = false;
bool subscriptionSkip = false;
String choosenLanguage = 'en';
String mapType = '';
bool isAppMapChange = false;

AppDatabase db = AppDatabase();
