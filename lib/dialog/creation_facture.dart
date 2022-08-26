import 'dart:io';

import 'package:bordero/dialog/preview_pdf.dart';
import 'package:bordero/model/facture.dart';
import 'package:bordero/model/seance.dart';
import 'package:bordero/model/type_acte.dart';
import 'package:bordero/utils/app_psy_utils.dart';
import 'package:bordero/utils/pdf_facture_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:signature/signature.dart';

import '../component/list_recherche_action.dart';
import '../db/app_psy_database.dart';
import '../model/client.dart';

class FullScreenDialogCreationFacture extends StatelessWidget {
  const FullScreenDialogCreationFacture({
    Key? key,
  }) : super(key: key);

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
  State<FormulaireCreationFacture> createState() =>
      _FormulaireCreationFactureState();
}

class _FormulaireCreationFactureState extends State<FormulaireCreationFacture> {
  DateTime _dateEmission = DateTime.now();
  DateTime _dateLimitePayement = DateTime.now();

  final _formKeySeance = GlobalKey<FormState>();
  final _formKeyFacture = GlobalKey<FormState>();
  final _controllerChampDate = TextEditingController();
  final _controllerChampPrix = TextEditingController();
  final _controllerChampNombreUH = TextEditingController();
  final _controllerNumeroFacture = TextEditingController();
  final _controllerChampDateLimitePayement = TextEditingController();
  final _controllerSignature = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white70);

  late List<Client> _listClients;
  late List<TypeActe> _listTypeActes;
  final List<Client> _clientSelectionner = [];
  final List<Seance> _listSeances = [];

  int _indexStepper = 0;
  bool _isLoading = false;
  bool _aUneDateLimite = false;

  late String _dropdownSelectionnerTypeActe;

  @override
  void initState() {
    super.initState();
    _getListClients();

    _controllerChampDate.text = AppPsyUtils.toDateString(_dateEmission);
    _controllerChampNombreUH.text = "1";
  }

  @override
  void dispose() {
    super.dispose();

    _controllerChampDate.dispose();
    _controllerChampPrix.dispose();
    _controllerChampNombreUH.dispose();
    _controllerNumeroFacture.dispose();
    _controllerChampDateLimitePayement.dispose();
    _controllerSignature.dispose();
  }

  /// Pour empecher les fuites memoires et les potenciel bugs.
  /// Uniquement pour les setState dans une fonction await
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Stepper(
            type: StepperType.horizontal,
            currentStep: _indexStepper,
            onStepCancel: () {
              if (_indexStepper > 0) {
                setStateIfMounted(() => _indexStepper--);
              }
            },
            onStepContinue: () {
              if (_indexStepper < 2 && _indexStepper >= 0) {
                if (_checkConditionsPourContinuer()) {
                  setStateIfMounted(() => _indexStepper++);
                } else {
                  _afficherAvertissementEtConditionPourPoursuivre();
                }
              } else if (_indexStepper == 2) {
                if (_formKeyFacture.currentState!.validate()) {
                  //_afficherAvertissementEtConditionPourPoursuivre();
                  _creationPdfEtOuverture(_aUneDateLimite);
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
                    child: const Text('RETOUR'),
                  ),
                ],
              );
            },
            steps: [
              Step(
                  title: const Text("Client(s)"),
                  isActive: _indexStepper >= 0,
                  content: buildClient()),
              Step(
                  title: const Text("Séance(s)"),
                  isActive: _indexStepper >= 1,
                  content: buildSeance()),
              Step(
                  title: const Text("Facture"),
                  isActive: _indexStepper >= 2,
                  content: buildFacture())
            ],
          );
  }

  Widget buildClient() {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children:[
        ListRechercheEtAction(
          titre: 'Sélectionner client(s)',
          icon: Icons.account_circle_sharp,
          labelTitreRecherche: 'Recherche client',
          labelHintRecherche: 'Essayer le nom ou prénom du client',
          labelListVide: '🤔​ Aucun client enregistré',
          list: _listClients,
          onSelectedItem: (dynamic item) {
            setStateIfMounted(() => {
              _clientSelectionner.contains(item) ? _clientSelectionner.remove(item) : _clientSelectionner.add(item),
            });
          },
          needSelectedItem: true,
          needRecherche: true,
          filterChipsNames: const [],
        ),
        const Divider(
          height: 30,
        ),
        for (Client client in _clientSelectionner)
          Text(" - ${client.nom} ${client.prenom} / ${client.email}"),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildSeance() {
    return SingleChildScrollView(
      child: Form(
        key: _formKeySeance,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child: DropdownButtonFormField(
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Sélectionnez un type de séance";
                        }
                        return null;
                      },
                      hint: const Text(
                          "Le service que vous avez rendu a votre client"),
                      isExpanded: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Type d'acte",
                          icon: Icon(Icons.assignment_outlined)),
                      value: _dropdownSelectionnerTypeActe,
                      items: _listTypeActes
                          .map((typeActe) => DropdownMenuItem(
                                value: typeActe.nom,
                                child: Text(
                                    //overflow: TextOverflow.,
                                    typeActe.nom.toString()),
                              ))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          _dropdownSelectionnerTypeActe = value!;
                          _afficherPrixDansController();
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 10),
                    child: TextFormField(
                      controller: _controllerChampPrix,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Prix HT',
                          icon: Icon(Icons.euro_outlined)),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer un prix HT';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _controllerChampDate,
                      keyboardType: TextInputType.datetime,
                      enableInteractiveSelection: false,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        _selectDateSeance();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Date d'emission",
                          icon: Icon(Icons.date_range_outlined)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: TextFormField(
                      controller: _controllerChampNombreUH,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Quantité',
                          icon: Icon(Icons.onetwothree_outlined)),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Entrer un nombre valide';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKeySeance.currentState!.validate()) {
                  setState(() => _ajouterSeance());
                }
              },
              label: const Text("AJOUTER"),
              icon: const Icon(Icons.add),
            ),
            const Divider(),
            SizedBox(
              height: 200,
              child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  addAutomaticKeepAlives: false,
                  children: [
                    for (Seance seance in _listSeances)
                      Card(
                        child: ListTile(
                          title: Text(
                              "${seance.quantite} ${seance.nom} le (${seance.date.day}/${seance.date.month}/${seance.date.year})"),
                          leading: const Icon(Icons.work_history_outlined),
                          onTap: () {
                            _afficherAvertissementAvantSuppression(seance);
                          },
                        ),
                      ),
                  ]),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget buildFacture() {
    return SingleChildScrollView(
      child: Form(
        key: _formKeyFacture,
        child: Column(children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: TextFormField(
                    controller: _controllerNumeroFacture,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Numero de facture',
                        icon: Icon(Icons.numbers_outlined)),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un numéro de facture';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Switch(
                  value: _aUneDateLimite,
                  onChanged: (bool value) {
                    setState(() => _aUneDateLimite = !_aUneDateLimite);
                  }),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: TextFormField(
                    enabled: _aUneDateLimite,
                    controller: _controllerChampDateLimitePayement,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.datetime,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      _selectDateLimitePayement();
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Date limite de payement",
                        icon: Icon(Icons.date_range_outlined)),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Signature",
              style: TextStyle(fontSize: 18),
            ),
          ),
          buildSignature(),
          const SizedBox(
            height: 20,
          )
        ]),
      ),
    );
  }

  Widget buildSignature() {
    return Row(
      children: [
        ClipRect(
          child: SizedBox(
            height: 100,
            child: Signature(
              width: 200,
              height: 100,
              controller: _controllerSignature,
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() => _controllerSignature.clear());
            },
            icon: const Icon(Icons.refresh_outlined))
      ],
    );
  }

  /// Il affiche une boîte de dialogue avec un message d'avertissement et deux
  /// boutons, un pour annuler l'action et un pour la confirmer
  ///
  /// Args:
  ///   seance (Seance): l'objet qui sera supprimé
  void _afficherAvertissementAvantSuppression(Seance seance) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Supprimer cette séance ?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Theme.of(context).colorScheme.primary,
            )),
        content: const Text("Vous pourrez la recréer par la suite."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'RETOUR'),
            child: const Text("ANNULER"),
          ),
          TextButton(
            onPressed: () {
              _supprimerSeances(seance);
            },
            child: const Text(
              "SUPPRIMER",
            ),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  void _supprimerSeances(Seance seance) {
    setState(() {
      _listSeances.remove(seance);
    });
    Navigator.pop(context, 'SUPPRIMER');
  }

  void _ajouterSeance() {
    Seance s = Seance(
      nom: _dropdownSelectionnerTypeActe.trim(),
      date: _dateEmission,
      prix: AppPsyUtils.tryParseDouble(_controllerChampPrix.text.trim()),
      quantite: int.parse(_controllerChampNombreUH.text.trim()),
      uniteTemps: null,
    );
    _listSeances.add(s);
  }

  void _afficherPrixDansController() {
    var res = _getTypeActeDepuisNomTypeActe();
    if (res != null) {
      _controllerChampPrix.text = res.prix.toString();
    }
  }

  TypeActe? _getTypeActeDepuisNomTypeActe() {
    for (TypeActe ta in _listTypeActes) {
      if (ta.nom == _dropdownSelectionnerTypeActe) {
        return ta;
      }
    }
    return null;
  }

  void _selectDateSeance() async {
    final DateTime? newDate = await showDatePicker(
      cancelText: "ANNULER",
      context: context,
      initialDate: _dateEmission,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
      helpText: 'Selectionner une date',
    );
    if (newDate != null) {
      setStateIfMounted(() {
        _dateEmission = newDate;
        _controllerChampDate.text =
            "${_dateEmission.day}/${_dateEmission.month}/${_dateEmission.year}";
      });
    }
  }

  void _selectDateLimitePayement() async {
    final DateTime? newDate = await showDatePicker(
      cancelText: "ANNULER",
      context: context,
      initialDate: _dateLimitePayement,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: 'Selectionner une date limite de payement',
    );
    if (newDate != null) {
      setStateIfMounted(() {
        _dateLimitePayement = newDate;
        _controllerChampDateLimitePayement.text =
            "${_dateLimitePayement.day}/${_dateLimitePayement.month}/${_dateLimitePayement.year}";
      });
    }
  }

  Future _getListClients() async {
    setState(() => _isLoading = true);

    await AppPsyDatabase.instance.readAllClient().then((value) => {
          if (value.isNotEmpty)
            {
              _listClients = value,
            }
          else
            {
              _listClients = [],
            }
        });

    await AppPsyDatabase.instance.readAllTypeActe().then((value) => {
          if (value.isNotEmpty)
            {
              _listTypeActes = value,
              _dropdownSelectionnerTypeActe = _listTypeActes[0].nom,
              _afficherPrixDansController(),
            }
          else
            {
              _listTypeActes = [],
              _dropdownSelectionnerTypeActe = "",
            }
        });

    setState(() => _isLoading = false);
  }

  void _afficherAvertissementEtConditionPourPoursuivre() {
    var title = "✋ Vous allez trop vite";
    var body = "Verifiez les informations saisies.";
    if (_clientSelectionner.isEmpty) {
      title = "✋ Il faut d'abord séléctionner un client";
      body = "Assurez-vous de selectionner au moins un client.";
    } else if (_listSeances.isEmpty) {
      title = "⛔ Il faut au moins ajouter une séance";
      body =
          "Assurez-vous d'enregistrer au moins une séance pour votre/vos client(s) et cliqué sur ajouter. Ils vous suffit de remplir tous les champs.";
    } else if (_indexStepper == 2) {
      title = "Remplissez tous les champs";
      body =
          "Assurez-vous de remplir bien le bon numero de facture et une signature.";
    }

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 22.0,
          color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,)),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'RETOUR'),
            child: const Text("OK"),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  bool _checkConditionsPourContinuer() {
    switch (_indexStepper) {
      case 0:
        if (_clientSelectionner.isEmpty) {
          return false;
        }
        return true;
      case 1:
        if (_listSeances.isEmpty) {
          return false;
        }
        return true;
      default:
        return false;
    }
  }

  Future<void> _creationPdfEtOuverture(bool aDateLimite) async {
    CreationFacture donnesPourFacture = CreationFacture(
        id: _controllerNumeroFacture.text,
        dateCreationFacture: DateTime.now(),
        listClients: _clientSelectionner,
        listSeances: _listSeances,
        dateLimitePayement: aDateLimite == true ? _dateLimitePayement : null,
        signaturePNG: await _controllerSignature.toPngBytes());

    PdfFactureApi.generate(donnesPourFacture).then((value) {
      if (value == null) {
        return afficherErreur();
      }
      checkSiFactureDejaCreerEtAjout(value);
    });
  }

  void ajoutFactureFileDansBDD(File fichier) async {
    Facture facture = Facture(
        nom: path.basename(fichier.path), fichier: fichier.readAsBytesSync());
    await AppPsyDatabase.instance.createFactureInDB(facture).then((value) => {
          if (!value)
            {
              afficherErreur(),
            }
          else
            {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PreviewPdf(
                        idFacture: PreviewPdf.idPasEncoreConnu,
                        fichier: fichier,
                      ))),
            }
        });
  }

  Future<void> checkSiFactureDejaCreerEtAjout(File fichier) async {
    await AppPsyDatabase.instance
        .readIfFactureIsAlreadySet(path.basename(fichier.path))
        .then((value) => {
              if (value != null)
                {
                  afficherDialogConfirmationModification(fichier, value),
                }
              else
                {ajoutFactureFileDansBDD(fichier)}
            });
  }

  changerFactureDansBDD(File fichier, Facture facture) async {
    Facture nouvelleFacture = Facture(
        id: facture.id,
        nom: path.basename(fichier.path),
        fichier: fichier.readAsBytesSync());
    await AppPsyDatabase.instance
        .updateFacture(nouvelleFacture)
        .then((value) => {
              if (value == 1)
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PreviewPdf(
                            idFacture: facture.id!,
                            fichier: fichier,
                          ))),
                }
              else
                {
                  afficherErreur(),
                }
            });
  }

  afficherDialogConfirmationModification(File fichier, Facture facture) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Cette facture existe déjà !", style: TextStyle(color: Theme.of(context).colorScheme.primary,)),
        content: const Text(
            "Voulez-vous vraiment modifier cette facture ? Il est impossible de modifier une facture sur Bordero sauf si c'est le jour même. Nous déclinons de toutes responsabilités en cas de fraude."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text("ANNULER"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, 'OK');
              changerFactureDansBDD(fichier, facture);
            },
            child: const Text("MODIFIER"),
          ),
        ],
        elevation: 24.0,
      ),
    );
  }

  void afficherErreur() {
    var snackbar = const SnackBar(
        content:
            Text("Il viens de se produire une erreur, nous sommes désolé."));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
