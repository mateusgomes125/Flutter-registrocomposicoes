import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class About extends StatefulWidget {
  const About({ Key? key }) : super(key: key);

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text("Sobre", textAlign: TextAlign.center,),
       centerTitle: true,
      ),
      body: Center(
        child: Container(    
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          width: 35.w,
          height: 80.0.h,
          child: 
            Text(
            "Esta aplicação utiliza a tecnologia blockchain para o registro de composições musicais.\n" + 
            "O documento da composição fica armazenado de forma descentralizada e imutável, servindo como um registro válido, que assegura o compositor.\n"+ 
            "O NFT.Storage faz o intermédio entre o arquivo da composição e o registro na blockchain, que contém sua chave(CID)." +
            "O CID é recuperado e armazenado no Firestore, juntamente com as informações da composição e do compositor.",
            style: TextStyle(
              color: Colors.black.withOpacity(0.3),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            softWrap: true,
            ),
        ),
      ),
    );
  }
}