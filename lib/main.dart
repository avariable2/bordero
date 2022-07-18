import 'package:app_psy/page/page_accueil.dart';
import 'package:app_psy/color_schemes.g.dart';
import 'package:app_psy/page/page_factures.dart';
import 'package:app_psy/page/page_parametres.dart';
import 'package:app_psy/page/presentation.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

//TODO("Si il n'est pas possible de garder les factures dans le cache alors les supprimer" = PdfApi.deleteAllFilesInCache());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  static const String keyUserEstCo = "USER_EST_CO";
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppPsy();
  }
}

class AppPsy extends StatefulWidget {
  const AppPsy({Key? key}) : super(key: key);

  @override
  State<AppPsy> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<AppPsy> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (SpUtil.haveKey(MyApp.keyUserEstCo) != null && SpUtil.getBool(MyApp.keyUserEstCo, defValue: false)!) {
      result = buildApp();
    } else {
      result = buildOnBoadring();
    }

    //result = buildApp();

    return MaterialApp(
        title: "Bordero",
        theme: ThemeData(
          colorScheme: darkColorScheme,
        ),
        home: result,
    );
  }

  Widget buildOnBoadring() {
    return const PresentationPage();
  }

  Widget buildApp() {
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
          body: <Widget>[
            const PageAccueil(),
            const PageFactures(),
            Container(
              color: Colors.blue,
              alignment: Alignment.center,
              child: const Text('Page 3'),
            ),
            const PageParametres(),
          ][currentPageIndex],
        );
  }
}
