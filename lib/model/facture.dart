

import 'dart:typed_data';

import 'package:app_psy/model/seance.dart';
import 'client.dart';

class Facture {
  final String id;
  final DateTime dateCreationFacture;
  final List<Client> listClients;
  final List<Seance> listSeances;
  final DateTime? dateLimitePayement;
  final Future<Uint8List?> signaturePNG;

  const Facture({
    required this.id,
    required this.dateCreationFacture,
    required this.listClients,
    required this.listSeances,
    required this.dateLimitePayement,
    required this.signaturePNG,
  });

}