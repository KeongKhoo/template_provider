import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:template_provider/helper/responsive_helper.dart';
import 'package:template_provider/helper/router_helper.dart';
import 'package:template_provider/localization/app_localization.dart';
import 'package:template_provider/provider/localization_provider.dart';
import 'package:template_provider/provider/onboarding_provider.dart';
import 'package:template_provider/provider/splash_provider.dart';
import 'package:template_provider/provider/theme_provider.dart';
import 'package:template_provider/theme/dark_theme.dart';
import 'package:template_provider/theme/light_theme.dart';
import 'package:template_provider/util/app_constants.dart';
import 'package:template_provider/util/routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'di_container.dart' as di;
import 'provider/language_provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
    FlutterLocalNotificationsPlugin();

AndroidNotificationChannel channel;

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = new MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  try {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.high,
      );
      final RemoteMessage remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      // if (remoteMessage != null) {
      //   _orderID = remoteMessage.notification.titleLocKey != null
      //       ? int.parse(remoteMessage.notification.titleLocKey)
      //       : null;
      // }
      // await MyNotification.initialize(flutterLocalNotificationsPlugin);
      // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
      // await flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         AndroidFlutterLocalNotificationsPlugin>()
      //     ?.createNotificationChannel(channel);
      // }
    }
  } catch (e) {}

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => di.sl<ThemeProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<LanguageProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<OnBoardingProvider>()),
      ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
      ChangeNotifierProvider(
          create: (context) => di.sl<LocalizationProvider>()),
    ],
    child: MyApp(
      isWeb: !kIsWeb,
    ),
  ));
}

class MyApp extends StatefulWidget {
  final bool isWeb;

  const MyApp({Key key, @required this.isWeb}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    RouterHelper.setupRoute();

    if (kIsWeb) {
      print('using web');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Locale> _locals = [];
    AppConstants.languages.forEach((language) {
      _locals.add(Locale(language.languageCode, language.countryCode));
    });

    return Consumer<SplashProvider>(
      builder: (context, splashProvider, child) {
        return MaterialApp(
          initialRoute: Routes.getSplashRoute(),
          onGenerateRoute: RouterHelper.router.generator,
          title: AppConstants.APP_NAME,
          debugShowCheckedModeBanner: false,
          theme: Provider.of<ThemeProvider>(context).darkTheme ? dark : light,
          locale: Provider.of<LocalizationProvider>(context).locale,
          localizationsDelegates: [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          supportedLocales: _locals,
          scrollBehavior: MaterialScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.unknown,
          }),
        );
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
