import 'package:app_psy/dialog/creation_facture.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:path/path.dart';

import '../dialog/preview_pdf.dart';

class PageFactures extends StatelessWidget {
  const PageFactures({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ViewFactures();
  }

}

class ViewFactures extends StatefulWidget {
  const ViewFactures({Key? key}) : super(key: key);

  @override
  State<ViewFactures> createState() => _ViewFacturesState();
}

class _ViewFacturesState extends State<ViewFactures> with WidgetsBindingObserver {
  final _controllerChampRecherche = TextEditingController();
  late List<FileSystemEntity> fichiers;
  late List<FileSystemEntity> fichiersTrier = [];

  bool isLoading = false;
  String _selectionnerChips = "";

  @override
  void initState() {
    super.initState();

    _getListFiles();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Methode pour chaque retour a l'page de refresh
    if (state == AppLifecycleState.resumed) {
      _getListFiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed:() {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const FullScreenDialogCreationFacture(),
              fullscreenDialog: true,
            ),
          ).then((value) => _getListFiles());
        },
      ),
      body: SafeArea(
        child: isLoading ? const CircularProgressIndicator() : buildPageFacture()
      ),
    );
  }

  Widget buildPageFacture() {
    return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          top: 70,
          right: 20,
        ),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child :
              Text(
                "Mes factures",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),


          Flex(
            direction: Axis.vertical,
            children: [
              TextField(
                controller: _controllerChampRecherche,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recherche facture',
                    helperText: 'Essayer le nom du client ou bien sont prénoam'
                ),
                onChanged: (String? entree) => setState(() {
                  fichiersTrier = _sortParRecherche(entree) ?? [];

                }),
              ),
          ],),



           Row(
              children: [
                  FilterChip(
                    label: const Text("Mois actuel"),
                    selected: _selectionnerChips == "Mois actuel",
                    onSelected: (bool value) {
                        setState(() {
                          if(_selectionnerChips == "Mois actuel") {
                            _selectionnerChips = "";
                            _resetListFichierTrier();
                          } else {
                            _selectionnerChips = "Mois actuel";
                            fichiersTrier = _sort(true, false);
                          }

                        });
                     },
                  ),

                  FilterChip(
                    label: const Text("Année actuelle"),
                    selected: _selectionnerChips == "Année actuelle",
                    onSelected: (bool value) {
                      setState(() {
                        if(_selectionnerChips == "Année actuelle") {
                          _selectionnerChips = "";
                          _resetListFichierTrier();
                        } else {
                          _selectionnerChips = "Année actuelle";
                          fichiersTrier = _sort(false, true);
                        }
                      });
                    },
                  ),
              ],
            ),

          const Divider(),

          if (_checkSiUserTrie())
            for (FileSystemEntity f in fichiersTrier)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(basename(f.path)),
                  onTap: () => Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => PreviewPdf(fichier: File(f.path),))).then((value) => _getListFiles()),
                ),
              )
          else
            for (FileSystemEntity f in fichiers)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(basename(f.path)),
                  onTap: () => Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => PreviewPdf(fichier: File(f.path),))).then((value) => _getListFiles()),
                ),
              ),
        ]);
  }

  Future<void> _getListFiles() async {
    setState(() => isLoading = true);


    fichiers = await PdfApi.getAllFilesInCache();

    setState(() => isLoading = false);
  }

  List<FileSystemEntity> _sort(bool mois, bool annee) {
    _resetListFichierTrier();
    List<FileSystemEntity> listFinal = [];
    var now = DateTime.now();
    var formatterMounth = DateFormat('MM');
    var formatterYear = DateFormat('yyyy');
    if (mois) {
      String month = formatterMounth.format(now);
      String year = formatterYear.format(now);

      RegExp regex = RegExp("([$month]-[$year])");


      for (FileSystemEntity f in fichiers) {
        if (regex.firstMatch(basename(f.path)) != null) {
          listFinal.add(f);
        }
      }
    } else if (annee) {
      String year = formatterYear.format(now);
      RegExp regex = RegExp("([$year])");


      for (FileSystemEntity f in fichiers) {
        if (regex.firstMatch(basename(f.path)) != null) {
          listFinal.add(f);
        }
      }
    }

    return listFinal;
  }

  List<FileSystemEntity>? _sortParRecherche(String? entree) {
    if(entree == null) {
      return null;
    }
    _resetListFichierTrier();
    List<FileSystemEntity> listFinal = [];
    RegExp regex = RegExp(entree.toLowerCase());

    for (FileSystemEntity f in fichiers) {
      if (regex.firstMatch(basename(f.path).toLowerCase()) != null) {
        listFinal.add(f);
      }
    }

    return listFinal;
  }

  void _resetListFichierTrier() {
    fichiersTrier = [];
  }

  bool _checkSiUserTrie() {
    return _selectionnerChips.isNotEmpty || _controllerChampRecherche.text.isNotEmpty;
  }

}
