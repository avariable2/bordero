import 'package:flutter/material.dart';

import '../model/client.dart';
import '../model/document.dart';
import '../model/type_acte.dart';
import '../utils/app_psy_utils.dart';
import '../model/filter_chips_callback.dart';

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
  final bool needTousEcran;
  final bool needChips;
  final List<FilterChipCallback> filterChipsNames;

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
      this.labelHintRecherche = "",
      this.needTousEcran = false,
      this.needChips = false,
      required this.filterChipsNames})
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
  FilterChipCallback? chipsActive;
  double paddingBasRechercheAvecChips = 10;
  double paddingBasRechercheSansChips = 15;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (widget.titre.isNotEmpty) ...[
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
      ],
      if (widget.needRecherche) ...[
        Row(
          children: [
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(
                  bottom: widget.needChips
                      ? paddingBasRechercheAvecChips
                      : paddingBasRechercheSansChips),
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
      ],
      if (widget.needChips) buildChipsRechercheAvancer(),
      buildListTraitement(_controllerChampRecherche.text.isNotEmpty
          ? _listTrier
          : chipsActive != null
              ? _listTrier
              : widget.list)
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
      return buildListView(list);
    }
  }

  Widget buildListView(List<dynamic> list) {
    var listview = ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: buildListTile(list, index),
          );
        });
    return SizedBox(
      height:
          widget.needTousEcran ? MediaQuery.of(context).size.height / 2 : 150,
      child: listview,
    );
  }

  Widget buildListTile(List<dynamic> list, int index) {
    _listItemsSelectionners =
        List.generate(widget.list.length, (index) => false);
    return ListTile(
        title: Text(
          buildText(list[index]),
        ),
        leading: Icon(widget.icon),
        selected: _listItemsSelectionners[index],
        onTap: () => {
              widget.onSelectedItem(widget.list[index]),
              if (widget.needSelectedItem)
                {
                  _listItemsSelectionners[index] =
                      !_listItemsSelectionners[index]
                }
            });
  }

  Widget buildChipsRechercheAvancer() {
    return Row(
      children: [
        for (FilterChipCallback obj in widget.filterChipsNames) ...[
          FilterChip(
            label: Text(obj.name),
            selected: chipsActive == obj,
            onSelected: (bool value) {
              if (chipsActive == obj) {
                chipsActive = null;
              } else {
                chipsActive = obj;
              }
              setState(() => _listTrier =
                  _sortParRecherche(_controllerChampRecherche.text) ?? []);
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ]
      ],
    );
  }

  String buildText(dynamic item) {
    String titre = "";
    if (item is TypeActe) {
      titre = item.nom;
    } else if (item is Client) {
      titre = "${item.nom} ${item.prenom} / ${item.email}";
    } else if (item is Document) {
      titre = AppPsyUtils.getName(item);
    } else {
      throw "Exception: (buildText)) type not supported in param";
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
      if (item is Document) {
        var nomFacture = AppPsyUtils.getName(item).toLowerCase();
        if (regex.firstMatch(nomFacture) != null) {
          listFinal.add(item);
          if (chipsActive != null &&
              chipsActive!.filter.firstMatch(nomFacture) == null) {
            listFinal.remove(item);
          }
        }
      } else if (item is Client &&
          regex.firstMatch(item.prenom.toLowerCase()) != null) {
        listFinal.add(item);
      } else if (regex.firstMatch(item.nom.toLowerCase()) != null) {
        listFinal.add(item);
      }
    }

    return listFinal;
  }
}
