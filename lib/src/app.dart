import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:agri_manager/src/controller/LocaleProvider.dart';
import 'package:agri_manager/src/controller/menu_controller.dart';
import 'package:agri_manager/src/screens/base/park_screen.dart';
import 'package:agri_manager/src/screens/business/corp_manage_check_screen.dart';
import 'package:agri_manager/src/screens/business/purchase_order_screen.dart';
import 'package:agri_manager/src/screens/business/sale_order_screen.dart';
import 'package:agri_manager/src/screens/cms/blog_screen.dart';
import 'package:agri_manager/src/screens/cms/cms_category_screen.dart';
import 'package:agri_manager/src/screens/cms/manage_blog_screen.dart';
import 'package:agri_manager/src/screens/corp_dashbord/corp_dashboard.dart';
import 'package:agri_manager/src/screens/customer/contact_search_screen.dart';
import 'package:agri_manager/src/screens/customer/customer_screen.dart';
import 'package:agri_manager/src/screens/dashboard/dashboard_screen.dart';
import 'package:agri_manager/src/screens/login_signup/login.dart';
import 'package:agri_manager/src/screens/login_signup/login_auto.dart';
import 'package:agri_manager/src/screens/manage/corp/corp_query_screen.dart';
import 'package:agri_manager/src/screens/manage/depart/depart_query_screen.dart';
import 'package:agri_manager/src/screens/manage/manager/manager_query_screen.dart';
import 'package:agri_manager/src/screens/manage/menu/menu_screen.dart';
import 'package:agri_manager/src/screens/market/mark_product_market_screen.dart';
import 'package:agri_manager/src/screens/market/market_manage_screen.dart';
import 'package:agri_manager/src/screens/product/category_screen.dart';
import 'package:agri_manager/src/screens/product/product_screen.dart';
import 'package:agri_manager/src/screens/project/batch_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_screen.dart';
import 'package:agri_manager/src/screens/splash_screen.dart';
import 'package:agri_manager/src/settings/settings_view.dart';
import 'package:agri_manager/src/utils/constants.dart';
/// The Widget that configures your application
/// StatefulWidget.
class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({
    Key? key,
    this.savedThemeMode
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AdaptiveTheme(
      light: ThemeData.light().copyWith(scaffoldBackgroundColor: creamColor,
        canvasColor: snowColor,
        tabBarTheme: TabBarTheme(
            labelColor: Colors.pink[800],
            labelStyle: TextStyle(color: Colors.pink[800]), // color for text
            indicator: const UnderlineTabIndicator(
              // color for indicator (underline)
                borderSide: BorderSide(color: primaryColor)))),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => CustomMenuController(),
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
              '/loginAuto': (context) => const LoginAuto(),
              '/news': (context) => const BlogScreen(),
              '/market': (context) => const MarkProductMarketScreen(isShowBar: true,),
              '/manageMarket': (context) => const MarketManageScreen(),
              '/manager': (context) => const ManagerQueryScreen(),
              '/depart': (context) => const DepartQueryScreen(),
              '/menu': (context) => const MenuScreen(),
              '/setting': (context) => const SettingsView(),
              '/corpQuery': (context) => const CorpQueryScreen(),
              '/product': (context) => const ProductScreen(),
              '/category': (context) => const CategoryScreen(),
              '/customer': (context) => const CustomerScreen(),
              '/park': (context) => const ParkScreen(),
              '/contractSearch': (context) => const ContractSearchScreen(),
              '/project': (context) => const BatchProductScreen(),
              '/sale': (context) => const SaleOrderScreen(),
              '/purchase': (context) => const PurchaseOrderScreen(),
              '/finance': (context) => const FinanceExpenseScreen(),
              '/manageBlog': (context) => const ManageBlogScreen(),
              '/manageCmsCategory': (context) => const CmsCategoryScreen(),
              '/manageCheck': (context) => const CorpManageCheckScreen(),
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
