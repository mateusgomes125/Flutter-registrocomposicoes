import 'package:flutter/material.dart';

class Utils {
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text), backgroundColor: Colors.red);

    //final SnackBar snackBar = SnackBar(content: Text("Aconta já está sendo usada!"));
    //ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Utils utils = Utils();
    utils.messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
