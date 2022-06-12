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
  Map<int, bool> checkboxCheck = <int, bool>{};

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 20,
        top: 70,
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
          height: 25,
        ),


        Card(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            addAutomaticKeepAlives: false,
            children: [
              for (int count in List.generate(20, (index) => index + 1))
                ListTile(
                  title: Text('Client $count'),
                  leading: const Icon(Icons.account_circle_sharp),
                  selected: checkboxCheck[count]  ?? false,
                  trailing: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    value: checkboxCheck[count]  ?? false,
                    onChanged: (value) {
                      // update value
                      setState(() {
                        checkboxCheck[count] = value!;
                      });
                    },
                  )
                ),
            ],
          ),
        ),



        const SizedBox(
          height: 25,
        ),


        const Text(
          "Type d'actes",
          style: TextStyle(
            fontSize: 24,
            //fontWeight: FontWeight.bold,
            inherit: true,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
    }
}
