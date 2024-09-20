import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../model/request_model.dart';
import '../screens/page.dart';
import '../services/request_local_services.dart';
import '../widgets/request_card.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences? prefs;
  bool isLoggedIn = false;
  bool isLoading = false;
  String name = '';
  String email = '';
  late List<RequestModel>? requestsModel = [];
  List items = [];

  Future<void> initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    final String userId = prefs?.getString('username') ?? '';
    final String useremail = prefs?.getString('useremail') ?? '';
    if (userId != '' && useremail != '') {
      setState(() {
        name = userId;
        email = useremail;
        isLoggedIn = true;
      });
    }
  }

  Future<void> getRequest() async {
    setState(() {
      isLoading = true;
    });
    requestsModel = (await RequestLocalService().getRequests())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
      isLoading = false;
    }));
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
    getRequest();
  }

  Future<void> logout() async {
    print('logout');
    prefs = await SharedPreferences.getInstance();
    prefs?.setString('username', '');
    prefs?.setString('useremail', '');
    setState(() {
      name = '';
      email = '';
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.colorScheme.primary,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Text('Bonjour ', style: TextStyle(color: theme.colorScheme.onSecondary)),
          Text(prefs?.getString('username') ?? 'no name', style: TextStyle(color: theme.colorScheme.onSecondary),)
        ]),
        actions: [
          MenuAnchor(
            builder:
                (BuildContext context, MenuController controller, Widget? child) {
              return IconButton(
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                icon: const Icon(Icons.more_vert, color: Colors.white,),
                tooltip: 'Options',
              );
            },
            menuChildren: [
              MenuItemButton(
                onPressed: () {
                  logout();
                  _navigateToLoginScreen(context);
                },
                child: const Text('Déconnexion'),
              )
            ]
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: switch(isLoading) {
                false => ListView(
                  children: [
                    if(requestsModel != null && requestsModel!.isNotEmpty)
                      for(var request in requestsModel!)
                        RequestCard(request: request)
                    else
                      Padding(
                          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                          child: const Center(
                              child: Text('Aucune demande trouvé', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)
                          )
                      )
                  ],
                ),
                true => LoadingAnimationWidget.waveDots(
                  size: 200,
                  color: Colors.black45,
                ),
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(width: 2))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary)),
                  onPressed: () {
                    _navigateToMakeRequestScreen(context);
                  },
                  child: Text('Faire une demande', style: TextStyle(fontSize: 20, color: theme.colorScheme.onSecondary),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToMakeRequestScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MakeRequest()));
  }
}