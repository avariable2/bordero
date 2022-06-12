import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: MonAccueil(),
      )
    );
  }
}
class MonAccueil extends StatefulWidget {
  const MonAccueil({Key? key}) : super(key: key);

  @override
  State<MonAccueil> createState() => _MonAccueilState();
}

class _MonAccueilState extends State<MonAccueil> {
  final List<String> list = ['Séance de couple', 'Séance individuelle', 'Protocole 1', 'Protocole 2'];
  String selectedValue = '';

  @override
  Widget build(BuildContext context) {
    selectedValue = list[0];
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        top: 70,
        right: 20,
      ),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Mon espace de gestion",
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),


        const SizedBox(
          height: 25,
        ),


        const Text(
          "Clients",
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

        Row(
          children: const [
            Expanded(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom patient',
                ),
              ),
            ),
          ],
        ),


        const SizedBox(
          height: 15,
        ),


        SizedBox(
          height: 250,
          child: Card(
            borderOnForeground: true,
            child: ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              addAutomaticKeepAlives: false,
              children: [
                for (int count in List.generate(20, (index) => index + 1))
                  ListTile(
                    title: Text('Thomas Simon $count'),
                    leading: const Icon(Icons.account_circle_sharp),
                    onTap: () {},
                  ),
              ],
            ),
          ),
        ),


        ElevatedButton(
          onPressed: () {},
          child: const Text("Ajouter"),
        ),


        const SizedBox(
          height: 25,
        ),


        const Text(
          "Type d'actes",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),

        /*Row(
          children: [
            DropdownButtonFormField(
              value: selectedValue,
              items: list.map((typeActe) {
                return DropdownMenuItem(
                  value: typeActe,
                  child: Text(typeActe),
                );
              }).toList(),
              onChanged: (String? val) {
                setState(() {
                  if(val != null) {
                    selectedValue = val;
                  }
                });
              },
            ),


            const SizedBox(
              width: 25,
            ),


            ElevatedButton.icon(
                onPressed: null,
                label: const Text("Ajouter"),
                icon: const Icon(Icons.add),
            ),


            const SizedBox(
              width: 25,
            ),


            ElevatedButton.icon(
              onPressed: null,
              label: const Text("Modifier"),
              icon: const Icon(Icons.app_registration_outlined),
            ),
          ],
        ),*/


      ],
    );
    }
}
