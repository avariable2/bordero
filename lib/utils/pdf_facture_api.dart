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
          buildTitre(facture),
          buildInformationsClients(facture),
          buildInformations(facture),
          Divider(),
          buildTotal(facture),
        ]
    ));

    var prenoms = "";
    for(Client c in facture.listClients) {
      prenoms += "-${c.prenom}";
    }
    final titre = 'Facture#${facture.id}$prenoms(${facture.dateCreationFacture.month}-${facture.dateCreationFacture.year}).pdf';
    return PdfApi.saveDocument(name: titre, pdf: pdf);
  }

  static Widget buildTitre(Facture facture) {
    
    return Row(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nom prenom", style: TextStyle(fontWeight: FontWeight.bold)),
          Text("adresse"),
          Text("code postal ville"),
          Text("numero de telephone"),
          Text("email"),
          SizedBox(height: 10),
          Text("N°SIRET : num_siret"),
          Text("N°ADELI : num_adeli"),
        ]
      ),
      Spacer(flex: 6),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("NOTE D'HONORAIRE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.6 * PdfPageFormat.cm),
          Text(AppPsyUtils.toDateString(facture.dateCreationFacture) , style: const TextStyle(fontSize: 18)),
          Text("N°${facture.id}", style: const TextStyle(fontSize: 18)),
          SizedBox(height: 100),
        ],
      )
    ]);
  }

  static Widget buildInformationsClients(Facture facture) {
    return Row(children: [
      Spacer(flex: 6),
      for (Client client in facture.listClients)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("${client.nom} ${client.prenom}", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(client.adresse),
            Text("${client.codePostal} ${client.ville}"),
            Text(client.numeroTelephone),
            Text(client.email),
            SizedBox(height: 20)
          ],
        ),
    ]);

  }

  static Widget buildInformations(Facture facture) {
    final enTete = ["Prestations".toUpperCase(), "Quantité".toUpperCase(), "Prix unitaire HT".toUpperCase(), "Montant HT".toUpperCase()];
    final donnees = facture.listSeances.map((item) {
      final total = item.prix * item.quantite;
      final description = "${AppPsyUtils.toDateString(item.date)} | ${item.nom}";
      return [
        description,
        item.quantite,
        item.prix,
        total,
      ];
    }).toList();

    return Table.fromTextArray(
      headers: enTete, data: donnees, border: null, headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.green100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Facture facture) {
    final netTotal = facture.listSeances.map((item) => item.prix * item.quantite).reduce((item1, item2) => item1 + item2);
    final vat = netTotal * 0.20;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
              child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText(
                        title: 'TOTAL HT',
                        value: netTotal.toString(),
                        unite: true,
                      ),
                      buildText(
                        title: 'TVA 20%',
                        value: vat.toString(),
                        unite: true,
                      ),
                      Divider(),
                      buildText(
                        title: 'TOTAL TTC',
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        value: total.toString(),
                        unite: true,
                      ),
                    ],
                )
          ),
        ],
      ),
    );
  }

  static Widget buildText({required String title, required String value, double width = double.infinity, TextStyle? titleStyle, bool unite = false}) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ]
      )
    );
  }
}