import 'package:app_psy/model/theme_settings.dart';
import 'package:app_psy/page/page_accueil.dart';
import 'package:app_psy/color_schemes.g.dart';
import 'package:app_psy/page/page_factures.dart';
import 'package:app_psy/page/page_information_praticien.dart';
import 'package:app_psy/page/page_parametres.dart';
import 'package:app_psy/page/presentation.dart';
import 'package:app_psy/utils/environment.dart';
import 'package:app_psy/utils/fire_auth.dart';
import 'package:app_psy/utils/firebase_options.dart';
import 'package:app_psy/utils/infos_utilisateur_parametres.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:app_psy/utils/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const PageFactures(),
    Container(
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text('Page 3'),
    ),
    const PageParametres(),
  ];

  // TODO(https://codelabs.developers.google.com/codelabs/material-motion-flutter?hl=fr#4)
  // Animation

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.description),
            icon: Icon(Icons.description_outlined),
            label: 'Factures',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long),
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Devis',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings_outlined),
            label: 'Paramètres',
          )
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: pageList,
      ),
    );
  }
}
