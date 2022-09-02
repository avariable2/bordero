import 'package:bordero/db/app_psy_database.dart';
import 'package:bordero/dialog/ajouter_type_acte.dart';
import 'package:bordero/dialog/modifier_client.dart';
import 'package:bordero/dialog/modifier_type_acte.dart';
import 'package:bordero/model/type_acte.dart';
import 'package:flutter/material.dart';

import '../component/list_recherche_action.dart';
import '../dialog/ajouter_client.dart';
import '../model/client.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MonAccueil();
  }
}

class MonAccueil extends StatefulWidget {
  const MonAccueil({Key? key}) : super(key: key);

  @override
  State<MonAccueil> createState() => _MonAccueilState();
}

class _MonAccueilState extends State<MonAccueil> {
  late List<Client> listClients;
  late List<TypeActe> listTypeActes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshLists();
  }

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  Future refreshLists() async {
    setStateIfMounted(() => isLoading = true);

    await AppPsyDatabase.instance.readAllClient().then((value) => {
          if (value.isNotEmpty)
            {
              listClients = value,
            }
          else
            {
              listClients = [],
            }
        });

    await AppPsyDatabase.instance.readAllTypeActe().then((value) => {
          if (value.isNotEmpty)
            {
              listTypeActes = value,
            }
          else
            {
              listTypeActes = [],
            }
        });

    setStateIfMounted(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildAccueil(),
      ),
    );
  }

  Widget buildAccueil() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        top: 70,
        right: 20,
      ),
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: Text(
            "Mon espace de gestion",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListRechercheEtAction(
          titre: 'Clients',
          icon: Icons.account_circle_sharp,
          labelTitreRecherche: 'Recherche client',
          labelHintRecherche: 'Essayer le nom ou prénom du client',
          labelListVide: '🤔​ Aucun client enregistré',
          list: listClients,
          onSelectedItem: (dynamic item) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    FullScreenDialogModifierClient(
                  client: item,
                ),
                fullscreenDialog: true,
              ),
            ).then((value) => refreshLists());
          },
          needRecherche: true,
          filterChipsNames: const [],
        ),
        buildButton(true),
        const SizedBox(
          height: 10,
        ),
        ListRechercheEtAction(
          titre: "Type d'actes",
          icon: Icons.work_outline,
          labelListVide: '🤔​ Aucun type de séance enregistré',
          list: listTypeActes,
          onSelectedItem: (dynamic item) {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    FullScreenDialogModifierTypeActe(
                  typeActe: item,
                ),
                fullscreenDialog: true,
              ),
            ).then((value) => refreshLists());
          },
          needRecherche: false,
          filterChipsNames: const [],
        ),
        buildButton(false),
        const SizedBox(
          height: 15,
        ),
        const Divider(),
        SizedBox(
            height: 200,
            child: Card(
              borderOnForeground: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    height: 150,
                    image: AssetImage('assets/images/iPhone.png'),
                  ),
                  Center(
                    child: Text(
                        "Actuellement la premiere version ! Du chemin nous attends."),
                  ),
                ],
              ),
            ))
      ],
    );
  }

  Widget buildButton(bool buttonPourClient) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => buttonPourClient
                ? const FullScreenDialogAjouterClient()
                : const FullScreenDialogAjouterTypeActe(),
            fullscreenDialog: true,
          ),
        ).then((value) => refreshLists());
      },
      icon: const Icon(Icons.add),
      label: const Text("Ajouter"),
    );
  }
}
