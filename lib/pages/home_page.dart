import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registrocomposicoes/pages/edit_page.dart';
import 'package:registrocomposicoes/pages/form_page.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';
import 'package:registrocomposicoes/pages/user_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  Stream<QuerySnapshot> _getList(String uid) {
    return FirebaseFirestore.instance
        .collection('composicoes')
        .where("userId", isEqualTo: uid)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Composições'),
        actions: <Widget>[

          IconButton(
              icon: Icon(Icons.person),
              color: Colors.white,
              onPressed: () //=> FirebaseAuth.instance.signOut(),
              {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserPage()),
                );
              }
            ),
            IconButton(
              icon: Icon(Icons.logout_sharp),
              color: Colors.white,
              onPressed: () => FirebaseAuth.instance.signOut(),
            ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: _getList(user.uid.toString()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.data!.docs.isEmpty) {
                  print(user.uid.toString());
                  return Center(
                    child: Text('Não há composições'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot doc = snapshot.data!.docs[index];

                    final infoTitulo = doc['titulo'];
                    final infoDecricao = doc['descricao'];
                    final infoArq = doc['nomeArq'].toString();
                    final infoData = doc['dataHora'].toString();
                    final infoCID = doc['cid'].toString();
                    final updateDados = doc;

                    return ListTile(
                      title: Text(
                        doc['titulo'],
                        style: TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(
                        doc['dataHora'].toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                      onTap: () {
                        final Future future =
                            Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Edit(
                              infoTitulo,
                              infoDecricao,
                              infoArq,
                              infoData,
                              infoCID,
                              updateDados,
                            );
                          },
                        ));
                      },
                    );
                  },
                );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FormPage()),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.post_add_sharp)),
    );
  }
}
