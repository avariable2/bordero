import 'package:app_psy/page/page_accueil.dart';
import 'package:app_psy/color_schemes.g.dart';
import 'package:app_psy/page/page_factures.dart';
import 'package:app_psy/page/page_information_praticien.dart';
import 'package:app_psy/page/page_parametres.dart';
import 'package:app_psy/page/presentation.dart';
import 'package:app_psy/utils/environment.dart';
import 'package:app_psy/utils/fire_auth.dart';
import 'package:app_psy/utils/firebase_options.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'model/infos_praticien.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  await SpUtil.getInstance();
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
        StreamProvider(create: (context) => context.read<FireAuth>().authStateChanges, initialData: null,),
      ],
      child: MaterialApp(
          title: "Bordero",
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('fr'), // French, no country code
          ],
          theme: ThemeData(
            colorScheme: darkColorScheme,
          ),
          home: const AuthWrapper()),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      //If the user is successfully Logged-In.
      if (SpUtil.haveKey(InfosPraticien.keyObjInfosPraticien) ?? false) {
        return const AppPsy();
      } else {
        return const FullScreenDialogInformationPraticien();
      }
    } else {
      //If the user is not Logged-In.
      return const PresentationPage();
    }
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
            selectedIcon: Icon(Icons.home_outlined),
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.description_outlined),
            icon: Icon(Icons.description),
            label: 'Factures',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt_long_outlined),
            icon: Icon(Icons.receipt_long),
            label: 'Devis',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings_outlined),
            icon: Icon(Icons.settings),
            label: 'Paramètres',
          )
        ],
      ),
      body: IndexedStack(index: currentPageIndex, children: pageList,),
    );
  }
}
