import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:registrocomposicoes/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';
import 'package:provider/provider.dart';
//import 'package:easy_mask/easy_mask.dart';

class SignUpPage extends StatefulWidget {
  final Function() onClickedSignIn;

  const SignUpPage({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  final nome = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final dataNascimento = TextEditingController();
  final cpf = TextEditingController();
  final telefone = TextEditingController();
  late final isValid;

  bool _obscurePass = true;

  DateTime _date = DateTime.now();

  Future<Null> _selectcDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("pt", "PT"),
      initialDate: _date,
      firstDate: DateTime(1990),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        dataNascimento.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 60),
          FlutterLogo(size: 120),
          SizedBox(height: 20),

          Text(
            'Olá, \n Bem-vindo(a) ao cadastro!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),

          SizedBox(height: 40),

          TextFormField(
            controller: nome,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Nome Completo'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (nome) =>
                nome!.length == 0 ? 'Insira seu nome completo!' : null,
          ),

          SizedBox(height: 4),

          TextFormField(
            controller: email,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Entre com um email valido!'
                    : null,
          ),

          SizedBox(height: 4),

          TextFormField(
            controller: password,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            obscureText: _obscurePass,
            decoration: InputDecoration(
                labelText: 'Senha',
                suffixIcon: IconButton(
                  icon: _obscurePass
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                  iconSize: 30,
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                )),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6
                ? 'Mínimo de 6 caracteres!'
                : null,
          ),

          SizedBox(height: 4),

          TextFormField(
            controller: dataNascimento,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Data de Nascimento'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (dataNascimento) => dataNascimento != null
                ? 'Insira sua data de nascimento!'
                : null,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
              _selectcDate(context);
            },
          ),

          SizedBox(height: 4),

          TextFormField(
            controller: cpf,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'CPF'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (cpf) => cpf == null || cpf.length != 11 ? 'CPF vazio ou invalido!' : null,
          ),

          SizedBox(height: 4),

          TextFormField(
            controller: telefone,
            cursorColor: Colors.black,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Telefone'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (telefone) =>
                telefone == null || telefone.length < 10 ? 'Telefone vazio ou invalido' : null,
          ),

          SizedBox(height: 20),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
            ),
            icon: Icon(Icons.arrow_forward, size: 32),
            label: Text(
              'Sign Up',
              style: TextStyle(fontSize: 24),
            ),
            onPressed: () {
              
              if (formKey.currentState!.validate()) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      Center(child: CircularProgressIndicator()),
                );

                userDao.signUp(context, email.text, password.text, nome.text,
                    cpf.text, dataNascimento.text, telefone.text);

                navigatorKey.currentState!.popUntil((route) => route.isFirst);
              }
            },
          ),

          SizedBox(height: 24),

          RichText(
              text: TextSpan(
                  style: TextStyle(color: Colors.grey[700], fontSize: 20),
                  text: 'Já possui uma conta?',
                  children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignIn,
                  text: ' Log In!',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                )
              ]))
        ]),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
      userData();
    } on FirebaseAuthException catch (e) {
      print(e);

      final SnackBar snackBar = SnackBar(
          content: Text("A conta já está sendo usada!"),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future<void> userData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    users.add({
      'dataNascimento': dataNascimento.text,
      'nome': nome.text,
      'cpf': cpf.text,
      'uid': uid
    });
  }
}
