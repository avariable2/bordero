import 'package:app_psy/db/client_database.dart';
import 'package:app_psy/dialog/modifier_client.dart';
import 'package:flutter/material.dart';

import 'dialog/ajouter_client.dart';
import 'model/client.dart';

class Accueil extends StatelessWidget {
  const Accueil({Key? key}) : super(key: key);

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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshClient();
  }

  Future refreshClient() async {
    setState(() => isLoading = true);

    await ClientDatabase.instance.readAllClient().then((value) => {
      if (value.isNotEmpty) {
        listClients = value,
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:  Text('Aie ! Contacter le developpeur')),
        ),
        listClients = [],
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
                        );
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
              );
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


          SizedBox(
            height: 200,
            child: Card(
              borderOnForeground: true,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                addAutomaticKeepAlives: false,
                children: [
                  for (int count in List.generate(20, (index) => index + 1))
                    ListTile(
                      title: Text('Thomas Simon $count'),
                      leading: const Icon(Icons.work_outline),
                      onTap: () {},
                    ),
                ],
              ),
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {},
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
                child: Text("Actuellement la premiere version du chemin nous attends."),
              )
          )

        ],
      );
    }
}

class FullScreenDialogAjouterClient extends StatelessWidget {
  const FullScreenDialogAjouterClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création client'),
      ),
      body: const DialogAjouterClient(),
    );
  }
}


class FullScreenDialogModifierClient extends StatelessWidget {
  final Client client;
  const FullScreenDialogModifierClient({Key? key, required this.client,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification client'),
      ),
      body: DialogModifierClient(client: client,),
    );
  }
}