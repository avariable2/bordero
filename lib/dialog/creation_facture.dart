import 'package:app_psy/model/seance.dart';
import 'package:app_psy/model/type_acte.dart';
import 'package:app_psy/utils/app_psy_utils.dart';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

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
  DateTime _dateEmission = DateTime(2020, 11, 17);
  DateTime _dateLimitePayement = DateTime(2020, 11, 17);

  final _formKey = GlobalKey<FormState>();
  final _formKeyFacture = GlobalKey<FormState>();
  final _controllerChampDate = TextEditingController();
  final _controllerChampPrix = TextEditingController();
  final _controllerChampNombreUH = TextEditingController();
  final _controllerNumeroFacture = TextEditingController();
  final _controllerChampDateLimitePayement = TextEditingController();

  late List<Client> _listClients;
  late List<TypeActe> _listTypeActes;
  final List<Client> _clientSelectionner = [];
  late List<bool> _selected;
  final List<Seance> _listSeances = [];

  int _indexStepper = 0;
  bool _isLoading = false;
  bool _aUneDateLimite = false;
  late String _dropdownSelectionnerTypeActe;
  String _dropdownSelectionnerUnite = "Heure";



  /// POUR CREER LE PDF
  /// https://www.google.com/search?q=create+facture+flutter&rlz=1C1CHZN_frFR980FR980&oq=create+facture+flutter&aqs=chrome..69i57j0i22i30.8424j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_ITnMYuiTI4f_lwSe-o-YAw18


  void _afficherAvertissementAvantSuppression(Seance seance) {
    var richText = RichText(
      text: const TextSpan(
          style: TextStyle(
            fontSize: 22.0,
          ),
          children: <TextSpan> [
            TextSpan(text: "Attention",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                )
            ),
          ]
      ),
    );


    showDialog(
      context: context,
      builder: (BuildContext context) =>
          AlertDialog(
            title: richText,
            content: const Text("Etes-vous sur de vouloir supprimer cette séance ?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, 'RETOUR'),
                child: const Text("RETOUR"),
              ),
              TextButton(
                onPressed: () {
                  _supprimerSeances(seance);
                },
                child: const Text("OUI", style: TextStyle(color: Colors.white,),),
              ),
            ],
            elevation: 24.0,
          ),
    );
  }

  void _supprimerSeances(Seance seance) {
    _listSeances.remove(seance);
    Navigator.pop(context, 'SUPPRIMER');
  }

  void _ajouterSeance() {
      Seance s = Seance(
          nom: _dropdownSelectionnerTypeActe,
          date: _dateEmission,
          prix: AppPsyUtils.tryParseDouble(_controllerChampPrix.text),
          uniteTemps: _dropdownSelectionnerUnite.toString(),
          nombreUniteTemps: int.parse(_controllerChampNombreUH.text)
      );
      _listSeances.add(s);
  }

  void _afficherPrixDansController() {
    var res =  _getTypeActeDepuisNomTypeActe();
    if ( res != null) {
      _controllerChampPrix.text = res.prix.toString();
    }
  }

  TypeActe? _getTypeActeDepuisNomTypeActe() {
    for(TypeActe ta in _listTypeActes) {
      if (ta.nom == _dropdownSelectionnerTypeActe)  {
        return ta;
      }
    }
    return null;
  }

  void _selectDate() async {
    final DateTime? newDate = await showDatePicker(
      cancelText: "ANNULER",
      context: context,
      initialDate: _dateEmission,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: 'Selectionner une date',
    );
    if (newDate != null) {
      setState(() {
        _dateEmission = newDate;
        _controllerChampDate.text = "${_dateEmission.day}/${_dateEmission.month}/${_dateEmission.year}";
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
      setState(() {
        _dateLimitePayement = newDate;
        _controllerChampDateLimitePayement.text = "${_dateLimitePayement.day}/${_dateLimitePayement.month}/${_dateLimitePayement.year}";
      });
    }
  }

  Future _getListClients() async {
    setState(() => _isLoading = true);

    await AppPsyDatabase.instance.readAllClient().then((value) => {
      if (value.isNotEmpty) {
        _listClients = value,
        _selected = List.generate(_listClients.length, (index) => false),
      } else {
        _listClients = [],
        _selected = [],
      }
    });

    await AppPsyDatabase.instance.readAllTypeActe().then((value) => {
      if (value.isNotEmpty) {
        _listTypeActes = value,
        _dropdownSelectionnerTypeActe = _listTypeActes[0].nom,
        _afficherPrixDansController(),
      } else {
        _listTypeActes = [],
        _dropdownSelectionnerTypeActe = "",
      }
    });

    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();

    _getListClients();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? const Center(child: CircularProgressIndicator()) : Stepper(
      type: StepperType.horizontal,
      currentStep: _indexStepper,
      onStepCancel: () {
        if (_indexStepper > 0) {
          setState(() => _indexStepper--);
        }
      },
      onStepContinue: () {
        if (_indexStepper <= 3 && _indexStepper >= 0) {
          setState(() => _indexStepper++);
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
              child: const Text('RETOUR', style: TextStyle(color: Colors.white70),),
            ),
          ],
        );
      },
      steps: [
        Step(title: const Text("Client(s)"), isActive: _indexStepper >= 0, content: buildClient()),
        Step(title: const Text("Séance(s)"), isActive: _indexStepper >= 1, content: buildSeance()),
        Step(title: const Text("Facture"), isActive: _indexStepper >= 2, content: buildFacture())
      ],
    );
  }

  Widget buildClient() {
    return ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 0, top: 20, right: 0,),
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

        if(_listClients.isEmpty)
          const Text("🤔​ Aucun clients ", style: TextStyle(fontSize: 18,),)
        else
          SizedBox(
              height: 150,
              child: Card(
                  borderOnForeground: true,
                  child: ListView(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      addAutomaticKeepAlives: false,
                      children: [
                        for(var i = 0; i < _listClients.length; i++)
                          ListTile(
                            title: Text("${_listClients[i].prenom} ${_listClients[i].nom} / ${_listClients[i].adresse}"),
                            leading: const Icon(Icons.account_circle_sharp),
                            selected: _selected[i],
                            onTap: () => setState(() => {
                              if (!_clientSelectionner.contains(_listClients[i])) {
                              _clientSelectionner.add(_listClients[i]),
                              _selected[i] = true,
                              } else {
                              _clientSelectionner.remove(_listClients[i]),
                              _selected[i] = false,
                              }
                            })
                          ),
                      ],
                  ),
              ),
          ),

          const Divider(height: 30,),

          for(Client client in _clientSelectionner)
            Text(" - ${client.nom} ${client.prenom} / ${client.adresse}"),

          const SizedBox(
            height: 20,
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

            Row(
              children: [
                Expanded(
                  flex: 3,
                  child:
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,),
                      child:
                      DropdownButtonFormField(
                        isExpanded: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Type de séance',
                            icon: Icon(Icons.assignment_outlined)
                        ),
                        value: _dropdownSelectionnerTypeActe,
                        items: _listTypeActes.map((typeActe) =>
                            DropdownMenuItem(
                              value: typeActe.nom,
                              child:  Text(
                                //overflow: TextOverflow.,
                                  typeActe.nom.toString()
                              ),
                            )
                        ).toList(),
                        onChanged: (String? _value) {
                          setState(() {
                            _dropdownSelectionnerTypeActe = _value!;
                            _afficherPrixDansController();
                          });
                        },
                      ),
                    ),
                ),


                Expanded(
                  flex: 2,
                  child:
                  Padding(padding: const EdgeInsets.only( left: 8, bottom: 10),
                    child:
                    TextFormField(
                      controller: _controllerChampDate,
                      keyboardType: TextInputType.datetime,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());

                        _selectDate();
                      },
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Date d'emission",
                          icon: Icon(Icons.date_range_outlined)
                      ),
                    ),
                  ),
                ),
                ],
              ),


            Row(children: [
              Expanded(
                child:
                Padding(padding: const EdgeInsets.only( bottom: 10),
                  child: TextFormField(
                    controller: _controllerChampPrix,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Prix',
                        icon: Icon(Icons.euro_outlined)
                    ),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entrer un prix';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              SizedBox(
                  width: 100,
                  child: Padding(padding: const EdgeInsets.only( left: 10, bottom: 10),
                    child: TextFormField(
                      controller: _controllerChampNombreUH,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                          icon: Icon(Icons.timelapse_outlined)
                      ),
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


              SizedBox(
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10,),
                  child:
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Unité de temps',
                    ),
                    value: _dropdownSelectionnerUnite,
                    items: ["Heure", "Minute"].map((value) =>
                        DropdownMenuItem(
                          value: value,
                          child:  Text(value),
                        )
                    ).toList(),
                    onChanged: (String? _value) {
                      setState(() {
                        _dropdownSelectionnerUnite = _value!;
                      });
                    },
                  ),
                ),
              ),
            ],),

            ElevatedButton.icon(
                onPressed: () {
                  setState(() => _ajouterSeance());
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
                        child:
                          ListTile(
                            title: Text("${seance.nom} (${seance.date.day}/${seance.date.month}/${seance.date.year}) - ${seance.nombreUniteTemps} ${seance.uniteTemps}"),
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
    return
      SingleChildScrollView(
        child:
            Form(
              key: _formKeyFacture,
                child: Column(
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child:
                            Padding(padding: const EdgeInsets.only( bottom: 10),
                              child: TextFormField(
                                controller: _controllerNumeroFacture,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Numero de facture',
                                    icon: Icon(Icons.numbers_outlined)
                                ),
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

                        Expanded(
                            child:
                              CheckboxListTile(
                                title: const Text("Sauvegarder"),
                                value: SpUtil.getBool(AppPsyUtils.CACHE_SAUVEGARDER_NUMERO_FACTURE) ?? false,
                                onChanged: (bool? value) {
                                  setState(() => SpUtil.putBool(AppPsyUtils.CACHE_SAUVEGARDER_NUMERO_FACTURE, value!));
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                        ),
                      ],
                    ),

                    const Divider(),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child:
                              TextFormField(
                                enabled: _aUneDateLimite,
                                controller: _controllerChampDateLimitePayement,
                                keyboardType: TextInputType.datetime,
                                onTap: () {
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  _selectDateLimitePayement();
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: "Date limite de payement",
                                    icon: Icon(Icons.date_range_outlined)
                                ),
                              ),
                          ),
                        ),

                        Switch(
                            value: _aUneDateLimite,
                            onChanged: (bool value) {
                              setState(() => _aUneDateLimite = !_aUneDateLimite);
                            }),
                      ],
                    ),

                    const Divider(),

                    
                  ]),
        ),
      );
  }
}
