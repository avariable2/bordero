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
          buildInformationsSeances(facture),
          Divider(),
          buildTotal(facture),
          buildPayement(facture),
          buildSignature(facture),
        ]
    ));

    var prenoms = "";
    for(Client c in facture.listClients) {
      prenoms += "-${c.prenom}-${c.nom}";
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
          Text(AppPsyUtils.toDateString(facture.dateCreationFacture) , style: const TextStyle(fontSize: 16)),
          Text("N°${facture.id}", style: const TextStyle(fontSize: 18)),
          SizedBox(height: 100),
        ],
      )
    ]);
  }

  static Widget buildInformationsClients(Facture facture) {
    return Column(children: [
      for (Client client in facture.listClients)
      Row(
        children: [
          Spacer(flex: 6),
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
        ]
      )

    ]);

  }

  static Widget buildInformationsSeances(Facture facture) {
    final enTete = ["Prestations".toUpperCase(), "Quantité".toUpperCase(), "Prix unitaire HT".toUpperCase(), "Montant HT".toUpperCase()];
    final donnees = facture.listSeances.map((item) {
      final total = item.prix * item.quantite;
      final description = "${AppPsyUtils.toDateString(item.date)} | ${item.nom}";
      return [
        description,
        item.quantite,
        item.prix.toStringAsFixed(2),
        total.toStringAsFixed(2),
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
    final tva = netTotal * 0.20;
    final total = netTotal + tva;

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
                        value: netTotal.toStringAsFixed(2),
                        unite: true,
                      ),
                      buildText(
                        title: 'TVA 20%',
                        value: tva.toStringAsFixed(2),
                        unite: true,
                      ),
                      Divider(),
                      buildText(
                        title: 'TOTAL TTC',
                        titleStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        value: total.toStringAsFixed(2),
                        unite: true,
                      ),
                      SizedBox(height: 15),
                      Text("Exonéré de TVA au titre de l'article 261-4-1° du Code Général des Impôts", style: const TextStyle(fontSize: 10)),
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


  static Widget buildPayement(Facture facture) {
    var dateLimite = "";
    if (facture.dateLimitePayement != null) {
      dateLimite = AppPsyUtils.toDateString(facture.dateLimitePayement!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30),
        Text('Echéance : $dateLimite'),
        Text('Règlement : '),
      ]
    );
  }

  static Widget buildSignature(Facture facture) {
    final data = facture.signaturePNG;
    if (data != null) {
      var image = MemoryImage(data);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children : [
          SizedBox(height: 20),
          Image(image, width: 100),
        ]
      );
    } else {

      return Container();
    }
  }
}