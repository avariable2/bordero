import 'package:bordero/db/app_psy_database.dart';
import 'package:bordero/model/theme_settings.dart';
import 'package:bordero/model/utilisateur.dart';
import 'package:bordero/page/page_information_praticien.dart';
import 'package:bordero/utils/app_psy_utils.dart';
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
  static const _urlEngagementConfidentialite = "https://docs.google.com/document/d/1mB4VnSXrD1JjiEjF1bBlhdyFPwZQNyUdx2dBSWEgBhM/edit?usp=sharing";

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
                    activeColor: Theme.of(context).colorScheme.primary,
                    title: const Text("Thème sombre"),
                    value: value.darkTheme,
                    onChanged: (newValue) => value.toggleTheme(),
                  );
                },
              ),
              ListTile(
                title: const Text("Support"),
                onTap: () async {
                  await launchUrl(Uri.parse(_urlString));
                },
              ),
              const Divider(),
              /*ListTile(
                title: const Text("Conditions d'utilisation"),
                onTap: () {},
              ),*/
              ListTile(
                title: const Text("Engagement de confidentialité"),
                onTap: () async {
                  await launchUrl(Uri.parse(_urlEngagementConfidentialite));
                },
              ),
              /*ListTile(
                title: const Text("Mentions légales"),
                onTap: () {},
              ),*/
              const Divider(),
              ListTile(
                title: const Text("Déconnexion"),
                onTap: () => AppPsyUtils.afficherDialog(context: context,
                    titre: "Souhaitez-vous vous déconnecter ?",
                    corps:
                        "Toutes vos factures et données seront supprimées. Si vous ne les avez pas enregistrées, nous ne pourrons rien pour vous. Agissez en âme et conscience.",
                    buttonCancelTexte: "ANNULER",
                    buttonValiderTexte: "DÉCONNEXION",
                    buttonCancelCallback: () =>
                        Navigator.pop(context, 'Cancel'),
                    buttonValiderCallback: () {
                      Navigator.pop(context, 'Cancel');
                      AppPsyUtils.afficherDialog(context: context,
                          titre: "Êtes-vous certain ?",
                          corps:
                              "Cette action est irréversible pour le moment. Si vous vous déconnectez vos données disparaîtront.",
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
                  onTap: () => AppPsyUtils.afficherDialog(context: context,
                      titre: "Êtes-vous sûr de vouloir supprimer votre compte ?",
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
                      helperText: "Étape oligatoire pour supprimer votre compte"
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
        _afficherProbleme("Une erreur est survenue, contactez le support pour que nous puissions vous aider.");
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
