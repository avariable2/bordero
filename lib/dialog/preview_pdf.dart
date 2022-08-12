import 'dart:io';
import 'package:app_psy/utils/app_psy_utils.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:share_plus/share_plus.dart';
import '../db/app_psy_database.dart';

class PreviewPdf extends StatelessWidget {
  static const int idPasEncoreConnu = 0;

  final File fichier;
  final int idFacture;

  const PreviewPdf({
    Key? key,
    required this.idFacture,
    required this.fichier,
  }) : super(key: key);

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
              ],
            ),
          ],
        ),
        body: AffichageInfoPdf(
          fichier: fichier,
        ));
  }

  void _afficherAvertissementSuppression(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Attention : êtes-vous sur de vouloir supprimer cette facture ?",
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary,fontSize: 22.0,)),
        content: const Text(
            "Vous avez une obligation légales de garder pendant 5 ans vos factures. Nous esquivons toutes responsabilités en cas de litige."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text("ANNULER"),
          ),
          TextButton(
            onPressed: () {
              _supprimerFacture(context).then((value) {
                // Close dialog
                Navigator.pop(context);
                // Close menu view
                Navigator.pop(context);
                // Close actual view
                Navigator.pop(context);
              });
            },
            child: const Text("SUPPRIMER"),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  Future<void> _supprimerFacture(BuildContext context) async {
    var id = idFacture;
    if (idFacture == idPasEncoreConnu) {
      await AppPsyDatabase.instance
          .readIfFactureIsAlreadySet(AppPsyUtils.getNameOfFile(fichier))
          .then((value) {
        if (value != null) {
          id = value.id!;
        } else {
          affichageErreur(context);
          return;
        }
      });
    }
    await AppPsyDatabase.instance.deleteFacture(id);
  }

  void affichageErreur(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Une erreur sait produite. Nous en sommes désolé.")));
  }

  void _onShare(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;

    // Il est necessaire de passer par un path different de l'original pour eviter les fuites
    final temp = await getTemporaryDirectory();
    final path = "${temp.path}/${basename(fichier.path)}";

    File(path).writeAsBytesSync(fichier.readAsBytesSync());
    await Share.shareFiles([path],
        subject: basename(fichier.path),
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

class AffichageInfoPdf extends StatefulWidget {
  final File fichier;

  const AffichageInfoPdf({Key? key, required this.fichier}) : super(key: key);

  @override
  State<AffichageInfoPdf> createState() => _AffichageInfoPdfState();
}

class _AffichageInfoPdfState extends State<AffichageInfoPdf> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                  flex: 1,
                  child: CircleAvatar(child: Icon(Icons.info_outline))),
              Expanded(
                flex: 4,
                child: Text(
                    '''Cette facture n'est pas enregistrer sur une base de donnée externe. Penser à la sauvegarder (Drive, vous l'envoyez par mail, ...) !'''),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => _afficherInformationPourSauvegarde(),
                  child: const Text("POURQUOI ?"))
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
              label: const Text("PARTAGER")),
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
    await Share.shareFiles([path],
        subject: basename(widget.fichier.path),
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  void _afficherInformationPourSauvegarde() {
    showDialog(
      context: this.context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
            "Les données personnels de vos clients sont une priorité",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            )),
        content: const Text(
            "Cette application ne possède pas de serveur pour sauvegarder vos factures tout en protegeant celle-ci."
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
