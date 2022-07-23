import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class FullScreenDialogInformationPraticien extends StatelessWidget {
  const FullScreenDialogInformationPraticien({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations obligatoire à renseigner'),
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
  final _formKey = GlobalKey<FormState>();

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
  int _indexStepper = 0;

  void setStateIfMounted(f) {
    if (mounted) setState(f);
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
          setStateIfMounted(() => _indexStepper++);
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
            content: Container()),
      ],
    );
  }

  Widget buildInfos() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
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
              padding: const EdgeInsets.only(right: 8, left: 8),
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
                    padding: const EdgeInsets.only(
                        top: 10, right: 8, left: 8, bottom: 10),
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
                    padding: const EdgeInsets.only(
                        top: 10, right: 8, left: 8, bottom: 10),
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
              padding: const EdgeInsets.only(right: 8, left: 8),
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
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Données globaux",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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


                ])));
  }
}

class InfosPraticien {
  static String keyObjInfosPraticien = "keyObjInfosPraticien";
}
