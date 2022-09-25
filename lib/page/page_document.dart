import 'dart:typed_data';

import 'package:bordero/component/simple_dialog_item.dart';
import 'package:bordero/model/filter_chips_callback.dart';
import 'package:bordero/component/list_recherche_action.dart';
import 'package:bordero/dialog/creation_document.dart';
import 'package:bordero/model/document.dart';
import 'package:bordero/utils/app_psy_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../component/expendable_fab.dart';
import '../db/app_psy_database.dart';
import '../dialog/presentation_pdf.dart';

class PageFacturesDevis extends StatelessWidget {
  const PageFacturesDevis({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const WidgetDocuments();
  }
}

class WidgetDocuments extends StatefulWidget {
  const WidgetDocuments({Key? key}) : super(key: key);

  @override
  State<WidgetDocuments> createState() => _ViewFacturesState();
}

class _ViewFacturesState extends State<WidgetDocuments> {
  late List<Document> documents = [];
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
        onPressed: () =>
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text("Quel type de document"),
                    children: [
                      SimpleDialogItem(
                          icon: Icons.description_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          text: "Factures",
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                const FullScreenDialogCreationFacture(
                                  estFacture: true,
                                ),
                                fullscreenDialog: true,
                              ),
                            ).then((value) => _getListFiles());
                          }
                      ),
                      SimpleDialogItem(
                          icon: Icons.receipt_long_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          text: "Devis",
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                const FullScreenDialogCreationFacture(
                                  estFacture: false,
                                ),
                                fullscreenDialog: true,
                              ),
                            ).then((value) => _getListFiles());
                          })
                    ],
                  );
                }),
        child: const Icon(Icons.create),
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
              "Mes documents",
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
            list: documents,
            onSelectedItem: (dynamic item) async {
              var file = await getFileFromDBB(item);
              ouvrirPdf(item, file);
            },
            labelTitreRecherche: "Recherche d'un document",
            labelHintRecherche: "Essayez le nom ou le prénom du client ",
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
    documents = await AppPsyDatabase.instance.getAllFileName();
    setState(() => isLoading = false);
  }

  Future<File> getFileFromDBB(Document document) async {
    Uint8List imageInUnit8List = document.fichier;
    final tempDir = await getTemporaryDirectory();
    File file =
    await File('${tempDir.path}/${AppPsyUtils.getName(document)}').create();
    file.writeAsBytesSync(imageInUnit8List);
    return file;
  }

  ouvrirPdf(dynamic item, File file) {
    Navigator.of(context)
        .push(MaterialPageRoute(
        builder: (context) =>
            PreviewPdf(
              idFacture: item.id!,
              fichier: file,
              estFacture: item.estFacture,
            )))
        .then((value) => _getListFiles());
  }

  showErrorMessage() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Une erreur est survenue. Nous en sommes désolé")));
  }
}
