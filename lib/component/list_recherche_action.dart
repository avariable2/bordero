import 'package:flutter/material.dart';

import '../model/client.dart';
import '../model/type_acte.dart';

class ListRechercheEtAction extends StatefulWidget {
  final String titre;
  final IconData icon;
  final String labelListVide;
  final String labelTitreRecherche;
  final String labelHintRecherche;
  final List<dynamic> list;
  final Function(dynamic) onSelectedItem;
  final bool needSelectedItem;
  final bool needRecherche;

  const ListRechercheEtAction(
      {Key? key,
      required this.titre,
      required this.icon,
      required this.labelListVide,
      required this.list,
      required this.onSelectedItem,
      required this.needRecherche,
      this.needSelectedItem = false,
      this.labelTitreRecherche = "",
      this.labelHintRecherche = ""})
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 0,
          top: 10,
          right: 0,
        ),
        child: Text(
          widget.titre,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      if (widget.needRecherche)
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: TextField(
                controller: _controllerChampRecherche,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(),
                  labelText: widget.labelTitreRecherche,
                  helperText: widget.labelHintRecherche,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _controllerChampRecherche.clear();
                      _listTrier = [];
                      setState(() {
                        FocusScope.of(context).requestFocus(FocusNode());
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
            )),
          ],
        ),
      buildListTraitement(
          _controllerChampRecherche.text.isNotEmpty ? _listTrier : widget.list)
    ]);
  }

  Widget buildListTraitement(List<dynamic> list) {
    if (widget.list.isEmpty) {
      return Text(
        widget.labelListVide,
        style: const TextStyle(
          fontSize: 18,
        ),
      );
    } else {
      return SizedBox(
        height: 150,
        child: Card(
          borderOnForeground: true,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            children: [
              for (var i = 0; i < list.length; i++)
                ListTile(
                    title: Text(
                      buildText(list[i]),
                    ),
                    leading: Icon(widget.icon),
                    selected: _listItemsSelectionners[i],
                    onTap: () => {
                          widget.onSelectedItem(widget.list[i]),
                          if (widget.needSelectedItem)
                            {
                              _listItemsSelectionners[i] =
                                  !_listItemsSelectionners[i]
                            }
                        }),
            ],
          ),
        ),
      );
    }
  }

  String buildText(dynamic item) {
    String titre = "";
    if (item is TypeActe) {
      titre = item.nom;
    } else if (item is Client) {
      titre = "${item.nom} ${item.prenom} / ${item.email}";
    }
    return titre;
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
      } else if (item is Client &&
          regex.firstMatch(item.prenom.toLowerCase()) != null) {
        listFinal.add(item);
      }
    }

    return listFinal;
  }
}
