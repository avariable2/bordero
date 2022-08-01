import 'dart:convert';

import 'package:app_psy/main.dart';
import 'package:app_psy/model/infos_praticien.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

class FullScreenDialogInformationPraticien extends StatelessWidget {
  const FullScreenDialogInformationPraticien({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vos informations'),
      ),
      body: const DialogInfoPraticien(),
    );
  }
}

// Create a Form widget.
class DialogInfoPraticien extends StatefulWidget {
  const DialogInfoPraticien({super.key});

  @override
  DialogInfoPraticienState createState() {
    return DialogInfoPraticienState();
  }
}

class DialogInfoPraticienState extends State<DialogInfoPraticien> {
  final _formPersonnelKey = GlobalKey<FormState>();
  final _formProfessionelKey = GlobalKey<FormState>();

  List<TypePayement> listTypePayements = [
    TypePayement(key: "Virement bancaire", selectionner: false),
    TypePayement(key: "Liquide", selectionner: false),
    TypePayement(key: "Carte bleu", selectionner: false),
    TypePayement(key: "Chèque", selectionner: false)
  ];

  // Permet de recuperer les champs à la fin
  final controllerChampNom = TextEditingController();
  final controllerChampPrenom = TextEditingController();
  final controllerChampAdresse = TextEditingController();
  final controllerChampCodePostal = TextEditingController();
  final controllerChampVille = TextEditingController();
  final controllerChampNumero = TextEditingController();
  final controllerChampEmail = TextEditingController();
  final controllerChampNumeroSIRET = TextEditingController();
  final controllerChampNumeroADELI = TextEditingController();
  bool estExonererDeTVA = false;

  int _indexStepper = 0;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  void initState() {
    super.initState();

    _castTextToController();
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
    controllerChampNumeroSIRET.dispose();
    controllerChampNumeroADELI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.

    return Stepper(
      type: StepperType.horizontal,
      currentStep: _indexStepper,
      onStepCancel: () {
        if (_indexStepper > 0) {
          setStateIfMounted(() => _indexStepper--);
        }
      },
      onStepContinue: () {
        if (_indexStepper < 1 && _indexStepper >= 0) {
          if (_formPersonnelKey.currentState!.validate()) {
            setStateIfMounted(() => _indexStepper++);
          }
        } else if (_indexStepper == 1 &&
            _formProfessionelKey.currentState!.validate()) {
          Object obj = _creerInfosPraticien().toJson();
          SpUtil.putObject(InfosPraticien.keyObjInfosPraticien, obj);
          Navigator.of(context).pop();
          if (SpUtil.haveKey(InfosPraticien.keyObjInfosPraticien) ?? false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                  Text("Vos informations ont bien été modifiées.")),
            );
          } else {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const AppPsy(),

                ));
          }

        }
      },
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        return Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: const Text('CONTINUER'),
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: details.onStepCancel,
              child: const Text(
                'RETOUR',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ],
        );
      },
      steps: [
        Step(
            title: const Text("Personel"),
            isActive: _indexStepper >= 0,
            content: buildInfos()),
        Step(
            title: const Text("Professionel"),
            isActive: _indexStepper >= 1,
            content: buildProfessionel()),
      ],
    );
  }

  Widget buildInfos() {
    return SingleChildScrollView(
      child: Form(
        key: _formPersonnelKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                "Données globaux",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            /* PARTIE NOM ET PRENOM */

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampPrenom,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Prénom *',
                          icon: Icon(Icons.account_box_outlined)),
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

            Padding(
              padding: const EdgeInsets.only(),
              child: TextFormField(
                controller: controllerChampAdresse,
                keyboardType: TextInputType.streetAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Adresse *',
                    icon: Icon(Icons.person_pin_circle_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer une adresse';
                  }
                  return null;
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 10, right: 3),
                    child: TextFormField(
                      controller: controllerChampCodePostal,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Code postal *',
                          icon: Icon(Icons.domain_outlined)),
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampVille,
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Ville *',
                          icon: Icon(Icons.location_city_outlined)),
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

            Padding(
              padding: const EdgeInsets.only(),
              child: TextFormField(
                controller: controllerChampNumero,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numéro de téléphone *',
                    icon: Icon(Icons.phone_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer un numéro de téléphone';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: TextFormField(
                controller: controllerChampEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email *',
                    icon: Icon(Icons.email_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Entrer une email';
                  }
                  if (!EmailValidator.validate(value)) {
                    return 'Entrer une email valide';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfessionel() {
    return SingleChildScrollView(
        child: Form(
            key: _formProfessionelKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SwitchListTile(
                      title: const Text("Etes-vous exonéré de TVA ?"),
                      value: estExonererDeTVA,
                      onChanged: (bool value) =>
                          setStateIfMounted(() => estExonererDeTVA = value)),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampNumeroSIRET,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Numéro SIRET *',
                          hintText: "Il est composé de 9 chiffres",
                          icon: Icon(Icons.pin_outlined)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer un numéro de SIRET';
                        }
                        if (value.length != 9) {
                          return 'Entrer un numéro de SIRET valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: controllerChampNumeroADELI,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Code ADELI *',
                        icon: Icon(Icons.medical_information_outlined),
                        hintText: "Il est composé de 9 chiffres",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer une code ADELI';
                        }
                        if (value.length != 9) {
                          return 'Entrer un code ADELI valide';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    child: Text("Type de payement autorisé *",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(listTypePayements[0].key),
                          value: listTypePayements[0].selectionner,
                          onChanged: (bool? value) => {
                            setStateIfMounted(
                                () => listTypePayements[0].selectionner = !listTypePayements[0].selectionner)
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(listTypePayements[1].key),
                          value: listTypePayements[1].selectionner,
                          onChanged: (bool? value) => {
                            setStateIfMounted(
                                () => listTypePayements[1].selectionner = !listTypePayements[1].selectionner)
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(listTypePayements[2].key),
                          value: listTypePayements[2].selectionner,
                          onChanged: (bool? value) => {
                            setStateIfMounted(
                                    () => listTypePayements[2].selectionner = !listTypePayements[2].selectionner)
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(listTypePayements[3].key),
                          value: listTypePayements[3].selectionner,
                          onChanged: (bool? value) => {
                            setStateIfMounted(
                                    () => listTypePayements[3].selectionner = !listTypePayements[3].selectionner)
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ])));
  }

  InfosPraticien _creerInfosPraticien() {
    return InfosPraticien(
      nom: controllerChampNom.text.trim(),
      prenom: controllerChampPrenom.text.trim(),
      adresse: controllerChampAdresse.text.trim(),
      codePostal: controllerChampCodePostal.text.trim(),
      ville: controllerChampVille.text.trim(),
      numeroTelephone: controllerChampNumero.text.trim(),
      email: controllerChampEmail.text.trim(),
      numeroSIRET: int.parse(controllerChampNumeroSIRET.text.trim()),
      numeroADELI: int.parse(controllerChampNumeroADELI.text.trim()),
      exonererTVA: estExonererDeTVA,
      payements: jsonEncode(listTypePayements),
    );
  }

  void _castTextToController() {
    var info = SpUtil.getObj(
        InfosPraticien.keyObjInfosPraticien, (v) => InfosPraticien.fromJson(v));
    if (info != null) {
      controllerChampNom.text = info.nom;
      controllerChampPrenom.text = info.prenom;
      controllerChampAdresse.text = info.adresse;
      controllerChampCodePostal.text = info.codePostal;
      controllerChampVille.text = info.ville;
      controllerChampNumero.text = info.numeroTelephone;
      controllerChampEmail.text = info.email;
      controllerChampNumeroSIRET.text = info.numeroSIRET.toString();
      controllerChampNumeroADELI.text = info.numeroADELI.toString();
      estExonererDeTVA = info.exonererTVA;
      listTypePayements = TypePayement.getListTypePaymentFromDynamic(jsonDecode(info.payements));
    }
  }
}
