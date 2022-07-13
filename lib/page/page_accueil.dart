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

class _MonAccueilState extends State<MonAccueil> with WidgetsBindingObserver {
  late List<Client> listClients;
  late List<TypeActe> listTypeActes;
  bool isLoading = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    refreshLists();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Methode pour chaque retour a l'page de refresh
    if (state == AppLifecycleState.resumed) {
      refreshLists();
    }
  }


  Future refreshLists() async {
    setState(() => isLoading = true);

    await AppPsyDatabase.instance.readAllClient().then((value) => {
      if (value.isNotEmpty) {
        listClients = value,
      } else {
        listClients = [],
      }
    });

    await AppPsyDatabase.instance.readAllTypeActe().then((value) => {
      if (value.isNotEmpty) {
        listTypeActes = value,
      } else {
        listTypeActes = [],
      }
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: isLoading ? const Center(child: CircularProgressIndicator()) :  buildAccueil(),
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


          const SizedBox(
            height: 25,
          ),


          const Text(
            "Clients",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),


          const SizedBox(
            height: 15,
          ),

          Row(
            children: const [
              Expanded(
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nom patient',
                  ),
                ),
              ),
            ],
          ),


          const SizedBox(
            height: 15,
          ),

          if(listClients.isEmpty)
            const Text("🤔​ Aucun clients ", style: TextStyle(fontSize: 18,),)
          else
          SizedBox(
            height: 200,
            child: Card(
              borderOnForeground: true,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                children: [
                  for(Client client in listClients)
                    ListTile(
                      title: Text("${client.prenom} ${client.nom} / ${client.adresse}"),
                      leading: const Icon(Icons.account_circle_sharp),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => FullScreenDialogModifierClient(client: client,),
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
                  builder: (BuildContext context) => const FullScreenDialogAjouterClient(),
                  fullscreenDialog: true,
                ),
              ).then((value) => refreshLists());
            },
            icon: const Icon(Icons.add),
            label: const Text("Ajouter"),
          ),


          const SizedBox(
            height: 25,
          ),


          const Text(
            "Type d'actes",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(
            height: 15,
          ),


          if(listTypeActes.isEmpty)
            const Text("🤔​ Aucune type de seance enregistré", style: TextStyle(fontSize: 18,),)
          else
          SizedBox(
            height: 200,
            child: Card(
              borderOnForeground: true,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                children: [
                  for(TypeActe typeActe in listTypeActes)
                    ListTile(
                      title: Text(typeActe.nom),
                      leading: const Icon(Icons.account_circle_sharp),
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => FullScreenDialogModifierTypeActe(typeActe: typeActe,),
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
                  builder: (BuildContext context) => const FullScreenDialogAjouterTypeActe(),
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
                child: Text("Actuellement la premiere version ! Du chemin nous attends."),
              )
          )

        ],
      );
    }
}
