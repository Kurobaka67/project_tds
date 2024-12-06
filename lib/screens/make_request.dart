import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/main_page.dart';
import '../services/request_services.dart';
import '../services/users_services.dart';
import 'archived_page.dart';
import 'login_page.dart';

const List<String> list = <String>['Panne', 'Devis', 'Renseignement'];

class MakeRequest extends StatefulWidget {
  const MakeRequest({
    super.key,
  });

  @override
  State<MakeRequest> createState() => _MakeRequestState();
}

class _MakeRequestState extends State<MakeRequest>
    with SingleTickerProviderStateMixin {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  TextEditingController descriptionController = TextEditingController();
  late AnimationController animationController;
  String name = '';
  String title = list.first;
  bool isSendLoading = false;
  bool isLoggedIn = false;
  bool isAdmin = false;
  String description = '';
  bool isRequestSend = false;
  bool isRequestSendSucces = false;
  bool notificationActivated = false;

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
  }

  Future<void> activateNotification() async {
    var result = (await UsersService().changeNotification());
    setState(() {
      notificationActivated = result;
    });
  }

  Future<void> sendRequest() async {
    setState(() {
      description = descriptionController.text;
      isSendLoading = true;
    });
    isRequestSendSucces =
        (await RequestService().saveRequests(title, description));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          isSendLoading = false;
          showMessageSend();
        }));
  }

  Future<void> showMessageSend() async {
    isRequestSend = true;
    animationController.forward();
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          _navigateToPreviousScreen(context);
        }));
  }

  @override
  void initState() {
    setState(() {
      isRequestSend = false;
    });
    super.initState();
    initializeSharedPreferences();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            backgroundColor: theme.colorScheme.primary,
            automaticallyImplyLeading: false,
            title: Text(
              name,
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    activateNotification();
                  },
                  icon: Icon(
                      Icons.notifications,
                      color: notificationActivated?Colors.yellow:theme.colorScheme.onPrimary
                  )
              ),
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
                    if(isAdmin)
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
          body: Center(
            child: switch (isRequestSend) {
              false => Form(
                  child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: switch (isSendLoading) {
                          false => Column(
                              children: [
                                Stack(children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.all(8.0),
                                    width: 350,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: theme.colorScheme.primary,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: DropdownButton<String>(
                                      value: title,
                                      icon: Icon(
                                        Icons.arrow_downward,
                                        color: theme.colorScheme.primary,
                                      ),
                                      elevation: 16,
                                      style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                      dropdownColor:
                                          theme.colorScheme.primaryContainer,
                                      underline: Container(
                                        height: 2,
                                        color: theme.colorScheme.primary,
                                      ),
                                      onChanged: (String? value) {
                                        // This is called when the user selects an item.
                                        setState(() {
                                          title = value!;
                                        });
                                      },
                                      items: list.map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      margin: const EdgeInsets.only(right: 150),
                                      color: theme.colorScheme.surface,
                                      child: Text(
                                        'Objet',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                                Stack(children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 40),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: TextField(
                                        minLines: 8,
                                        maxLines: 8,
                                        keyboardType: TextInputType.multiline,
                                        controller: descriptionController,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10, horizontal: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    width: 2,
                                                    color: theme.colorScheme.primary),
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: theme.colorScheme.primary),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            )),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      margin: const EdgeInsets.only(right: 150, top: 30),
                                      color: theme.colorScheme.surface,
                                      child: Text(
                                        'Description',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ])
                              ],
                            ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 3, vertical: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      theme.colorScheme.primary),
                                ),
                                onPressed: () {
                                  _navigateToPreviousScreen(context);
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_left,
                                  color: theme.colorScheme.onPrimary,
                                )),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      theme.colorScheme.primary),
                                ),
                                onPressed: () {
                                  sendRequest();
                                },
                                child: Text(
                                  'Envoyer',
                                  style: TextStyle(
                                      color: theme.colorScheme.onPrimary),
                                ))
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              true => switch (isRequestSendSucces) {
                  true => AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) => Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              size: animationController.value * 150,
                              color: Colors.green,
                            ),
                            Text(
                              'Message envoyé avec succès!',
                              style: TextStyle(
                                  fontSize: animationController.value * 24),
                            )
                          ],
                        ),
                      ),
                    ),
                  false => AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) => Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel,
                              size: animationController.value * 150,
                              color: Colors.red,
                            ),
                            Text(
                              'Erreur lors de l\'envoi du message!',
                              style: TextStyle(
                                  fontSize: animationController.value * 24),
                            )
                          ],
                        ),
                      ),
                    )
                }
            },
          )),
    );
  }

  void _navigateToPreviousScreen(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  void _navigateToLoginScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  void _navigateToArchivedScreen(BuildContext context) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const ArchivedPage()));
  }
}
