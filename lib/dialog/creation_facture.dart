import 'package:app_psy/model/type_acte.dart';
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
  DateTime _date = DateTime(2020, 11, 17);
  final _formKey = GlobalKey<FormState>();
  late List<Client> _listClients;
  late List<TypeActe> _listTypeActes;
  List<Client> _clientSelectionner = [];
  late List<bool> _selected;
  int _indexStepper = 0;
  bool _isLoading = false;
  late String _dropdownSelectionnerTypeActe;
  String _dropdownSelectionnerUnite = "Heure";
  bool _veuxChangerPrix = false;


  final controllerChampNom = TextEditingController();
  final controllerChampPrenom = TextEditingController();
  final controllerChampAdresse = TextEditingController();
  final controllerChampCodePostal = TextEditingController();
  final controllerChampVille = TextEditingController();
  final controllerChampNumero = TextEditingController();
  final controllerChampEmail = TextEditingController();

  final _controllerChampDate = TextEditingController();
  final _controllerChampPrix = TextEditingController();

  /// POUR CREER LE PDF
  /// https://www.google.com/search?q=create+facture+flutter&rlz=1C1CHZN_frFR980FR980&oq=create+facture+flutter&aqs=chrome..69i57j0i22i30.8424j0j7&sourceid=chrome&ie=UTF-8#kpvalbx=_ITnMYuiTI4f_lwSe-o-YAw18

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
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: 'Selectionner une date',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
        _controllerChampDate.text = "${_date.day}/${_date.month}/${_date.year}";
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
        if (_indexStepper < 4 && _indexStepper >= 0) {
          setState(() => _indexStepper++);
        }
      },
      onStepTapped: (int index) {
        setState(() => _indexStepper = index);
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
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                Padding(padding: const EdgeInsets.only( top:10, left: 8, bottom: 10),
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
                        icon: Icon(Icons.date_range)
                    ),
                  ),
                ),
              ),
              ],
            ),


            Row(children: [
              Expanded(child:
                Padding(padding: const EdgeInsets.only( top:10, bottom: 10),
                  child: TextFormField(
                    enabled: _veuxChangerPrix,
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
                        return 'Entrer un nom';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              
              Switch(
                  value: !_veuxChangerPrix,
                  onChanged: (bool b) {
                    setState(() => _veuxChangerPrix = !_veuxChangerPrix);
                  }),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10, top: 10),
                  child:
                  DropdownButtonFormField(
                    isExpanded: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Type de séance',
                        icon: Icon(Icons.timelapse_outlined)
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
            ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFacture() {
    return Container();
  }
}
