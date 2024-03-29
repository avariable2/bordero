import 'package:bordero/db/app_psy_database.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../model/client.dart';

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

// Create a Form widget.
class DialogAjouterClient extends StatefulWidget {
  const DialogAjouterClient({super.key});

  @override
  DialogAjouterClientState createState() {
    return DialogAjouterClientState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class DialogAjouterClientState extends State<DialogAjouterClient> {
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

  void afficherDialogConfirmationCreationDoublon() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Ce client existe déjà !",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            )),
        content: const Text(
            "Voulez-vous vraiment l'ajouter (il se peut que 2 clients possèdent le même nom et prénom)."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text("Non"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              insertionClientDansBDD();
            },
            child: const Text("Oui"),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  Future<void> insertionClientDansBDD() async {
    Client c = Client(
        nom: controllerChampNom.text.trim(),
        prenom: controllerChampPrenom.text.trim(),
        adresse: controllerChampAdresse.text.trim(),
        codePostal: controllerChampCodePostal.text.trim(),
        ville: controllerChampVille.text.trim(),
        numeroTelephone: controllerChampNumero.text.trim(),
        email: controllerChampEmail.text.trim());

    await AppPsyDatabase.instance.createClient(c).then((value) => {
          // Le client a bien été enregistré
          if (value)
            {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        '${controllerChampPrenom.text.toUpperCase()} a bien été ajouté')),
              )
            }
          else
            {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Oups ! Une erreur s\'est produite =(')),
              )
            }
        });
  }

  /// Methode asynchrone pour verifier que l'utilisateur n'est pas déjà présent dans la base de donnée.
  Future<void> checkSiClientEstDejaSet() async {
    await AppPsyDatabase.instance
        .readIfClientIsAlreadySet(
            controllerChampNom.text, controllerChampPrenom.text)
        .then((value) => {
              if (value)
                {
                  // Il y'a un doublon
                  afficherDialogConfirmationCreationDoublon()
                }
              else
                {insertionClientDansBDD()}
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Expanded(flex: 1, child: Icon(Icons.info_outline)),
                Expanded(
                  flex: 4,
                  child:
                      Text('''Les champs marqués avec (*) sont obligatoires.'''),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Divider(),

            /* PARTIE NOM ET PRENOM */

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 8, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampNom,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nom *',
                          icon: Icon(Icons.account_box_outlined)),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez un nom';
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 8, left: 8, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampPrenom,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Prénom *',
                          icon: Icon(Icons.account_box_outlined)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrez un prénom';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),

            /* PARTIE Adresse, code postal et ville */

            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: TextFormField(
                controller: controllerChampAdresse,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse',
                    icon: Icon(Icons.person_pin_circle_outlined)),
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez une adresse';
                  }
                  return null;
                },*/
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 8, left: 8, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampCodePostal,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Code postal',
                          icon: Icon(Icons.domain_outlined)),
                      /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez un code postal';
                      }
                      if (value.length != 5) {
                        return 'Entrez un code postal valide';
                      }
                      return null;
                    },*/
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 8, left: 8, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampVille,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ville',
                          icon: Icon(Icons.location_city_outlined)),
                      /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrez une ville';
                      }
                      return null;
                    },*/
                    ),
                  ),
                ),
              ],
            ),

            /* PARTIE Numero de téléphone et EMAIl */

            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: TextFormField(
                controller: controllerChampNumero,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro de téléphone',
                    icon: Icon(Icons.phone_outlined)),
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un numéro de téléphone';
                  }
                  return null;
                },*/
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, right: 8, left: 8),
              child: TextFormField(
                controller: controllerChampEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email *',
                    icon: Icon(Icons.email_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrez un email';
                  }
                  if (!EmailValidator.validate(value.trim())) {
                    return 'Entrez un email valide';
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
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Traitement des données ...')),
                  );

                  checkSiClientEstDejaSet();
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
