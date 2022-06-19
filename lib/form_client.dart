import 'package:app_psy/db/client_database.dart';
import 'package:email_validator/email_validator.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/client.dart';


// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Permet de recuperer les champs à la fin
  final controllerChampNom = TextEditingController();
  final controllerChampPrenom = TextEditingController();
  final controllerChampAdresse = TextEditingController();
  final controllerChampCodePostal = TextEditingController();
  final controllerChampVille = TextEditingController();
  final controllerChampNumero = TextEditingController();
  final controllerChampEmail = TextEditingController();

  void showDialogValidInsert() {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: const Text("Ce client existe déjà !"),
              content: const Text("Voulez-vous vraiment l'ajouter (il se peut que 2 clients possède le meme nom et prenom)."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text("Non"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                    insertClientInDatabase();
                  },
                  child: const Text("Oui"),),
              ],
              elevation: 24.0,
            ),
    );
  }

  Future<void> insertClientInDatabase() async {
    Client c = Client(
        nom: controllerChampNom.text,
        prenom: controllerChampPrenom.text,
        adresse: controllerChampAdresse.text,
        codePostal: controllerChampCodePostal.text,
        ville: controllerChampVille.text,
        numeroTelephone: controllerChampNumero.text,
        email: controllerChampEmail.text
    );


    await ClientDatabase.instance.create(c).then((value) => {
      // Le client a bien été enregistrer
      if (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${controllerChampPrenom.text.toUpperCase()} à bien été ajouté')),
        )
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Oups ! Une erreur sait produite =(')),
        )
      }
    });
  }

  Future<void> checkIfUserIsAlreadySet() async {
    await ClientDatabase.instance.readIfClientIsAlreadySet(controllerChampNom.text, controllerChampPrenom.text)
        .then((value) => {
          if (value) {
            showDialogValidInsert()

          } else {
            // on fait rien

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Le pelo existe pas')),
            )
          }
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerChampNom.dispose();
    controllerChampPrenom.dispose();
    controllerChampAdresse.dispose();
    controllerChampCodePostal.dispose();
    controllerChampVille.dispose();
    controllerChampNumero.dispose();
    controllerChampEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
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
                  if (!EmailValidator.validate(value)) {
                    return 'Entrer une email valide';
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

                  checkIfUserIsAlreadySet();
                }
              },
              child: const Text('Enregistrer'),
            ),

          ],
        ),
      ),
    );

  }
}