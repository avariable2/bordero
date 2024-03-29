import 'dart:io';

import 'package:bordero/model/utilisateur.dart';
import 'package:bordero/utils/app_psy_utils.dart';
import 'package:bordero/utils/pdf_api.dart';
import 'package:bordero/utils/shared_pref.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../model/client.dart';
import '../model/document.dart' as model_document_bordero;

class PdfFactureApi {
  static Future<File?> generate(
      model_document_bordero.CreationDocument document) async {
    Utilisateur? infos;
    try {
      infos = Utilisateur.fromJson(await SharedPref().read(tableUtilisateur));
    } on Exception catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      return null;
    }

    if (infos == null) return null;

    final pdf = Document();
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
              buildTitre(document, infos!),
              buildInformationsClients(document),
              buildInformationsSeances(document),
              Divider(),
              buildTotal(document, infos.exonererTVA == 0 ? false : true),
              buildPayement(document, infos),
            ]));

    var prenoms = "";
    for (Client c in document.listClients) {
      prenoms += "-${c.prenom.trim()}-${c.nom.trim()}";
    }
    final titre = document.estFacture
        ? 'Facture#${document.id}$prenoms(${document.dateCreationFacture.month}-${document.dateCreationFacture.year}).pdf'
        : 'Devis#${document.id}$prenoms(${document.dateCreationFacture.month}-${document.dateCreationFacture.year}).pdf';

    return PdfApi.saveDocument(name: titre, pdf: pdf);
  }

  static Widget buildTitre(
      model_document_bordero.CreationDocument document, Utilisateur infos) {
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("${infos.nom} ${infos.prenom}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Text(infos.adresse),
        Text("${infos.codePostal} ${infos.ville}"),
        Text(infos.numeroTelephone),
        Text(infos.email),
        SizedBox(height: 10),
        Text("N°SIRET : ${infos.numeroSIRET}"),
        Text("N°ADELI : ${infos.numeroADELI}"),
      ]),
      Spacer(flex: 6),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
              document.estFacture
                  ? "NOTE D'HONORAIRES"
                  : "DEVIS N°${document.id}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 0.6 * PdfPageFormat.cm),
          Text(AppPsyUtils.toDateString(document.dateCreationFacture),
              style: const TextStyle(fontSize: 16)),
          if (document.estFacture)
            Text("N°${document.id}", style: const TextStyle(fontSize: 18)),
          SizedBox(height: 100),
        ],
      )
    ]);
  }

  static Widget buildInformationsClients(
      model_document_bordero.CreationDocument document) {
    return Column(children: [
      for (Client client in document.listClients)
        Row(children: [
          Spacer(flex: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${client.nom} ${client.prenom}",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              if (client.adresse != null && client.adresse!.isNotEmpty)
                Text(client.adresse!),
              Text("${client.codePostal} ${client.ville}"),
              if (client.numeroTelephone != null &&
                  client.numeroTelephone!.isNotEmpty)
                Text(client.numeroTelephone!),
              Text(client.email),
              SizedBox(height: 20)
            ],
          ),
        ])
    ]);
  }

  static Widget buildInformationsSeances(
      model_document_bordero.CreationDocument document) {
    final enTete = [
      "Prestations".toUpperCase(),
      "Quantité".toUpperCase(),
      "Prix unitaire HT".toUpperCase(),
      "Montant HT".toUpperCase()
    ];
    final donnees = document.listSeances.map((item) {
      final total = item.prix * item.quantite;
      final description =
          "${AppPsyUtils.toDateString(item.date)} | ${item.nom}";
      return [
        description,
        item.quantite,
        item.prix.toStringAsFixed(2),
        total.toStringAsFixed(2),
      ];
    }).toList();

    return Container(
        child: Table.fromTextArray(
      headers: enTete,
      data: donnees,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.green100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
      },
    ));
  }

  static Widget buildTotal(
      model_document_bordero.CreationDocument document, bool exonererTVA) {
    final totalHT = document.listSeances
        .map((item) => item.prix * item.quantite)
        .reduce((item1, item2) => item1 + item2);
    // Si pas exonéré tva ? calcul classique : sinon 0
    final coutTVA = !exonererTVA ? totalHT * 0.20 : 0;
    final totalNET = totalHT + coutTVA;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildText(
                    title: 'TOTAL HT',
                    value: totalHT.toStringAsFixed(2),
                    unite: true,
                  ),
                  if (!exonererTVA)
                    buildText(
                      title: 'TVA 20%',
                      value: coutTVA.toStringAsFixed(2),
                      unite: true,
                    ),
                  Divider(),
                  buildText(
                    title: 'TOTAL TTC',
                    titleStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    value: totalNET.toStringAsFixed(2),
                    unite: true,
                  ),
                  SizedBox(height: 15),
                  if (exonererTVA)
                    Text(
                        "Exonéré de TVA au titre de l'article 261-4-1° du Code Général des Impôts",
                        style: const TextStyle(fontSize: 10)),
                ],
              )),
        ],
      ),
    );
  }

  static Widget buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      TextStyle? titleStyle,
      bool unite = false}) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
        width: width,
        child: Row(children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ]));
  }

  static Widget buildPayement(
      model_document_bordero.CreationDocument document, Utilisateur infos) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 15),
              Text('Règlement : ${AppPsyUtils.getTypePayements(infos)}'),
              Text(
                  'Echéance : ${document.dateLimitePayement != null ? AppPsyUtils.toDateString(document.dateLimitePayement!) : "aucune"}'),
            ]),
            Spacer(flex: 2),
            buildSignature(document),
          ]),
    );
  }

  static Widget buildSignature(
      model_document_bordero.CreationDocument document) {
    final data = document.signaturePNG;
    if (data != null) {
      var image = MemoryImage(data);
      return Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 200,
            height: 120,
            child: Image(image, fit: BoxFit.fitWidth, width: 200)),
      ]));
    } else {
      return Container();
    }
  }
}
