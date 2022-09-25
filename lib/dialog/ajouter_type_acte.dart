import 'package:bordero/utils/app_psy_utils.dart';
import 'package:bordero/db/app_psy_database.dart';
import 'package:flutter/material.dart';

import '../model/type_acte.dart';

class FullScreenDialogAjouterTypeActe extends StatelessWidget {
  const FullScreenDialogAjouterTypeActe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Création type de séance'),
      ),
      body: const DialogAjouterTypeActe(),
    );
  }
}


// Create a Form widget.
class DialogAjouterTypeActe extends StatefulWidget {
  const DialogAjouterTypeActe({super.key});

  @override
  DialogAjouterTypeActeState createState() {
    return DialogAjouterTypeActeState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class DialogAjouterTypeActeState extends State<DialogAjouterTypeActe> {

  final _formKey = GlobalKey<FormState>();

  // Permet de recuperer les champs à la fin
  final controllerChampNom = TextEditingController();
  final controllerChampPrix = TextEditingController();

  Future<void> checkSiTypeActeExiste()  async {
    await AppPsyDatabase.instance.readIfTypeActeIsAlreadySet(controllerChampNom.text)
        .then((value) => {
      if (value) {
        // Il y'a un doublon
        afficherDialogConfirmationCreationDoublon()
      } else {
        insertionTypeActeDansBDD()
      }
    });
  }

  void afficherDialogConfirmationCreationDoublon() {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: Text("Ce type d'acte existe déjà !", style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.primary,),),
            content: const Text("Il est préférable de modifier le type de séance déjà créé."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("OK"),
              ),
            ],
            elevation: 24.0,
          ),
    );
  }

  Future<void> insertionTypeActeDansBDD() async {
    TypeActe typeActe = TypeActe(
        nom: controllerChampNom.text.trim(),
        prix: AppPsyUtils.tryParseDouble(controllerChampPrix.text.trim()),
    );


    await AppPsyDatabase.instance.createTypeActe(typeActe).then((value) => {
      _afficherResultatSnackbarPuisRetourEnArriere(context, value)
    });
  }

  void _afficherResultatSnackbarPuisRetourEnArriere(BuildContext context, bool value) {
    if (value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le type de séance a bien été enregistré')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oups ! Une erreur s\'est produite =(')),
      );
    }

    Navigator.pop(context, 'OK');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [


              const SizedBox(
                height: 20,
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                Expanded(flex: 1, child: Icon(Icons.info_outline)),
                Expanded(flex: 4, child: Text('''Toutes les informations sont nécessaires pour la création d'un type de séance.'''), ),
                ],
              ),

              const SizedBox(
              height: 15,
              ),

              const Divider(),

              Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child:
                TextFormField(
                  controller: controllerChampNom,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom de la séance',
                      icon: Icon(Icons.assignment_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrez un nom de séance';
                    }
                    return null;
                  },
                ),
              ),


              const SizedBox(
                height: 15,
              ),


              Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child:
                TextFormField(
                  controller: controllerChampPrix,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Prix HT',
                      icon: Icon(Icons.euro_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty || !AppPsyUtils.isNumeric(value)) {
                      return 'Entrez un prix vraisemblable';
                    }
                    return null;
                  },
                ),
              ),


              const SizedBox(
                height: 15,
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

                    checkSiTypeActeExiste();
                  }
                },
                child: const Text('Ajouter'),
              ),
            ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    controllerChampNom.dispose();
    controllerChampPrix.dispose();
    super.dispose();
  }

}