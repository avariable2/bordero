import 'package:bordero/page/page_mot_de_passe_oublier.dart';
import 'package:bordero/utils/animation_delais.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/fire_auth.dart';

class PageConnexion extends StatefulWidget {
  const PageConnexion({Key? key}) : super(key: key);

  @override
  State<PageConnexion> createState() => _PageConnexionState();
}

class _PageConnexionState extends State<PageConnexion> {
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Saisir un email";
                    }
                    if (!EmailValidator.validate(value)) {
                      return "Saisir un email valide";
                    }
                    return null;
                  },
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty && value.length < 6) {
                      return "Saisir un mot de passe de minimum 6 lettres";
                    }
                    return null;
                  },
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MotDePasseOublier() )),
                child: const Text(
                  'Mot de passe oublié',
                ),
              ),
              Container(
                  height: 50,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                    child: const Text('Se connecter'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<FireAuth>().connexionUtilisantEmailMotDePasse(
                                email: _emailConnexionController.text.trim(),
                                password:
                                    _motDePasseConnexionController.text.trim(),
                                context: context)
                            .then((User? user) {
                          if (user != null) {
                            Navigator.of(context).pop();
                          }
                        });
                      }
                    },
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20,),
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
                delay: 500,
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
                delay: 1000,
                child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Inscription',
                      style: TextStyle(fontSize: 20),
                    )),
              ),
              AnimationDelais(
                delay: 1500,
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
                delay: 2000,
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
                delay: 2500,
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
                delay: 3000,
                child: Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text("S'inscrire"),
                      onPressed: () async {
                        if (_formInscriptionKey.currentState!.validate())
                          {
                            await context.read<FireAuth>().inscriptionUtilisantEmailMotDePasse(
                                    context: context,
                                    email: _emailInscrireController.text.trim(),
                                    password: _motDePasseInscrireController.text
                                        .trim())
                                .then((User? user) {
                              if (user != null) {
                                Navigator.of(context).pop();
                              }
                            });
                          }
                      },
                    )),
              ),
              AnimationDelais(
                delay: 3500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 20,),
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

  @override
  void dispose() {
    _emailConnexionController.dispose();
    _emailInscrireController.dispose();
    _motDePasseConnexionController.dispose();
    _motDePasseInscrireController.dispose();
    _motDePasseVerifInscrireController.dispose();

    super.dispose();
  }
}
