import 'dart:io';

import 'package:app_psy/model/facture.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:pdf/widgets.dart';

import '../model/client.dart';

class PdfFactureApi {
  static Future<File> generate(Facture facture) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
        build: (context) => [
          buildTitle(facture),
        ]
    ));

    var prenoms = "";
    for(Client c in facture.listClients) {
      prenoms += "${c.prenom} ";
    }
    final titre = '[${facture.id}] $prenoms - ${facture.dateCreationFacture}.pdf';
    return PdfApi.saveDocument(name: titre, pdf: pdf);
  }

  static Widget buildTitle(Facture facture) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Facture')
      ],
    );
  }
}