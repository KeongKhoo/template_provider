import 'package:fluro/fluro.dart';
import 'package:template_provider/util/routes.dart';
import 'package:template_provider/view/base/not_found.dart';
import 'package:template_provider/view/screen/dashboard/dashboard_screen.dart';
import 'package:template_provider/view/screen/language/choose_language_screen.dart';
import 'package:template_provider/view/screen/onboarding/onboarding_screen.dart';
import 'package:template_provider/view/screen/splash/splash_screen.dart';

class RouterHelper {
  static final FluroRouter router = FluroRouter();

//*******Handlers*********
  static Handler _notFoundHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => NotFound());

  static Handler _splashHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) => SplashScreen());

  static Handler _languageHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return ChooseLanguageScreen(fromMenu: params['page'][0] == 'menu');
  });

  static Handler _onbordingHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          OnBoardingScreen());

  static Handler _dashboardHandler =
      Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return DashboadrdScreen(
      pageIndex: 0,
    );
  });

//*******Route Define*********
  static void setupRoute() {
    router.notFoundHandler = _notFoundHandler;
    router.define(Routes.SPLASH_SCREEN,
        handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.ONBOARDING_SCREEN,
        handler: _onbordingHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.LANGUAGE_SCREEN,
        handler: _languageHandler, transitionType: TransitionType.fadeIn);
    router.define(Routes.DASHBOARD,
        handler: _dashboardHandler, transitionType: TransitionType.fadeIn);
  }
}
