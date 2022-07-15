import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PreviewPdf extends StatelessWidget {
  final File fichier;
  const PreviewPdf({Key? key, required this.fichier,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Gestion de votre facture"),
        ),
      body: AffichageInfoPdf(fichier: fichier,)
    );
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
      child: Center(
        child: SizedBox(
          width: 270,
          height: 400,
          child: PdfView(path: widget.fichier.path),
        ),
      ),
    );
  }
}


