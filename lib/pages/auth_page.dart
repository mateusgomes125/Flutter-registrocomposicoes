import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_auth_email_ii/widget/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:registrocomposicoes/pages/signup_page.dart';

import 'login_page.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();

}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
 
  @override
  Widget build(BuildContext context) => isLogin 
      ? LoginPage(onClickedSignUp: toggle) 
      : SignUpPage(onClickedSignIn: toggle);
void toggle() => setState(() => isLogin = !isLogin);
     
}
