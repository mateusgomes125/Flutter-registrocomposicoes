import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Edit extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String nomeArq;

  final DocumentSnapshot updateDados;

  const Edit(this.titulo, this.descricao, this.nomeArq, this.updateDados);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _descricao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titulo.text = widget.titulo;
    _descricao.text = widget.descricao;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(height: 4),
          TextFormField(
            controller: _titulo,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Título'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (_titulo) => _titulo == null ? 'Insira o título!' : null,
          ),
          SizedBox(height: 4),
          TextFormField(
            controller: _descricao,
            maxLength: 140,
            maxLines: 5,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: 'Descrição'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (_descricao) =>
                _descricao == null ? 'Insira uma descrição!' : null,
          ),
          SizedBox(height: 40),
        ]),
      ),
    );
  }
}
