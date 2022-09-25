import 'package:animations/animations.dart';
import 'package:bordero/color_schemes.g.dart';
import 'package:bordero/model/theme_settings.dart';
import 'package:bordero/page/page_accueil.dart';
import 'package:bordero/page/page_document.dart';
import 'package:bordero/page/page_information_praticien.dart';
import 'package:bordero/page/page_parametres.dart';
import 'package:bordero/page/presentation.dart';
import 'package:bordero/utils/environment.dart';
import 'package:bordero/utils/fire_auth.dart';
import 'package:bordero/utils/firebase_options.dart';
import 'package:bordero/utils/infos_utilisateur_parametres.dart';
import 'package:bordero/utils/pdf_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PdfApi.deleteAllFilesInCache();
  await SentryFlutter.init(
    (options) => options.dsn = Environment.SENTRY_DSN,
    appRunner: () => runApp(const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  static const String keyUserEstCo = "USER_EST_CO";

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FireAuth>(
          create: (_) => FireAuth(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeSettings(),
        ),
        StreamProvider(
          create: (context) => context.read<FireAuth>().authStateChanges,
          initialData: null,
        ),
      ],
      child: Consumer<ThemeSettings>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
              title: "Bordero",
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('fr'), // French, no country code
              ],
              theme: value.darkTheme ? darkTheme : lightTheme,
              home: const AuthWrapper());
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return const UtilisateurWrapper();
    } else {
      //If the user is not Logged-In.
      return const PresentationPage();
    }
  }
}

class UtilisateurWrapper extends StatelessWidget {
  const UtilisateurWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => InfosUtilisateurParametres(),
          ),
        ],
        child: Consumer<InfosUtilisateurParametres>(
          builder: (context, value, child) {
            return value.aSetParametres
                ? const AppPsy()
                : const FullScreenDialogInformationPraticien(firstTime: true);
          },
        ));
  }
}

class AppPsy extends StatefulWidget {
  const AppPsy({Key? key}) : super(key: key);

  @override
  State<AppPsy> createState() => _AppPsyState();
}

class _AppPsyState extends State<AppPsy> {
  int currentPageIndex = 0;
  List<Widget> pageList = [
    const PageAccueil(),
    const PageFacturesDevis(),
    const PageParametres(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        currentIndex: currentPageIndex,
        items: const [
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.description),
            icon: Icon(Icons.description_outlined),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          ),
        ],
      ),
      body: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> primaryAnimation,
                Animation<double> secondaryAnimation) =>
            FadeThroughTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                child: child),
        child: pageList[currentPageIndex],
      ),
    );
  }
}
