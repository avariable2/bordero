import 'package:app_psy/dialog/creation_facture.dart';
import 'package:flutter/material.dart';

class Factures extends StatelessWidget {
  const Factures({Key? key}) : super(key: key);

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
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 20,
              top: 70,
              right: 20,
            ),
            children: [
            Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Mes factures",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
            ]),
        ),
    );
  }

}