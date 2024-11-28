import 'package:flutter_app/login_page.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/resources/pages/main_screen.dart';

import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(
        MainScreen.path,
        (context) => MainScreen(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: const PageTransitionSettings(),
      );
      router.route(
        LoginPage.path,
        (context) => LoginPage(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: const PageTransitionSettings(),
      );
      router.route(
        SplashScreen.path,
        (context) => SplashScreen(),
        transition: PageTransitionType.bottomToTop,
        pageTransitionSettings: const PageTransitionSettings(),
      );
    });
