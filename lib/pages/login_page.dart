import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registrocomposicoes/pages/home_page.dart';
import 'about_page.dart';
import 'package:registrocomposicoes/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';
import 'package:provider/provider.dart';

//import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginPage({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool _valida = false;
  bool _obscurePass = true;
  bool _click = true;
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
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center, 
        children: [
        SizedBox(height: 60),
        FlutterLogo(size: 120),
        SizedBox(height: 20),
        Text(
          'Olá, \n Bem-vindo(a) ao Login!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 32),
        ),
        SizedBox(height: 40),
        TextFormField(
          controller: email,
          cursorColor: Colors.black,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: 'Email'),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (email) => email != null && !EmailValidator.validate(email) 
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
          validator: (password) =>
              password != null && password.length < 6 
                  ? 'Mínimo de 6 caracteres!'
                  : null,
        ),
        SizedBox(height: 20),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.lock_open, size: 32),
          label: Text(
            'Log In',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            // setState(() {
            //   email.text.isEmpty ? _valida = true : _valida = false;
            //   password.text.isEmpty ? _valida = true : _valida = false;
            // });
            if (formKey.currentState!.validate()) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );

              userDao.LogIn(context, email.text, password.text);

              navigatorKey.currentState!.popUntil((route) => route.isFirst);
            }
          },
        ),
        SizedBox(height: 24),
        RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.grey[700], fontSize: 20),
                text: 'Não possui uma conta?',
                children: [
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                text: ' Cadastre-se!',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ])),
        SizedBox(height: 48),
        RichText(
            text: TextSpan(
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const About()),
              );
            },
          text: ' Sobre',
          style: TextStyle(
            decoration: TextDecoration.underline,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ))
      ]),
      ),
    );
  }
/*
  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;

      if (isLogin) {
        titulo = 'Bem-vindo';
        actionButton = 'Login';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 100),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-mail',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Informe o email corretamente";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  child: TextFormField(
                      controller: senha,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Informe sua senha";
                        } else if (value.length < 6) {
                          return "A senha deve conter no mínimo 6 caracteres";
                        }
                        return null;
                      }),
                ),
                Padding(
                  padding: EdgeInsets.all(24),
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (isLogin) {
                          setState(() => loading = true);

                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => HomePage(),
                            ),
                          );
                        }
                      } else {
                        setState(() => loading = true);

                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => HomePage(),
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: (loading)
                          ? [
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                        color: Colors.white)),
                              )
                            ]
                          : [
                              Icon(Icons.check),
                              Padding(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  actionButton,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(toggleButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }*/

  Future signIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      final SnackBar snackBar = SnackBar(
          content: Text("Conta não cadastrada, crie uma conta!"),
          backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
