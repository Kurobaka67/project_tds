import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_transdata/screens/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/request_model.dart';
import '../services/request_services.dart';
import '../services/users_services.dart';
import '../widgets/archived_request.dart';
import 'login_page.dart';

class ArchivedPage extends StatefulWidget {
  const ArchivedPage({super.key});

  @override
  State<ArchivedPage> createState() => _ArchivedPageState();
}

class _ArchivedPageState extends State<ArchivedPage> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isAdmin = false;
  String name = '';
  bool notificationActivated = false;
  late List<RequestModel>? archivedRequestsModel = [];

  Future<void> initializeSharedPreferences() async {
    final String username = await prefs?.getString('username') ?? '';
    final bool notif = await prefs?.getBool('notification') ?? false;
    final bool userAdmin = await prefs?.getBool('admin') ?? false;
    setState(() {
      name = username;
      isLoggedIn = true;
      isAdmin = userAdmin;
      notificationActivated = notif;
    });
    getRequest();
  }

  Future<void> activateNotification() async {
    var result = (await UsersService().changeNotification());
    setState(() {
      notificationActivated = result;
    });
  }

  Future<void> getRequest() async {
    setState(() {
      isLoading = true;
    });
    if (isAdmin) {
      archivedRequestsModel = (await RequestService().getArchiveRequest());
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
    var result = (await UsersService().logout());
    if(result){
      await prefs?.setString('username', '');
      await prefs?.setString('useremail', '');
      await prefs?.setBool('admin', false);
      await prefs?.setBool('verify', false);
      setState(() {
        name = '';
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          automaticallyImplyLeading: false,
          title: Text(
            name,
            style: TextStyle(color: theme.colorScheme.onPrimary),
          ),
          actions: [
            if (isAdmin)
              IconButton(
                  onPressed: () {
                    activateNotification();
                  },
                  icon: Icon(Icons.notifications,
                      color: notificationActivated
                          ? Colors.yellow
                          : theme.colorScheme.onPrimary)),
            MenuAnchor(
                builder: (BuildContext context, MenuController controller,
                    Widget? child) {
                  return IconButton(
                    onPressed: () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ),
                    tooltip: 'Options',
                  );
                },
                menuChildren: [
                  if (isAdmin)
                    MenuItemButton(
                      onPressed: () {
                        _navigateToArchivedScreen(context);
                      },
                      child: const Text('Archive'),
                    ),
                  MenuItemButton(
                    onPressed: () {
                      logout();
                      _navigateToLoginScreen(context);
                    },
                    child: const Text('Déconnexion'),
                  )
                ])
          ],
        ),
        body: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: switch (isLoading) {
                      false => switch (archivedRequestsModel != null) {
                          true => ListView.separated(
                              separatorBuilder: (context, index) => const Divider(
                                color: Colors.black,
                                indent: 20,
                                endIndent: 20,
                              ),
                              itemCount: archivedRequestsModel!.length,
                              itemBuilder: (context, index) =>
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Center(
                                        child: ArchivedRequest(request: archivedRequestsModel![index])
                                    ),
                                  )
                            ),
                          false => ListView(children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.3),
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
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                  theme.colorScheme.secondary),
                                        ),
                                        onPressed: () {
                                          getRequest();
                                        },
                                        child: Icon(Icons.sync,
                                            size: 40,
                                            color:
                                                theme.colorScheme.onSecondary),
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
                  )
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
                          _navigateToMainScreen(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: theme.colorScheme.onPrimary,
                        )),
                      ),
                    ),
            ]
                )
            )
        )
    );
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToArchivedScreen(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ArchivedPage()));
  }

  void _navigateToMainScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}
