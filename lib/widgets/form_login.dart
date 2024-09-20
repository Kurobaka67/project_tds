import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/main_page.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({super.key});

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin> {
  SharedPreferences? prefs;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool isLoggedIn = false;
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
    prefs = await SharedPreferences.getInstance();
    final String userId = prefs?.getString('username') ?? '';
    final String useremail = prefs?.getString('useremail') ?? '';
    if (userId != '' && useremail != '') {
      setState(() {
        isLoggedIn = true;
        name = userId;
        email = useremail;
      });
      return;
    }
  }

  Future<void> loginUser() async {
    print('login');
    prefs = await SharedPreferences.getInstance();
    prefs?.setString('username', nameController.text);
    prefs?.setString('useremail', emailController.text);
    setState(() {
      name = nameController.text;
      email = emailController.text;
      isLoggedIn = true;
    });
    nameController.clear();
    emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final _formkey = GlobalKey<FormState>();

    return Form(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUnfocus,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          child: TextFormField(
            keyboardType: TextInputType.name,
            autofillHints: const <String>[AutofillHints.name],
            controller: nameController,
            validator:
                MinLengthValidator(1, errorText: 'Veuillez entrer un nom').call,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.colorScheme.scrim.withOpacity(0.5),
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary)
              ),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              hintText: 'Nom complet',
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              errorText: '',
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(16),
              ),
              errorStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofillHints: const <String>[AutofillHints.email],
              controller: emailController,
              validator: MultiValidator([
                RequiredValidator(errorText: 'Entrer un adresse email'),
                EmailValidator(
                    errorText: 'Adresse email non valide'),
              ]).call,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.scrim.withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: 'Email',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.mail,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  errorText: '',
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  errorStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
            onPressed: () {
              if (_formkey.currentState!.validate()) {
                loginUser();
                _navigateToNextScreen(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.secondary,
              fixedSize: const Size(200, 60),
            ),
            child: Text(
              'Connexion',
              style: TextStyle(
                color: theme.colorScheme.onSecondary,
                fontSize: 25,
              ),
            )
        )
      ]),
    );
  }

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}
