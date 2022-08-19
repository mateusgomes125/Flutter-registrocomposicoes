import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:registrocomposicoes/Models/Composicao.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';

class Edit extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String nomeArq;
  final String datahora;
  final String CID;
  //final String nomeUser;

  final DocumentSnapshot updateDados;

  const Edit(this.titulo, this.descricao, this.nomeArq, this.datahora, this.CID,
      this.updateDados);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _nomeArq = TextEditingController();
  final TextEditingController _datahora = TextEditingController();
  final TextEditingController _CID = TextEditingController();
  //final TextEditingController _nomeUser = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _titulo.text = widget.titulo;
    _descricao.text = widget.descricao;
    _nomeArq.text = widget.nomeArq;
    _datahora.text = widget.datahora;
    _CID.text = widget.CID;
    // _nomeUser.text = widget.nomeUser;

    return Scaffold(
      appBar: AppBar(
        title: Text("Editar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
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

            SizedBox(height: 4),

            TextFormField(
              controller: _nomeArq,
              decoration: InputDecoration(labelText: 'Nome do arquivo'),
              readOnly: true,
              //enabled: false,
            ),

            SizedBox(height: 4),

            TextFormField(
              controller: _datahora,
              decoration: InputDecoration(labelText: 'Data do registro'),
              readOnly: true,
              enabled: false,
            ),

            SizedBox(height: 4),

            TextFormField(
              controller: _CID,
              decoration: InputDecoration(labelText: 'CID'),
              readOnly: true,
              //enabled: false,
            ),

            // SizedBox(height: 4),

            // TextFormField(
            //   controller: _nomeUser,
            //   decoration: InputDecoration(labelText: 'Nome do compositor'),
            //  readOnly: true,
            //  //enabled: false,
            // ),
            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                _abrirArquivo(context);
              },
              child: const Text('Abrir arquivo'),
            ),

            SizedBox(height: 25),
          
          ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 65),
                  ),
                  onPressed: () {
                    if(formKey.currentState!.validate()){
                      _alterar(context);
                    }
                  },
                  icon: Icon(Icons.save_sharp),
                  label: Text('Salvar')),
          ]
          ),
        ),
      ),     
      

      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       if(formKey.currentState!.validate()){
      //           _alterar(context);
      //       }
      //     },
      //     //backgroundColor: Color(0xFF2E7D32),
      //     child: const Icon(Icons.save)),

    );
  }

  void _abrirArquivo(BuildContext context) async {
    String path = "https://" +
        widget.CID +
        ".ipfs.nftstorage.link/ipfs/" +
        widget.CID +
        "/" +
        widget.nomeArq;

    final Uri _url = Uri.parse(path);
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void _alterar(BuildContext context) {
    final userDao = Provider.of<UserDao>(context, listen: false);

    final composicao = new Composicao("", _titulo.text, _descricao.text,
        widget.datahora, "", userDao.userId(), "");

    widget.updateDados.reference
        .update({
          'titulo': _titulo.text,
          'descricao': _descricao.text,
        })
        .then((value) =>
            debugPrint("Sua composição foi atualizada no banco de dados"))
        .catchError(
            (error) => debugPrint("Ocorreu um erro gravar dados: $error"));

    Navigator.pop(context, composicao);

    const SnackBar snackBar =
        SnackBar(content: Text("A composição foi alterada com sucesso! "));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
