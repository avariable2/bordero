import 'package:bordero/db/app_psy_database.dart';
import 'package:bordero/model/theme_settings.dart';
import 'package:bordero/model/utilisateur.dart';
import 'package:bordero/page/page_information_praticien.dart';
import 'package:bordero/utils/fire_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/infos_utilisateur_parametres.dart';
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
  final controllerMotDePasse = TextEditingController();
  static const _urlString = "https://docs.google.com/forms/d/e/1FAIpQLSfjLRAybQuL7fdgk1HqG257yNGOgGlab1kRnxwucySyQGmN-w/viewform?usp=pp_url";

  @override
  void initState() {
    super.initState();
    controllerMotDePasse.addListener(() { });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controllerMotDePasse.dispose();
    super.dispose();
  }

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
                    activeColor: Theme.of(context).primaryColorLight,
                    title: const Text("Theme sombre"),
                    value: value.darkTheme,
                    onChanged: (newValue) => value.toggleTheme(),
                  );
                },
              ),
              ListTile(
                title: const Text("Support"),
                onTap: () async {
                  var url = Uri.parse(_urlString);
                  await launchUrl(url);
                },
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
                onTap: () => afficherDialog(
                    titre: "Souhaitez-vous vous déconnecter ?",
                    corps:
                        "Toutes vos factures et données seront supprimer. Si vous ne les avez pas enregistrer, nous ne pourrons rien pour vous. Agisser en ames et conscience.",
                    buttonCancelTexte: "ANNULER",
                    buttonValiderTexte: "DECONNEXION",
                    buttonCancelCallback: () =>
                        Navigator.pop(context, 'Cancel'),
                    buttonValiderCallback: () {
                      Navigator.pop(context, 'Cancel');
                      afficherDialog(
                          titre: "Etes-vous certain ?",
                          corps:
                              "Cette action est irréversible pour le moment. Si vous vous déconnecter vos données disparaitrons.",
                          buttonCancelTexte: "NON",
                          buttonValiderTexte: "OUI",
                          buttonCancelCallback: () =>
                              Navigator.pop(context, 'Cancel'),
                          buttonValiderCallback: () {
                            Navigator.pop(context, 'deco');
                            deconnexion();
                          });
                    }),
              ),
              ListTile(
                  title: const Text("Supprimer son compte"),
                  onTap: () => afficherDialog(
                      titre: "Etes vous sur de vouloir supprimer votre compte ?",
                      corps:
                          "Vous ne pourrez plus vous reconnecter à nos services.",
                      buttonCancelTexte: "ANNULER",
                      buttonValiderTexte: "SUPPRIMER",
                      buttonCancelCallback: () =>
                          Navigator.pop(context, 'Cancel'),
                      buttonValiderCallback: () {
                        if (controllerMotDePasse.value.text.isEmpty || controllerMotDePasse.value.text.length < 6) {
                          return null;
                        } else {
                          suppression();
                          Navigator.pop(context, 'Cancel');
                        }
                      },
                  elementAtEnd: TextFormField(
                    obscureText: true,
                    autofocus: true,
                    controller: controllerMotDePasse,
                    decoration: const InputDecoration(
                      labelText: 'Saisissez votre mot de passe (6 lettres ou plus)',
                      helperText: "Etape bligatoire pour supprimer votre compte"
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty && value.length < 6) {
                        return "Saisir un mot de passe de minimum 6 lettres";
                      }
                      return null;
                    },
                  ),)),
            ],
          )),
        ],
      ),
    );
  }

  afficherDialog(
      {required String titre,
      required String corps,
      required String buttonCancelTexte,
      required String buttonValiderTexte,
      Function()? buttonCancelCallback,
      Function()? buttonValiderCallback,
      Widget? elementAtEnd}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(titre,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                )),
            content: elementAtEnd ?? Text(corps),
            actions: [
              TextButton(
                onPressed: buttonCancelCallback,
                child: Text(buttonCancelTexte),
              ),
              TextButton(
                onPressed: buttonValiderCallback,
                child: Text(buttonValiderTexte),
              ),
            ],
            elevation: 24.0,
          );
        });
  }

  deconnexion() async {
    _enleverUtilisateurSet();
    await SharedPref().remove(tableUtilisateur);
    await AppPsyDatabase.instance.deleteAllData();
    await FirebaseAuth.instance.signOut();
  }

  suppression() async {
    await FireAuth(FirebaseAuth.instance).supprimerCompte(password: controllerMotDePasse.text).then((value) async {
      if (value ==  true) {
        _enleverUtilisateurSet();
        await SharedPref().remove(tableUtilisateur);
        await AppPsyDatabase.instance.deleteAllData();
      } else if (value == FireAuth.erreurType1) {
        _afficherProbleme("Votre mot de passe n'est pas le bon.");
      } else {
        _afficherProbleme("Une erreur est survenue, contacter le support pour que nous puissions vous aidez.");
      }
    });

  }

  _enleverUtilisateurSet() {
    context.read<InfosUtilisateurParametres>().toggleIsSet();
  }

  _afficherProbleme(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
