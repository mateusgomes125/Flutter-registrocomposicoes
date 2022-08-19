import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _arquivo = TextEditingController();
  final dataRegistro = TextEditingController();
  String nomeArquivo = 'Selecionar arquivo';
  bool isAttached = false;

  DateTime _date = DateTime.now();

  Future<Null> _selectcDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale("pt", "PT"),
      initialDate: _date,
      firstDate: DateTime(1930),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _date) {
      setState(() {
        dataRegistro.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  CollectionReference composicoes =
      FirebaseFirestore.instance.collection('composicoes');

  late FilePickerResult result;
  bool _isLoading = false;

  _selecionaArquivo() async {
    result = (await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    )) as FilePickerResult;
    if (result != null) {
      PlatformFile file = result.files.first;
      print("name: " + file.name);
      setState(() {
        _arquivo.text = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Composição'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 4),

              TextFormField(
                controller: _titulo,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Título'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (_titulo) =>
                    _titulo == null ? 'Insira o título!' : null,
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

              OutlinedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  minimumSize: Size(200, 50),
                ),
                icon: Icon(Icons.attach_file_sharp),
                label: Text(
                  _arquivo.text.isEmpty ? 'Selecionar Arquivo' : _arquivo.text,
                ),
                onPressed: () {
                  _selecionaArquivo();
                },
              ),

              SizedBox(height: 50),

              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(300, 65),
                  ),
                  onPressed: () {
                    _submit(context);
                  },
                  icon: Icon(Icons.save_sharp),
                  label: Text('Salvar')),

              SizedBox(height: 15),

              _isLoading ? CircularProgressIndicator() : Container(),
            ],
          )),
    );
  }

  void _submit(BuildContext context) async {
    dataRegistro.text = DateFormat('dd/MM/yyyy').format(DateTime.now());

    final userDao = Provider.of<UserDao>(context, listen: false);

    if (result != null && !_titulo.text.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      PlatformFile file = result.files.first;
      var request = http.MultipartRequest(
          "POST", Uri.parse('https://api.nft.storage/upload'));
      request.headers['accept'] = 'application/json';
      request.headers['Content-Type'] = 'application/pdf';
      request.headers['Authorization'] =
          'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJkaWQ6ZXRocjoweEVGN0M2NEJDYjA2QkU0YTVlMjVlMWM3ODMxNzgwNzA1NEFCN2E2ZGEiLCJpc3MiOiJuZnQtc3RvcmFnZSIsImlhdCI6MTY1MzM3MTcyNDc4NCwibmFtZSI6InJlZ2lzdHJvX2NvbXBvc2ljb2VzIn0.6Y1JFjZ8ZMyz1wOMrvtuEiB8fkhaS3ZY-TsUXpWJhtY';
      request.fields["text_field"] = "composicao";

      var pic = http.MultipartFile.fromBytes('file', file.bytes!.toList(),
          filename: file.name, contentType: MediaType('*', '*'));

      request.files.add(pic);
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);

      print(responseString);
      var dados = jsonDecode(responseString);
      var valores = dados['value'];
      var cid = valores['cid'];

      composicoes.add({
        'titulo': _titulo.text,
        'descricao': _descricao.text,
        'dataHora': dataRegistro.text,
        'cid': cid,
        'userId': userDao.userId(),
        'nomeArq': file.name
      }).then((value) {
        // finaliza a barra
        Navigator.pop(context);
        const SnackBar snackBar = SnackBar(
            content: Text("Sua composição foi registrada com sucesso! "));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }).catchError((error) => debugPrint("Ocorreu um erro: $error"));
    } else {
      const SnackBar snackBar =
          SnackBar(content: Text("Problema ao registrar composição "));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      _isLoading = false;
    });

    _titulo.text = '';
    _descricao.text = '';
  }
}
