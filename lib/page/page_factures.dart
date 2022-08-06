import 'dart:typed_data';

import 'package:app_psy/dialog/creation_facture.dart';
import 'package:app_psy/model/facture.dart';
import 'package:app_psy/utils/app_psy_utils.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../db/app_psy_database.dart';
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

class _ViewFacturesState extends State<ViewFactures> {
  final _controllerChampRecherche = TextEditingController();
  late List<Facture> facturesTrier = [];
  late List<Facture> factures = [];

  bool isLoading = false;
  String _selectionnerChips = "";

  @override
  void initState() {
    super.initState();

    _getListFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) =>
                  const FullScreenDialogCreationFacture(),
              fullscreenDialog: true,
            ),
          ).then((value) => _getListFiles());
        },
      ),
      body: SafeArea(
          child: isLoading
              ? const CircularProgressIndicator()
              : buildPageFacture()),
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
            child: Text(
              "Mes factures",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          buildRecherche(),
          buildChipsRechercheAvancer(),
          const Divider(),
          buildListFactures(),
        ]);
  }

  Widget buildRecherche() {
    return Flex(
      direction: Axis.vertical,
      children: [
        TextField(
          controller: _controllerChampRecherche,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _controllerChampRecherche.clear();
                    facturesTrier = [];
                  });
                } ,
                color: _controllerChampRecherche.text.isNotEmpty
                    ? Colors.grey
                    : Colors.transparent,
                icon: const Icon(Icons.clear),
              ),
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
              labelText: 'Recherche facture',
              helperText: 'Essayer le nom du client ou son prénom'),
          onChanged: (String? entree) => setState(() {
            facturesTrier = _sortParRecherche(entree) ?? [];
          }),
        ),
      ],
    );
  }

  Widget buildChipsRechercheAvancer() {
    return Row(
      children: [
        FilterChip(
          label: const Text("Mois actuel"),
          selected: _selectionnerChips == "Mois actuel",
          onSelected: (bool value) {
            setState(() {
              if (_selectionnerChips == "Mois actuel") {
                _selectionnerChips = "";
                _resetListFichierTrier();
              } else {
                _selectionnerChips = "Mois actuel";
                facturesTrier = _sort(true, false);
              }
            });
          },
        ),
        FilterChip(
          label: const Text("Année actuelle"),
          selected: _selectionnerChips == "Année actuelle",
          onSelected: (bool value) {
            setState(() {
              if (_selectionnerChips == "Année actuelle") {
                _selectionnerChips = "";
                _resetListFichierTrier();
              } else {
                _selectionnerChips = "Année actuelle";
                facturesTrier = _sort(false, true);
              }
            });
          },
        ),
      ],
    );
  }

  Widget buildListFactures() {
    return SizedBox(
        height: MediaQuery.of(this.context).size.height / 2.4,
        child: buildListView(_checkSiUserTrie() ? facturesTrier : factures));
  }

  Widget buildListView(List<Facture> listUtiliser) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(8),
        itemCount: listUtiliser.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(AppPsyUtils.getName(listUtiliser[index])),
                onTap: () async {
                  var file = await getFileFromDBB(listUtiliser[index]);
                  Navigator.of(this.context)
                      .push(MaterialPageRoute(
                          builder: (context) => PreviewPdf(
                                idFacture: listUtiliser[index].id!,
                                fichier: file,
                              )))
                      .then((value) => _getListFiles());
                }),
          );
        });
  }

  Future<void> _getListFiles() async {
    setState(() => isLoading = true);
    factures = await AppPsyDatabase.instance.getAllFileName();
    setState(() => isLoading = false);
  }

  Future<File> getFileFromDBB(Facture facture) async {
    Uint8List imageInUnit8List = facture.fichier;
    final tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/${AppPsyUtils.getName(facture)}').create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }

  List<Facture> _sort(bool mois, bool annee) {
    _resetListFichierTrier();
    List<Facture> listFinal = [];
    var now = DateTime.now();
    var formatterMounth = DateFormat('MM');
    var formatterYear = DateFormat('yyyy');
    if (mois) {
      String month = formatterMounth.format(now);
      String year = formatterYear.format(now);

      RegExp regex = RegExp("([$month]-[$year])");

      for (Facture f in factures) {
        if (regex.firstMatch(AppPsyUtils.getName(f)) != null) {
          listFinal.add(f);
        }
      }
    } else if (annee) {
      String year = formatterYear.format(now);
      RegExp regex = RegExp("([$year])");

      for (Facture f in factures) {
        if (regex.firstMatch(AppPsyUtils.getName(f)) != null) {
          listFinal.add(f);
        }
      }
    }

    return listFinal;
  }

  List<Facture>? _sortParRecherche(String? entree) {
    if (entree == null) {
      return null;
    }
    _resetListFichierTrier();
    List<Facture> listFinal = [];
    RegExp regex = RegExp(entree.toLowerCase());

    for (Facture f in factures) {
      if (regex.firstMatch(AppPsyUtils.getName(f).toLowerCase()) != null) {
        listFinal.add(f);
      }
    }

    return listFinal;
  }

  void _resetListFichierTrier() {
    facturesTrier.clear();
  }

  bool _checkSiUserTrie() {
    return _selectionnerChips.isNotEmpty ||
        _controllerChampRecherche.text.isNotEmpty;
  }

  showErrorMessage() {
    ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
        content: Text("Une erreur est survenue. Nous en sommes désolé")));
  }
}
