import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';


class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser!;
  late final userData =
      FirebaseFirestore.instance.collection('users').doc(user.uid.toString());

  final formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  final TextEditingController _telefone = TextEditingController();
  final TextEditingController _cpf = TextEditingController();
  final TextEditingController _datanascimento = TextEditingController();

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
        _datanascimento.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userData.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        _nome.text = data['nome'];
        _telefone.text = data['telefone'];
        _cpf.text = data['cpf'];
        _datanascimento.text = data['dataNascimento'];
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Dados do usuário"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            SizedBox(height: 4),
            TextFormField(
              controller: _nome,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Nome'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_nome) =>
                  _nome == null ? 'Insira o nome do usuário!' : null,
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _telefone,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Telefone'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_telefone) =>
                  _telefone == null || _telefone.length < 10
                      ? 'Telefone vazio ou invalido'
                      : null,
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _cpf,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'CPF'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_cpf) => _cpf == null || _cpf.length != 11
                  ? 'CPF vazio ou invalido!'
                  : null,
            ),
            SizedBox(height: 4),
            TextFormField(
              controller: _datanascimento,
              cursorColor: Colors.black,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Data de Nascimento'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_datanascimento) => _datanascimento == null
                  ? 'Insira sua data de nascimento!'
                  : null,
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                _selectcDate(context);
              },
            ),
            SizedBox(height: 25),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300, 65),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _alterar(context);
                  }
                },
                icon: Icon(Icons.save_sharp),
                label: Text('Salvar')),
          ]),
        ),
      ),
    );
  }

  void _alterar(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(user.uid.toString())
        .update({
          'cpf': _cpf.text,
          'dataNascimento': _datanascimento.text,
          'nome': _nome.text,
          'telefone': _telefone.text,
        })
        .then((value) =>
            debugPrint("Os dados do usuário foram alterados com sucesso!"))
        .catchError(
            (error) => debugPrint("Ocorreu um erro gravar dados: $error"));

    Navigator.pop(context);

    const SnackBar snackBar = SnackBar(
        content: Text("Os dados do usuário foram alterados com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
