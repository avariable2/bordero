import 'package:bordero/utils/fire_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MotDePasseOublier extends StatefulWidget {
  const MotDePasseOublier({Key? key}) : super(key: key);

  @override
  State<MotDePasseOublier> createState() => _MotDePasseOublierState();
}

class _MotDePasseOublierState extends State<MotDePasseOublier> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reinitialiser votre mot de passe"),
      ),
      body: SingleChildScrollView(
          child: Form(
        key: _formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Recevoir un email pour réinitialiser votre mot de passe.",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Saisir le champ',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email *',
                ),
                controller: _emailController,
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
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    child: const Text('Réinitialiser mot de passe'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _reinitialiserMotDePasse();
                      }
                    })),
          ],
        ),
      )),
    );
  }

  _reinitialiserMotDePasse() async {
    await context.read<FireAuth>().reinitialiserMotDePasse(context: context, email: _emailController.text.trim());
  }

}
