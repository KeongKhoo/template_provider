import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:template_provider/helper/responsive_helper.dart';
import 'package:template_provider/localization/language_constrants.dart';
import 'package:template_provider/provider/splash_provider.dart';
import 'package:template_provider/util/app_constants.dart';
import 'package:template_provider/util/images.dart';
import 'package:template_provider/util/routes.dart';
import 'package:template_provider/util/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();
    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : _globalKey.currentState.hideCurrentSnackBar();
        _globalKey.currentState.showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', _globalKey.currentContext)
                : getTranslated('connected', _globalKey.currentContext),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      } else {
        _route();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Navigator.pushNamedAndRemoveUntil(
        context,
        AppConstants.languages.length > 1
            ? Routes.getLanguageRoute('splash')
            : Routes.getOnBoardingRoute(),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Center(
        child: Consumer<SplashProvider>(builder: (context, splash, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ResponsiveHelper.isWeb()
                  ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholder_rectangle,
                      height: 165,
                      // image: splash.baseUrls != null
                      //     ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}'
                      //     : '',
                      imageErrorBuilder: (c, o, s) => Image.asset(
                          Images.placeholder_rectangle,
                          height: 165),
                    )
                  : Image.asset(Images.logo, height: 150),
              SizedBox(height: 30),
              Text(
                // ResponsiveHelper.isWeb()
                //     ? splash.configModel.restaurantName
                //     :
                AppConstants.APP_NAME,
                style: rubikBold.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 30),
              ),
            ],
          );
        }),
      ),
    );
  }
}
