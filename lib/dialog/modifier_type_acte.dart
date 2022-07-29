import 'package:app_psy/utils/app_psy_utils.dart';
import 'package:app_psy/db/app_psy_database.dart';
import 'package:flutter/material.dart';

import '../model/type_acte.dart';

class FullScreenDialogModifierTypeActe extends StatelessWidget {
  final TypeActe typeActe;
  const FullScreenDialogModifierTypeActe({Key? key, required this.typeActe,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modification type de séance'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            onPressed: () {
              _afficherAvertissementSuppression(context, typeActe);
            },
          )
        ],
      ),
      body: DialogModifierTypeActe(typeActe: typeActe,),
    );
  }

  void _afficherAvertissementSuppression(BuildContext context, TypeActe typeActe) {
    var richText = RichText(
      text: const TextSpan(
          style: TextStyle(
            fontSize: 22.0,
          ),
          children: <TextSpan> [
            TextSpan(text: "Attention",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                )
            ),
            TextSpan(text: " : êtes-vous sur de vouloir supprimer se type de séance ?"),
          ]
      ),
    );


    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: richText,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text("Non"),
              ),
              TextButton(
                onPressed: () {
                  _deleteTypeActeDansBDD(context);
                },
                child: const Text("Oui"),),
            ],
            elevation: 24.0,
          ),
    );
  }

  Future<void> _deleteTypeActeDansBDD(BuildContext context) async {
    await AppPsyDatabase.instance.deleteTypeActe(typeActe.id!).then((value) => {
      _afficherResultatSnackbarPuisRetourEnArriere(context, value),
    });
  }

  void _afficherResultatSnackbarPuisRetourEnArriere(BuildContext context, int value) {
    // Le client a bien été modifier
    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("'${typeActe.nom.trim()}' à bien été supprimer")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oups ! Une erreur sait produite =(')),
      );
    }
    // 2 fois car on ferme le dialog et la fenetre avant
    Navigator.pop(context, 'OK');
    Navigator.pop(context, 'OK');
  }
}


// Create a Form widget.
class DialogModifierTypeActe extends StatefulWidget {
  final TypeActe typeActe;
  const DialogModifierTypeActe({super.key, required this.typeActe});

  @override
  DialogModifierTypeActeState createState() {
    return DialogModifierTypeActeState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class DialogModifierTypeActeState extends State<DialogModifierTypeActe> {

  final _formKey = GlobalKey<FormState>();

  // Permet de recuperer les champs à la fin
  final _controllerChampNom = TextEditingController();
  final _controllerChampPrix = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controllerChampNom.text = widget.typeActe.nom;
    _controllerChampPrix.text = widget.typeActe.prix.toString();
  }

  Future<void> _updateTypeActeDansBDD() async {
    TypeActe typeActe = TypeActe(
      id: widget.typeActe.id,
      nom: _controllerChampNom.text.trim(),
      prix: AppPsyUtils.tryParseDouble(_controllerChampPrix.text),
    );


    await AppPsyDatabase.instance.updateTypeActe(typeActe).then((value) => {
      _afficherResultatSnackbarPuisRetourEnArriere(context, value)
    });
  }

  void _afficherResultatSnackbarPuisRetourEnArriere(BuildContext context, int value) {
    if (value > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le type de séance à bien été modifier')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Oups ! Une erreur sait produite =(')),
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
                  Expanded(flex: 4, child: Text('''Toutes les informations sont nécessaire pour la modification d'un type de séance.'''), ),
                ],
              ),

              const SizedBox(
                height: 15,
              ),

              const Divider(),

              Padding(padding: const EdgeInsets.only(right: 8, left: 8),
                child:
                TextFormField(
                  controller: _controllerChampNom,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nom de la séance',
                      icon: Icon(Icons.assignment_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un nom de séance';
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
                  controller: _controllerChampPrix,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Prix',
                      icon: Icon(Icons.euro_outlined)),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty || !AppPsyUtils.isNumeric(value)) {
                      return 'Entrer un prix vraisemblable';
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

                    _updateTypeActeDansBDD();
                  }
                },
                child: const Text('Enregistrer'),
              ),
            ]
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controllerChampNom.dispose();
    _controllerChampPrix.dispose();
    super.dispose();
  }

}