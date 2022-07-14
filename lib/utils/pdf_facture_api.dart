import 'dart:io';

import 'package:app_psy/model/facture.dart';
import 'package:app_psy/utils/app_psy_utils.dart';
import 'package:app_psy/utils/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../model/client.dart';

class PdfFactureApi {
  static Future<File> generate(Facture facture) async {
    final pdf = Document();

    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          buildTitle(facture),
        ]
    ));

    var prenoms = "";
    for(Client c in facture.listClients) {
      prenoms += "-${c.prenom}";
    }
    final titre = 'Facture#${facture.id}$prenoms(${facture.dateCreationFacture.month}-${facture.dateCreationFacture.year}).pdf';
    return PdfApi.saveDocument(name: titre, pdf: pdf);
  }

  static Widget buildTitle(Facture facture) {
    //final font = await PdfGoogleFonts.nunitoExtraLight();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("NOTE D'HONORAIRE",),
        SizedBox(height: 0.8 * PdfPageFormat.cm),
        Text(AppPsyUtils.toDateString(facture.dateCreationFacture))
      ],
    );
  }
}