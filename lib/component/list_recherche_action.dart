import 'package:flutter/material.dart';

import '../model/client.dart';

class ListRechercheEtAction extends StatefulWidget {
  final String titre;
  final IconData icon;
  final String labelListVide;
  final String labelTitrerecherche;
  final String labelHintRecherche;
  final List<dynamic> list;
  final VoidCallback callback;
  final Function(dynamic) onSelectedItem;

  const ListRechercheEtAction(
      {Key? key,
      required this.titre,
      required this.icon,
      required this.labelListVide,
      required this.labelTitrerecherche,
      required this.labelHintRecherche,
      required this.list,
      required this.callback,
      required this.onSelectedItem})
      : super(key: key);

  static ListRechercheEtActionState? of(BuildContext context) =>
      context.findAncestorStateOfType<ListRechercheEtActionState>();

  @override
  State<ListRechercheEtAction> createState() => ListRechercheEtActionState();
}

class ListRechercheEtActionState extends State<ListRechercheEtAction> {
  final _controllerChampRecherche = TextEditingController();
  List<dynamic> _listTrier = [];
  late List<dynamic> _listItemsSelectionners;

  @override
  void initState() {
    _listItemsSelectionners =
        List.generate(widget.list.length, (index) => false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 0,
          top: 20,
          right: 0,
        ),
        children: [
          Text(
            widget.titre,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              inherit: true,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controllerChampRecherche,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    labelText: widget.labelTitrerecherche,
                    helperText: widget.labelHintRecherche,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _controllerChampRecherche.clear();
                          _listTrier = [];
                        });
                      },
                      color: _controllerChampRecherche.text.isNotEmpty
                          ? Colors.grey
                          : Colors.transparent,
                      icon: const Icon(Icons.clear),
                    ),
                  ),
                  onChanged: (String? entree) => setState(() {
                    if (entree != null && entree.length > 1) {
                      _listTrier = _sortParRecherche(entree) ?? [];
                    }
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          if (widget.list.isEmpty)
            Text(
              widget.labelListVide,
              style: const TextStyle(
                fontSize: 18,
              ),
            )
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
                    for (var i = 0; i < widget.list.length; i++)
                      ListTile(
                          title: Text(
                              "${widget.list[i].nom} ${widget.list[i].prenom} / ${widget.list[i].email}"),
                          leading: Icon(widget.icon),
                          selected: _listItemsSelectionners[i],
                          onTap: () => {
                                widget.onSelectedItem(widget.list[i]),
                            // TODO: essayer de faire le traitement suivant que sur factures et devis
                                _listItemsSelectionners[i] =
                                    !_listItemsSelectionners[i]
                              }),
                  ],
                ),
              ),
            )
        ]);
  }

  List<dynamic>? _sortParRecherche(String? entree) {
    if (entree == null) {
      return null;
    }
    _listTrier.clear();
    List<dynamic> listFinal = [];
    RegExp regex = RegExp(entree.toLowerCase());

    for (dynamic item in widget.list) {
      if (regex.firstMatch(item.nom.toLowerCase()) != null ||
          regex.firstMatch(item.email.toLowerCase()) != null) {
        listFinal.add(item);
      }
      if (item is Client &&
          regex.firstMatch(item.prenom.toLowerCase()) != null) {
        listFinal.add(item);
      }
    }

    return listFinal;
  }
}
