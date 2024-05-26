import 'package:flutter_app/resources/pages/bottomnavi_page/searching_page.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';
import 'package:flutter_app/resources/pages/main_screen.dart';

import '/resources/pages/home_page.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* App Router
|--------------------------------------------------------------------------
| * [Tip] Create pages faster 🚀
| Run the below in the terminal to create new a page.
| "dart run nylo_framework:main make:page profile_page"
| Learn more https://nylo.dev/docs/5.20.0/router
|-------------------------------------------------------------------------- */

appRouter() => nyRoutes((router) {
      router.route(HomePage.path, (context) => HomePage(), initialRoute: true);
      router.route(HomePageUser.path, (context) => HomePageUser());
      router.route(MainScreen.path, (context) => MainScreen());
      // Add your routes here

      // router.route(NewPage.path, (context) => NewPage(), transition: PageTransitionType.fade);

      // Example using grouped routes
      // router.group(() => {
      //   "route_guards": [AuthRouteGuard()],
      //   "prefix": "/dashboard"
      // }, (router) {
      //
      //   router.route(AccountPage.path, (context) => AccountPage());
      // });
    });
