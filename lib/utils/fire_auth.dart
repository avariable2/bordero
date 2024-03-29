import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FireAuth {

  static const String erreurType1 = "erreurType1";
  static const String erreurType2 = "erreurType2";

  final FirebaseAuth _firebaseAuth;

  Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  FireAuth(this._firebaseAuth);

  Future<User?> inscriptionUtilisantEmailMotDePasse({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    User? user;
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = _firebaseAuth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Mot de passe trop faible, veuillez ajouter des caractères.")),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email déjà utilisé.")),
        );
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur s'est produite.")),
      );
    }
    return user;
  }

  Future<User?> connexionUtilisantEmailMotDePasse({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    User? user;

    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cet email n'est pas reconnu.")),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mauvais mot de passe.")),
        );
      }
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur s'est produite.")),
      );
    }

    return user;
  }

  Future reinitialiserMotDePasse(
      {required BuildContext context, required String email}) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Un email de réinitialisation a été envoyé. Vérifiez vos spams.")),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Désolé, une erreur est survenue.")),
      );
    } catch (exception, stackTrace) {
      await Sentry.captureException(exception, stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Une erreur s'est produite.")),
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future supprimerCompte({required String password}) async {
    try {
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        AuthCredential credentials = EmailAuthProvider.credential(
            email: user.email!, password: password);
        var result = await user.reauthenticateWithCredential(credentials);
        result.user?.delete();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "wrong-password") {
        return erreurType1;
      }
    } catch (exception, stackTrace) {
      return false;
    }
    return false;
  }
}
