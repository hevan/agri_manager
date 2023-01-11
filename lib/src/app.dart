import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:znny_manager/src/controller/LocaleProvider.dart';
import 'package:znny_manager/src/controller/menu_controller.dart';
import 'package:znny_manager/src/screens/corp_dashbord/corp_dashboard.dart';
import 'package:znny_manager/src/screens/dashboard/dashboard_screen.dart';
import 'package:znny_manager/src/screens/login_signup/login.dart';
import 'package:znny_manager/src/screens/manage/corp/corp_query_screen.dart';
import 'package:znny_manager/src/screens/manage/depart/depart_query_screen.dart';
import 'package:znny_manager/src/screens/manage/manager/manager_query_screen.dart';
import 'package:znny_manager/src/screens/manage/menu/menu_screen.dart';
import 'package:znny_manager/src/screens/product/product_screen.dart';
import 'package:znny_manager/src/screens/splash_screen.dart';
import 'package:znny_manager/src/settings/settings_view.dart';
import 'package:znny_manager/src/utils/constants.dart';

/// The Widget that configures your application
/// StatefulWidget.
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(
          scaffoldBackgroundColor: creamColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black, fontSizeFactor: 1.1),
          canvasColor: snowColor,
          tabBarTheme: TabBarTheme(
              labelColor: Colors.pink[800],
              labelStyle: TextStyle(color: Colors.pink[800]), // color for text
              indicator: const UnderlineTabIndicator(
                  // color for indicator (underline)
                  borderSide: BorderSide(color: primaryColor)))),
      dark: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white, fontSizeFactor: 1.1),
        canvasColor: secondaryColor,
      ),
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => MenuController(),
            ),
            ChangeNotifierProvider(
              create: (context) => LocaleProvider(),
            ),
          ],
          child: MaterialApp(
            // Providing a restorationScopeId allows the Navigator built by the
            // MaterialApp to restore the navigation stack when a user leaves and
            // returns to the app after it has been killed while running in the
            // background.
            restorationScopeId: 'app',
            builder: EasyLoading.init(),
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) => const DashboardScreen(),
              '/managerDashboard': (context) => const CorpDashboardScreen(),
              '/login': (context) => const Login(),
              '/manager': (context) => const ManagerQueryScreen(),
              '/depart': (context) => const DepartQueryScreen(),
              '/menu': (context) => const MenuScreen(),
              '/setting': (context) => const SettingsView(),
              '/corpQuery': (context) => const CorpQueryScreen(),
              '/product': (context) => const ProductScreen(),
            },

            // Provide the generated AppLocalizations to the MaterialApp. This
            // allows descendant Widgets to display the correct translations
            // depending on the user's locale.
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
              Locale('zh', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            // Define a light and dark color theme. Then, read the user's
            // preferred ThemeMode (light, dark, or system default) from the
            // SettingsController to display the correct theme.
            theme: theme,
            darkTheme: darkTheme,
            debugShowCheckedModeBanner: false,

            // Define a function to handle named routes in order to support
            // Flutter web url navigation and deep linking.
          )),
    );
  }
}
