import 'package:app_psy/main.dart';
import 'package:app_psy/page/page_information_praticien.dart';
import 'package:app_psy/page/presentation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import '../model/infos_praticien.dart';
import 'connexion.dart';

class PageParametres extends StatelessWidget {
  const PageParametres({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ParametresGlobaux(),
    );
  }
}

class ParametresGlobaux extends StatefulWidget {
  const ParametresGlobaux({Key? key}) : super(key: key);

  @override
  State<ParametresGlobaux> createState() => _ParametresGlobauxState();
}

class _ParametresGlobauxState extends State<ParametresGlobaux> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 70,
              left: 20
            ),
            child: Text(
              "Mes paramètres",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.only(left: 10),
            children: [
              ListTile(
                title: const Text("Mes informations"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const FullScreenDialogInformationPraticien(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              ListTile(
                title: const Text("Theme"),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Support"),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: const Text("Conditions d'utilisation"),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Confidentialité"),
                onTap: () {},
              ),
              ListTile(
                title: const Text("Mentions légales"),
                onTap: () {},
              ),
              const Divider(),
              ListTile(
                title: const Text("Déconnexion"),
                onTap: () async {
                  SpUtil.remove(InfosPraticien.keyObjInfosPraticien);
                  await FirebaseAuth.instance.signOut();
                },
              ),
            ],
          )),
        ],
      ),
    );
  }
}
