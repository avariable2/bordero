import 'package:app_psy/utils/animation_delais.dart';
import 'package:flutter/material.dart';

class PageConnexion extends StatelessWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const FormConnexion();
  }
}

class FormConnexion extends StatefulWidget {
  const FormConnexion({Key? key}) : super(key: key);

  @override
  State<FormConnexion> createState() => _FormConnexionState();
}

class _FormConnexionState extends State<FormConnexion> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bordero")),
      body: buildPageConnexion(),
    );
  }

  Widget buildPageConnexion() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            AnimationDelais(
              delay: 1200,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Page de connexion',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                  )),
            ),
            AnimationDelais(
              delay: 2200,
              child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Connexion',
                    style: TextStyle(fontSize: 20),
                  )),
            ),
            AnimationDelais(
              delay: 3200,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
              ),
            ),
            AnimationDelais(
              delay: 4200,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),
            ),
            AnimationDelais(
              delay: 5200,
              child: TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Mot de passe oublié',
                ),
              ),
            ),
            AnimationDelais(
              delay: 6200,
              child: Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Se connecter'),
                    onPressed: () {
                      print(nameController.text);
                      print(passwordController.text);
                    },
                  )),
            ),
            AnimationDelais(
              delay: 7200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Vous ne possèder pas de compte ?'),
                  TextButton(
                    child: const Text(
                      'S\'inscrire',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      //signup screen
                    },
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
