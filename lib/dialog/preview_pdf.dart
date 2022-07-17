import 'dart:io';

import 'package:app_psy/utils/pdf_api.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';

class PreviewPdf extends StatelessWidget {
  final File fichier;
  const PreviewPdf({Key? key, required this.fichier,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion de votre facture"),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                    child: ListTile(
                      leading: const Icon(Icons.delete),
                      title: const Text('Supprimer'),
                      onTap: () => _afficherAvertissementSuppression(context),
                    ),
                ),

                PopupMenuItem(
                  child: ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Partager'),
                      onTap: () => _onShare(context),
                  ),
                ),

              ],),

          ],
        ),
        body: AffichageInfoPdf(fichier: fichier,));
  }

  void _afficherAvertissementSuppression(BuildContext context) {
    var richText = RichText(
      text: const TextSpan(
          style: TextStyle(
            fontSize: 22.0,
          ),
          children: <TextSpan> [
            TextSpan(text: "Attention",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                )
            ),
            TextSpan(text: " : êtes-vous sur de vouloir supprimer cette facture ?"),
          ]
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: richText,
            content: const Text("Vous avez une obligation légales de garder pendant 5 ans vos factures."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("ANNULER"),
              ),
              TextButton(
                onPressed: () {
                  _supprimerFacture(context);
                },
                child: const Text("SUPPRIMER", style: TextStyle(color: Colors.white70)),),
            ],
            elevation: 24.0,
          ),
    );
  }

  void _supprimerFacture(BuildContext context) {
    PdfApi.deleteFile(fichier);
    Navigator.pop(context);
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;

    // Il est necessaire de passer par un path different de l'original pour eviter les fuites
    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/${basename(fichier.path)}";

    File(path).writeAsBytesSync(fichier.readAsBytesSync());
    await Share.shareFiles([path], subject: basename(fichier.path), sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}


class AffichageInfoPdf extends StatefulWidget {
  final File fichier;
  const AffichageInfoPdf({Key? key, required this.fichier}) : super(key: key);

  @override
  State<AffichageInfoPdf> createState() => _AffichageInfoPdfState();
}

class _AffichageInfoPdfState extends State<AffichageInfoPdf> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    //PdfApi.deleteFile(widget.fichier);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Methode pour chaque retour a l'page de refresh
    if (state == AppLifecycleState.detached) {
      //PdfApi.deleteAllFilesInCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [

        Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(flex: 1, child: CircleAvatar(child: Icon(Icons.info_outline))),
                Expanded(flex: 4,
                  child:
                  Text('''Cette facture n'est pas enregistrer sur une base de donnée. Penser à la sauvegarder (Drive, vous l'envoyez par mail, ...) !'''), ),
              ],
            ),
        ),

        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => _afficherInformationPourSauvegarde(), child: const Text("POURQUOI ?"))
            ],
          ),
        ),


        const Divider(),

        const SizedBox(
          height: 10,
        ),

        Center(
          child: SizedBox(
            width: 270,
            height: 380,
            child: PdfView(path: widget.fichier.path),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: ElevatedButton.icon(
              onPressed: () => _onShare(context),
              icon: const Icon(Icons.share_outlined),
              label: const Text("PARTAGER")
          ),
        ),

      ]),
    );
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;

    // Il est necessaire de passer par un path different de l'original pour eviter les fuites
    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/${basename(widget.fichier.path)}";

    File(path).writeAsBytesSync(widget.fichier.readAsBytesSync());
    await Share.shareFiles([path], subject: basename(widget.fichier.path), sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _afficherInformationPourSauvegarde() {
    var richText = RichText(
      text: const TextSpan(
          style: TextStyle(
            fontSize: 22.0,
          ),
          children: <TextSpan> [
            TextSpan(text: "Les données personnels de vos clients sont une priorité",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )
            ),
          ]
      ),
    );


    showDialog(
      context: this.context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: richText,
            content: const Text("Cette application ne possède pas de serveur pour sauvegarder vos factures tout en protegeant celle-ci."
                "\nN'hesitez pas à contribuer pour que nous puissions vous apporter toujours plus d'outils pour votre entreprise."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'RETOUR'),
                child: const Text("COMPRIS"),
              ),
            ],
            elevation: 24.0,
          ),
    );
  }
}


