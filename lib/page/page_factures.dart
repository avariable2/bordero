import 'package:app_psy/dialog/creation_facture.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';
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
  late List<FileSystemEntity> fichiers;
  bool isLoading = false;

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

  Future<void> _getListFiles() async {
    setState(() => isLoading = true);


    fichiers = await PdfApi.getAllFilesInCache();

    setState(() => isLoading = false);
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
          );
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

          Row(
            children: const [
              Expanded(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Recherche facture',
                    helperText: 'Essayer par le nom du client ou bien sont prénom'
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 10,
          ),

          const Divider(),

          for (FileSystemEntity f in fichiers)
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(basename(f.path)),
                onTap: () => Navigator.of(this.context).push(MaterialPageRoute(builder: (context) => PreviewPdf(fichier: File(f.path),))),
              ),
            ),
        ]);
  }
}
