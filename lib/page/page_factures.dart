import 'dart:typed_data';

import 'package:bordero/model/filter_chips_callback.dart';
import 'package:bordero/component/list_recherche_action.dart';
import 'package:bordero/dialog/creation_facture.dart';
import 'package:bordero/model/facture.dart';
import 'package:bordero/utils/app_psy_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

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
  late List<Facture> factures = [];

  bool isLoading = false;

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
    var now = DateTime.now();
    String month = DateFormat('MM').format(now);
    String year = DateFormat('yyyy').format(now);

    RegExp regexMonth = RegExp("([$month]-[$year])");
    RegExp regexYear = RegExp("([$year])");

    return ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 20,
          top: 70,
          right: 20,
        ),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Mes factures",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListRechercheEtAction(
            titre: '',
            icon: Icons.picture_as_pdf_outlined,
            labelListVide: '',
            list: factures,
            onSelectedItem: (dynamic item) async {
              var file = await getFileFromDBB(item);
              ouvrirPdf(item, file);
            },
            labelTitreRecherche: "Recherche facture",
            labelHintRecherche: "Essayer le nom du client ou son prénom",
            needRecherche: true,
            needTousEcran: true,
            needChips: true,
            filterChipsNames: [
              FilterChipCallback("Mois actuel", regexMonth),
              FilterChipCallback("Année actuelle", regexYear)
            ],
          ),
        ]);
  }

  Future<void> _getListFiles() async {
    setState(() => isLoading = true);
    factures = await AppPsyDatabase.instance.getAllFileName();
    setState(() => isLoading = false);
  }

  Future<File> getFileFromDBB(Facture facture) async {
    Uint8List imageInUnit8List = facture.fichier;
    final tempDir = await getTemporaryDirectory();
    File file =
        await File('${tempDir.path}/${AppPsyUtils.getName(facture)}').create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }

  ouvrirPdf(dynamic item, File file) {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (context) => PreviewPdf(
                  idFacture: item.id!,
                  fichier: file,
                )))
        .then((value) => _getListFiles());
  }

  showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Une erreur est survenue. Nous en sommes désolé")));
  }
}
