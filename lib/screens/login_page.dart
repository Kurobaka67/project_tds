import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/widgets.dart';

import 'package:project_transdata/my_globals.dart' as globals;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();


  Future<void> initializeSharedPreferences() async {
    await prefs?.setString('page', 'all_requests');
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
      return Stack(children: [
      const BackgroundImage(),
      Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(parent: NeverScrollableScrollPhysics()),
              child: SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 100,
                    width: 250,
                    child:
                        Image.asset('assets/images/logoTDS.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'Bienvenue !',
                    style: TextStyle(
                        color: theme.colorScheme.onPrimaryFixed,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  const Center(
                      child: FormLogin()
                  )
                ],
              )),
            ),
          ))
    ]);
  }
  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Details'),
          content: Column(
            children: [
              Text('URL : ${globals.url}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class User extends ValueNotifier<String> {
  User() : super('');
}
