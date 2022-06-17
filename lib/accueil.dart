import 'package:app_psy/color_schemes.g.dart';
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

  @override
  Widget build(BuildContext context) {
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
          height: 200,
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


        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) => FullScreenDialog(),
                fullscreenDialog: true,
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Ajouter"),
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

        const SizedBox(
          height: 15,
        ),


        SizedBox(
          height: 200,
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
                    leading: const Icon(Icons.work_outline),
                    onTap: () {},
                  ),
              ],
            ),
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Ajouter"),
        ),

      ],
    );
    }
}

class FullScreenDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {},
            icon: const Icon(Icons.save_outlined),
          ),
        ],
        title: const Text('Création client'),
      ),
      body: Form(
        child:
        Wrap(alignment:WrapAlignment.spaceAround , children: const [
          Expanded(
            child: TextField(
              decoration: InputDecoration( hintText: "TextField 1"),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: TextField(
              decoration: InputDecoration(hintText: "TextField 2"),
            ),
          ),
        ]),
      ),
    );
  }
}