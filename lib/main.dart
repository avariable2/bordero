import 'package:app_psy/page/page_accueil.dart';
import 'package:app_psy/color_schemes.g.dart';
import 'package:app_psy/page/page_factures.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
  PdfApi.deleteAllFilesInCache();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Caleum",
        theme: ThemeData(
          colorScheme: darkColorScheme,
        ),

        home: const NavigationExample()
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

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
            selectedIcon: Icon(Icons.settings_sharp),
            icon: Icon(Icons.settings_outlined),
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
        Container(
          color: Colors.yellow,
          alignment: Alignment.center,
          child: const Text('Page 4'),
        ),
      ][currentPageIndex],
    );
  }
}
