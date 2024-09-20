import 'package:flutter/material.dart';
import '../widgets/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Stack(children: [
      const BackgroundImage(),
      Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SafeArea(
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
          )))
    ]);
  }
}

class User extends ValueNotifier<String> {
  User() : super('');
}
