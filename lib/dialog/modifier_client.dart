import 'package:bordero/db/app_psy_database.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../model/client.dart';

class FullScreenDialogModifierClient extends StatelessWidget {
  final Client client;
  const FullScreenDialogModifierClient({Key? key, required this.client,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification client'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              _afficherAvertissementSuppression(context, client);
            },
          )
        ],
      ),
      body: DialogModifierClient(client: client,),
    );
  }

  void _afficherAvertissementSuppression(BuildContext context, Client client) {


    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text("Attention : êtes-vous sûr de vouloir supprimer ce client ?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: Theme.of(context).colorScheme.primary,
                )
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("ANNULER"),
              ),
              TextButton(
                onPressed: () {
                  _deleteClientDansBDD(context);
                },
                child: const Text("SUPPRIMER"),),
            ],
            elevation: 24.0,
          ),
    );
  }

  Future<void> _deleteClientDansBDD(BuildContext context) async {
    await AppPsyDatabase.instance.deleteClient(client.id!).then((value) => {
      _afficherResultatSnackbarPuisRetourEnArriere(context, value),
    });
  }

  void _afficherResultatSnackbarPuisRetourEnArriere(BuildContext context, int value) {
    // Le client a bien été modifier
    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${client.prenom.toUpperCase()} a bien été supprimé')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oups ! Une erreur s\'est produite =(')),
      );
    }
    // 2 fois car on ferme le dialog et la fenetre avant
    Navigator.pop(context, 'OK');
    Navigator.pop(context, 'OK');
  }

}


// Create a Form widget.
class DialogModifierClient extends StatefulWidget {
  final Client client;
  const DialogModifierClient({super.key, required this.client});

  @override
  DialogModifierClientState createState() {
    return DialogModifierClientState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class DialogModifierClientState extends State<DialogModifierClient> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Permet de recuperer les champs à la fin
  final _controllerChampNom = TextEditingController();
  final _controllerChampPrenom = TextEditingController();
  final _controllerChampAdresse = TextEditingController();
  final _controllerChampCodePostal = TextEditingController();
  final _controllerChampVille = TextEditingController();
  final _controllerChampNumero = TextEditingController();
  final _controllerChampEmail = TextEditingController();

  void afficherDialogConfirmationCreationDoublon() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text("Ce client existe déjà !",style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Theme.of(context).colorScheme.primary,),),
            content: const Text("Voulez-vous vraiment l'ajouter (il se peut que 2 clients possèdent le même nom et prénom)."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("Non"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, 'OK');
                  updateClientDansBDD();
                },
                child: const Text("Oui"),),
            ],
            elevation: 24.0,
          ),
    );
  }

  Future<void> updateClientDansBDD() async {
    Client c = Client(
        id: widget.client.id,
        nom: _controllerChampNom.text.trim(),
        prenom: _controllerChampPrenom.text.trim(),
        adresse: _controllerChampAdresse.text.trim(),
        codePostal: _controllerChampCodePostal.text.trim(),
        ville: _controllerChampVille.text.trim(),
        numeroTelephone: _controllerChampNumero.text.trim(),
        email: _controllerChampEmail.text.trim()
    );

    await AppPsyDatabase.instance.updateClient(c).then((value) => {
      afficherResultatSnackbar(value)
    });
  }

  void afficherResultatSnackbar(int value) {
    // Le client a bien été modifier
    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${_controllerChampPrenom.text.trim().toUpperCase()} a bien été modifié')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oups ! Une erreur s\'est produite =(')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _controllerChampNom.text = widget.client.nom;
    _controllerChampPrenom.text = widget.client.prenom;
    _controllerChampAdresse.text = widget.client.adresse ?? '';
    _controllerChampCodePostal.text = widget.client.codePostal ?? '';
    _controllerChampVille.text = widget.client.ville ?? '';
    _controllerChampNumero.text = widget.client.numeroTelephone ?? '';
    _controllerChampEmail.text = widget.client.email;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerChampNom.dispose();
    _controllerChampPrenom.dispose();
    _controllerChampAdresse.dispose();
    _controllerChampCodePostal.dispose();
    _controllerChampVille.dispose();
    _controllerChampNumero.dispose();
    _controllerChampEmail.dispose();
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
                Expanded(flex: 4, child: Text('''Les champs marqués avec (*) sont obligatoires.'''), ),
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
                  controller: _controllerChampNom,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom *',
                      icon: Icon(Icons.account_box_outlined)
                  ),
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
                    controller: _controllerChampPrenom,
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


            Padding(padding: const EdgeInsets.only(right: 8, left: 8),
              child:
              TextFormField(
                controller: _controllerChampAdresse,
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




            Row(children: [
              Expanded(child:
              Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                child:
                TextFormField(
                  controller: _controllerChampCodePostal,
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
                child:
                Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8, bottom: 10),
                  child:
                  TextFormField(
                    controller: _controllerChampVille,
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


            Padding(padding: const EdgeInsets.only( right: 8, left: 8),
              child:
              TextFormField(
                controller: _controllerChampNumero,
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

            Padding(padding: const EdgeInsets.only(top:10, right: 8, left: 8),
              child:
              TextFormField(
                controller: _controllerChampEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email *',
                    icon: Icon(Icons.email_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty ) {
                    return 'Entrez un email';
                  }
                  if (!EmailValidator.validate(value)) {
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
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Traitement des données ...')),
                  );

                  updateClientDansBDD();
                }
              },
              child: const Text('Sauvegarder'),
            ),

          ],
        ),
      ),
    );

  }
}