import 'package:flutter/material.dart';

import '../db/app_psy_database.dart';
import '../model/client.dart';

class FullScreenDialogCreationFacture extends StatelessWidget {
  const FullScreenDialogCreationFacture({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Création d'une facture"),
      ),
      body: const FormulaireCreationFacture(),
    );
  }
}

class FormulaireCreationFacture extends StatefulWidget {
  const FormulaireCreationFacture({Key? key}) : super(key: key);

  @override
  State<FormulaireCreationFacture> createState() => _FormulaireCreationFactureState();
}

class _FormulaireCreationFactureState extends State<FormulaireCreationFacture> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late List<Client> listClients;
  List<Client> clientSelectionner = [];
  late List<bool> _selected;
  bool isLoading = false;

  final controllerChampNom = TextEditingController();
  final controllerChampPrenom = TextEditingController();
  final controllerChampAdresse = TextEditingController();
  final controllerChampCodePostal = TextEditingController();
  final controllerChampVille = TextEditingController();
  final controllerChampNumero = TextEditingController();
  final controllerChampEmail = TextEditingController();

  Future _getListClients() async {
    setState(() => isLoading = true);

    await AppPsyDatabase.instance.readAllClient().then((value) => {
      if (value.isNotEmpty) {
        listClients = value,
        _selected = List.generate(listClients.length, (index) => false),
      } else {
        listClients = [],
        _selected = [],
      }
    });

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _getListClients();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? const Center(child: CircularProgressIndicator()) :  buildClient();
  }

  Widget buildClient() {
    return ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
          left: 20,
          top: 20,
          right: 20,
        ),
        children: [
          const Text("Sélectionner client(s)",
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
                        for(var i = 0; i < listClients.length; i++)
                          ListTile(
                            title: Text("${listClients[i].prenom} ${listClients[i].nom} / ${listClients[i].adresse}"),
                            leading: const Icon(Icons.account_circle_sharp),
                            selected: _selected[i],
                            onTap: () {
                              if (!clientSelectionner.contains(listClients[i])) {
                                clientSelectionner.add(listClients[i]);
                                _selected[i] = true;
                              } else {
                                clientSelectionner.remove(listClients[i]);
                                _selected[i] = false;
                              }
                            },
                          ),
                      ],
                  ),
              ),
          ),

          const SizedBox(
            height: 15,
          ),


          ElevatedButton(
            onPressed: () {

            },
            child: const Text('Continuer'),
          ),

        ],
    );
  }

  Widget buildSeance() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(flex: 1, child: Icon(Icons.info_outline)),
                Expanded(flex: 4, child: Text('''Toutes les informations sont nécessaire pour la création d'un client.'''), ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            const Divider(),

            /* PARTIE NOM ET PRENOM */

            Row(children: [
              Expanded(child:
              Padding(padding: const EdgeInsets.only( top:10, left: 8, bottom: 10),
                child: TextFormField(
                  controller: controllerChampNom,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom',
                      icon: Icon(Icons.account_box_outlined)
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un nom';
                    }
                    return null;
                  },
                ),
              ),
              ),

              const SizedBox(
                width: 20,
              ),

              Expanded(
                child: Padding(padding: const EdgeInsets.only( top:10 ,right: 8, left: 8, bottom: 10),
                  child: TextFormField(
                    controller: controllerChampPrenom,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prénom',
                        icon: Icon(Icons.account_box_outlined)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un prénom';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
            ),


            /* PARTIE Adresse, code postal et ville */


            Padding(padding: const EdgeInsets.only(right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampAdresse,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse',
                    icon: Icon(Icons.person_pin_circle_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer une adresse';
                  }
                  return null;
                },
              ),
            ),




            Row(children: [
              Expanded(child:
              Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                child:
                TextFormField(
                  controller: controllerChampCodePostal,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Code postal',
                      icon: Icon(Icons.domain_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un code postal';
                    }
                    if (value.length != 5) {
                      return 'Entrer un code postal valide';
                    }
                    return null;
                  },
                ),
              ),
              ),

              const SizedBox(
                width: 20,
              ),

              Expanded(
                child:
                Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                  child:
                  TextFormField(
                    controller: controllerChampVille,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ville',
                        icon: Icon(Icons.location_city_outlined)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer une ville';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
            ),

            /* PARTIE Numero de téléphone et EMAIl */


            Padding(padding: const EdgeInsets.only( right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampNumero,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro de téléphone',
                    icon: Icon(Icons.phone_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
            ),

            Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    icon: Icon(Icons.email_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty ) {
                    return 'Entrer une email';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),


            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Traitement des données ...')),
                  );

                  //checkSiClientEstDejaSet();
                }
              },
              child: const Text('Ajouter'),
            ),

          ],
        ),
      ),
    );
  }

  Widget buildFacture() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child:

        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            const SizedBox(
              height: 15,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(flex: 1, child: Icon(Icons.info_outline)),
                Expanded(flex: 4, child: Text('''Toutes les informations sont nécessaire pour la création d'un client.'''), ),
              ],
            ),

            const SizedBox(
              height: 15,
            ),

            const Divider(),

            /* PARTIE NOM ET PRENOM */

            Row(children: [
              Expanded(child:
              Padding(padding: const EdgeInsets.only( top:10, left: 8, bottom: 10),
                child: TextFormField(
                  controller: controllerChampNom,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom',
                      icon: Icon(Icons.account_box_outlined)
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un nom';
                    }
                    return null;
                  },
                ),
              ),
              ),

              const SizedBox(
                width: 20,
              ),

              Expanded(
                child: Padding(padding: const EdgeInsets.only( top:10 ,right: 8, left: 8, bottom: 10),
                  child: TextFormField(
                    controller: controllerChampPrenom,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prénom',
                        icon: Icon(Icons.account_box_outlined)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un prénom';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
            ),


            /* PARTIE Adresse, code postal et ville */


            Padding(padding: const EdgeInsets.only(right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampAdresse,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse',
                    icon: Icon(Icons.person_pin_circle_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer une adresse';
                  }
                  return null;
                },
              ),
            ),




            Row(children: [
              Expanded(child:
              Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                child:
                TextFormField(
                  controller: controllerChampCodePostal,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Code postal',
                      icon: Icon(Icons.domain_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un code postal';
                    }
                    if (value.length != 5) {
                      return 'Entrer un code postal valide';
                    }
                    return null;
                  },
                ),
              ),
              ),

              const SizedBox(
                width: 20,
              ),

              Expanded(
                child:
                Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                  child:
                  TextFormField(
                    controller: controllerChampVille,
                    keyboardType: TextInputType.streetAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ville',
                        icon: Icon(Icons.location_city_outlined)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer une ville';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
            ),

            /* PARTIE Numero de téléphone et EMAIl */


            Padding(padding: const EdgeInsets.only( right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampNumero,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro de téléphone',
                    icon: Icon(Icons.phone_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
            ),

            Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8),
              child:
              TextFormField(
                controller: controllerChampEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    icon: Icon(Icons.email_outlined)),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty ) {
                    return 'Entrer une email';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),


            ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Traitement des données ...')),
                  );

                  //checkSiClientEstDejaSet();
                }
              },
              child: const Text('Ajouter'),
            ),

          ],
        ),
      ),
    );
  }
}
