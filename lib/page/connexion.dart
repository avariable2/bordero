import 'package:app_psy/utils/animation_delais.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formInscriptionKey = GlobalKey<FormState>();
  final TextEditingController _emailConnexionController =
      TextEditingController();
  final TextEditingController _emailInscrireController =
      TextEditingController();
  final TextEditingController _motDePasseConnexionController =
      TextEditingController();
  final TextEditingController _motDePasseInscrireController =
      TextEditingController();
  final TextEditingController _motDePasseVerifInscrireController =
      TextEditingController();

  bool veuxSeCo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bordero")),
      body: veuxSeCo ? buildPageConnexion() : buildPageInscription(),
    );
  }

  Widget buildPageConnexion() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Page de connexion',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                  )),
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Connexion',
                    style: TextStyle(fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  controller: _emailConnexionController,
                  validator: (value) {},
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  controller: _motDePasseConnexionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Mot de passe',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Mot de passe oublié',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Se connecter'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _connexion();
                      }
                    },
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Vous ne possèder pas de compte ?'),
                  TextButton(
                    child: const Text(
                      'S\'inscrire',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => setState(() => veuxSeCo = !veuxSeCo),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  Widget buildPageInscription() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formInscriptionKey,
          child: ListView(
            children: <Widget>[
              AnimationDelais(
                delay: 1000,
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Page de d\'inscription',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    )),
              ),
              AnimationDelais(
                delay: 2000,
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Inscription',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              AnimationDelais(
                delay: 3000,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    controller: _emailInscrireController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Entree un email";
                      }
                      if (!EmailValidator.validate(value)) {
                        return 'Entrer un email valide';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              AnimationDelais(
                delay: 4000,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _motDePasseInscrireController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mot de passe',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Entree un bon mot de passe";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              AnimationDelais(
                delay: 4000,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TextFormField(
                    obscureText: true,
                    controller: _motDePasseVerifInscrireController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirmer mot de passe',
                    ),
                    validator: (String? value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _motDePasseInscrireController.text) {
                        return "Entree le même mot de passe";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              AnimationDelais(
                delay: 5000,
                child: Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text("S'inscrire"),
                      onPressed: () => {
                        if (_formInscriptionKey.currentState!.validate())
                          {setState(() => _inscription())}
                      },
                    )),
              ),
              AnimationDelais(
                delay: 6000,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Vous possèder un compte ?'),
                    TextButton(
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () => setState(() => veuxSeCo = !veuxSeCo),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _inscription() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailInscrireController.text,
        password: _motDePasseInscrireController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {}
  }

  Future<void> _connexion() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailConnexionController.text,
          password: _motDePasseConnexionController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
      } else if (e.code == 'wrong-password') {}
    }
  }
}
