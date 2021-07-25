//region imports
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/cloudStorage/model/CSDataModel.dart';
//import 'package:prokit_flutter/main/screens/AppSplashScreen.dart';
//import 'package:prokit_flutter/defaultTheme/screen/DTWalkThoughScreen.dart';
import 'package:prokit_flutter/main/store/AppStore.dart';
import 'package:prokit_flutter/main/utils/AppTheme.dart';
import 'package:prokit_flutter/routes.dart';

import 'JobTune/gig-guest/views/index/views/JTDashboardScreenGuest.dart';
import 'JobTune/gig-service/views/index/JTDashboardScreenUser.dart';
import 'main/utils/AppConstant.dart';
import 'muvi/utils/flix_app_localizations.dart';


/// This variable is used to get dynamic colors when theme mode is changed
AppStore appStore = AppStore();

List<CSDataModel> getCloudboxList = getCloudboxData();
List<CSDrawerModel> getCSDrawerList = getCSDrawer();
int currentIndex = 0;

void main() async {
  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  if (isMobile) {
    await Firebase.initializeApp();
    MobileAds.instance.initialize();

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  runApp(MyApp());
  //endregion
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          MuviAppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportedLocales) =>
            Locale(appStore.selectedLanguage),
        locale: Locale(appStore.selectedLanguage),
        supportedLocales: [Locale('en', '')],
        routes: routes(),
        title: '$mainAppName${!isMobile ? ' ${platformName()}' : ''}',
//        home: DTWalkThoughScreen(),
        home: JTDashboardScreenGuest(),
        theme: !appStore.isDarkModeOn
            ? AppThemeData.lightTheme
            : AppThemeData.darkTheme,
        builder: scrollBehaviour(),
      ),
    );
  }
}