import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../model/request_model.dart';
import '../screens/page.dart';
import '../services/request_services.dart';
import '../widgets/request_card.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({super.key});

  @override
  State<AllRequests> createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isAdmin = false;
  String name = '';
  String email = '';
  late List<RequestModel>? requestsModel = [];
  List items = [];

  Future<void> initializeSharedPreferences() async {
    final String username = await prefs?.getString('username') ?? '';
    final String useremail = await prefs?.getString('useremail') ?? '';
    final bool userAdmin = await prefs?.getBool('admin') ?? false;
    if (username != '' && useremail != '') {
      setState(() {
        name = username;
        email = useremail;
        isAdmin = userAdmin;
        isLoggedIn = true;
      });
    }
    getRequest();
  }

  Future<void> getRequest() async {
    setState(() {
      isLoading = true;
    });
    if(!isAdmin){
      requestsModel = (await RequestService().getRequestsByName());
    }
    else{
      requestsModel = (await RequestService().getRequests());
    }
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
      isLoading = false;
    }));
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> logout() async {
    await prefs?.setString('username', '');
    await prefs?.setString('useremail', '');
    await prefs?.setBool('admin', false);
    await prefs?.setBool('verify', false);
    setState(() {
      name = '';
      email = '';
      isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: switch (isLoading) {
                  false => switch (requestsModel != null) {
                      true => ListView(
                          children: [
                            if (requestsModel!.isNotEmpty)
                              for (var request in requestsModel!)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: RequestCard(request: request),
                                )
                            else
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
                                  child: const Center(
                                      child: Text(
                                    'Aucune demande trouvé',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  )))
                          ],
                        ),
                      false => ListView(children: [
                          Padding(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.3),
                              child: Center(
                                  child: Column(
                                children: [
                                  const Text(
                                    'Problème de connexion !',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor: WidgetStatePropertyAll(theme.colorScheme.secondary),
                                    ),
                                    onPressed: () {
                                      getRequest();
                                    },
                                    child: Icon(Icons.sync, size: 40, color: theme.colorScheme.onSecondary),
                                  )
                                ],
                              )))
                        ]),
                    },
                  true => LoadingAnimationWidget.waveDots(
                      size: 150,
                      color: Colors.black45,
                    ),
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 2))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 60),
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(theme.colorScheme.primary)),
                  onPressed: () {
                    _navigateToMakeRequestScreen(context);
                  },
                  child: Text(
                    'Faire une demande',
                    style: TextStyle(
                        fontSize: 20, color: theme.colorScheme.onPrimary),
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToMakeRequestScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MakeRequest()));
  }
}
