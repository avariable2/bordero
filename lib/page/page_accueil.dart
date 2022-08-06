import 'package:animations/animations.dart';
import 'package:app_psy/db/app_psy_database.dart';
import 'package:app_psy/dialog/ajouter_type_acte.dart';
import 'package:app_psy/dialog/modifier_client.dart';
import 'package:app_psy/dialog/modifier_type_acte.dart';
import 'package:app_psy/model/type_acte.dart';
import 'package:flutter/material.dart';

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
  final _controllerChampRecherche = TextEditingController();
  late List<Client> listClients;
  late List<TypeActe> listTypeActes;
  List<Client> listClientsTrier = [];
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Mon espace de gestion",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        const Padding(
          padding: EdgeInsets.only(top: 25, bottom: 15),
          child: Text(
            "Clients",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
        ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controllerChampRecherche,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: 'Recherche client',
                  helperText: 'Essayer le nom du client ou son prénom',
                ),
                onChanged: (String? entree) => setState(() {
                  if (entree != null && entree.length > 1) {
                    listClientsTrier = _sortParRecherche(entree) ?? [];
                  }
                }),
              ),
            ),
          ],
        ),

        const SizedBox(
          height: 15,
        ),

        if (listClients.isEmpty) ...[
          const Text(
            "🤔​ Aucun clients ",
            style: TextStyle(
              fontSize: 18,
            ),
          )
        ] else ...[
          buildListClient(_checkSiUserTrie()),
        ],


        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => const FullScreenDialogAjouterClient(),
                fullscreenDialog: true,
              ),
            ).then((value) => refreshLists());
          },
          icon: const Icon(Icons.add),
          label: const Text("Ajouter"),
        ),

        const Padding(
          padding: EdgeInsets.only(top: 25, bottom: 15),
          child: Text(
            "Type d'actes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
        ),

        if (listTypeActes.isEmpty)
          const Text(
            "🤔​ Aucune type de seance enregistré",
            style: TextStyle(
              fontSize: 18,
            ),
          )
        else
          SizedBox(
            height: 150,
            child: Card(
              borderOnForeground: true,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                children: [
                  for (TypeActe typeActe in listTypeActes)
                    ListTile(
                      title: Text(typeActe.nom),
                      leading: const Icon(Icons.work_outline),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                FullScreenDialogModifierTypeActe(
                              typeActe: typeActe,
                            ),
                            fullscreenDialog: true,
                          ),
                        ).then((value) => refreshLists());
                      },
                    ),
                ],
              ),
            ),
          ),

        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) =>
                    const FullScreenDialogAjouterTypeActe(),
                fullscreenDialog: true,
              ),
            ).then((value) => refreshLists());
          },
          icon: const Icon(Icons.add),
          label: const Text("Ajouter"),
        ),

        const SizedBox(
          height: 15,
        ),

        const SizedBox(
            height: 200,
            child: Card(
              borderOnForeground: true,
              child: Text(
                  "Actuellement la premiere version ! Du chemin nous attends."),
            ))
      ],
    );
  }

  Widget buildListClient(bool trier) {
    List<Client> listUtiliser = trier ? listClientsTrier : listClients;
    return SizedBox(
      height: 150,
      child: Card(
        borderOnForeground: true,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          addAutomaticKeepAlives: false,
          children: [
            for (Client client in listUtiliser)
              ListTile(
                title: Text("${client.prenom} ${client.nom} / ${client.email}"),
                leading: const Icon(Icons.account_circle_sharp),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          FullScreenDialogModifierClient(
                        client: client,
                      ),
                      fullscreenDialog: true,
                    ),
                  ).then((value) => refreshLists());
                },
              ),
          ],
        ),
      ),
    );
  }

  List<Client>? _sortParRecherche(String? entree) {
    if (entree == null) {
      return null;
    }
    _resetListClient();
    List<Client> listFinal = [];
    RegExp regex = RegExp(entree.toLowerCase());

    for (Client client in listClients) {
      if (regex.firstMatch(client.nom.toLowerCase()) != null ||
          regex.firstMatch(client.prenom.toLowerCase()) != null ||
          regex.firstMatch(client.email.toLowerCase()) != null) {
        listFinal.add(client);
      }
    }

    return listFinal;
  }

  void _resetListClient() {
    listClientsTrier.clear();
  }

  bool _checkSiUserTrie() {
    return _controllerChampRecherche.text.isNotEmpty;
  }
}
