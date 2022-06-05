import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registrocomposicoes/pages/auth_page.dart';
import 'package:registrocomposicoes/pages/home_page.dart';
import 'package:registrocomposicoes/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:registrocomposicoes/utils.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:registrocomposicoes/pages/data/User_dao.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserDao(),
      child: MyApp(),
    )
  ], child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();
//Utils utils = Utils();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
     builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        supportedLocales: [const Locale('en'), const Locale('pt')],
        //scaffoldMessengerKey: utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Registro de Composições',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: MainPage(),
      );
    },
  );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Ocorreu um erro!'));
            } else if (snapshot.hasData) {
              print("entrou!");
              return Consumer<UserDao>(builder: (context, userDao, child) {
                if (userDao.isLoggedIn()) {
                  return HomePage();
                } else {
                  return AuthPage();
                }
              });
            } else {
              return AuthPage();
            }
          },
        ),
      );
}
