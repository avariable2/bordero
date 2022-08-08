import 'package:app_psy/db/app_psy_database.dart';
import 'package:app_psy/model/theme_settings.dart';
import 'package:app_psy/model/utilisateur.dart';
import 'package:app_psy/page/page_information_praticien.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/shared_pref.dart';

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
            padding: EdgeInsets.only(top: 70, left: 20),
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
                            const FullScreenDialogInformationPraticien(
                          firstTime: false,
                        ),
                        fullscreenDialog: true,
                      ));
                },
              ),
              Consumer<ThemeSettings>(
                builder: (context, value, child) {
                  return SwitchListTile(
                    activeColor: Theme.of(context).selectedRowColor,
                    title: const Text("Theme sombre"),
                    value: value.darkTheme,
                    onChanged: (newValue) => value.toggleTheme(),
                  );
                },),

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
                onTap: () => afficherDialogConfirmationDeconnexion(),
              ),
            ],
          )),
        ],
      ),
    );
  }

  afficherDialogConfirmationDeconnexion() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Souhaitez-vous vous déconnecter ?"),
            content: const Text(
                "Toutes vos factures et données seront supprimer. Si vous ne les avez pas enregistrer, nous ne pourrons rien pour vous. Agisser en ames et conscience."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("ANNULER"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'ANNULER');
                  afficherDialogConfirmationDeconnexion2emeValidation();
                },
                child: const Text("DECONNEXION"),
              ),
            ],
            elevation: 24.0,
          );
        });
  }

  afficherDialogConfirmationDeconnexion2emeValidation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Etes-vous certain ?"),
            content: const Text(
                "Cette action est irréversible pour le moment. Si vous vous déconnecter vos données disparaitrons."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("NON"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'deco');
                  deconnexion();
                },
                child: const Text("OUI"),
              ),
            ],
            elevation: 24.0,
          );
        });
  }

  deconnexion() async {
    await SharedPref().remove(tableUtilisateur);
    await SharedPref().saveIsSetOrNot(false);
    await AppPsyDatabase.instance.deleteAllData();
    await FirebaseAuth.instance.signOut();
  }
}
