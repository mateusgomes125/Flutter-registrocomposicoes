import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDao extends ChangeNotifier {
  
  final auth = FirebaseAuth.instance;
  late User usuario;
  late String errorMessage;



// TODO: Add helper methods - Métodos de ajuda
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String userId() {
    return auth.currentUser!.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }
  
  _getUser() {
    usuario = auth.currentUser!;
    notifyListeners();
  }


Future LogIn(context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.trim(), 
          password: password.trim()
        );

      _getUser();
      notifyListeners();

    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        //throw AuthException('Senha incorreta. Tente novamente');
        errorMessage = 'Senha incorreta. Tente novamente';
      } else if (e.code == 'user-not-found') {
        //throw AuthException('Email não encontrado. Cadastre-se');
        errorMessage = 'Email não encontrado. Digite novamente ou cadastre-se';
      }

      final SnackBar snackBar = SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }


  Future signUp(context, String email, String password, String nome, String rg, String dataNascimento, String telefone) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.trim(), 
          password: password.trim()
          );
      userData(nome, rg, dataNascimento, telefone);
    } on FirebaseAuthException catch (e) {
      print(e);

      final SnackBar snackBar = SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> userData(String nome, String cpf, String dataNascimento, String telefone) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    users.add({
      'dataNascimento': dataNascimento,
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
      'uid': uid
    });
  }
}
