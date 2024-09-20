import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/main_page.dart';
import '../services/request_local_services.dart';

const List<String> list = <String>['Panne', 'Devis', 'Renseignement'];

class MakeRequest extends StatefulWidget {
  const MakeRequest({
    super.key,
  });

  @override
  State<MakeRequest> createState() => _MakeRequestState();
}

class _MakeRequestState extends State<MakeRequest> {
  SharedPreferences? prefs;
  TextEditingController descriptionController = TextEditingController();
  String title = list.first;
  bool isSendLoading = false;
  String description = '';
  bool isRequestSend = false;

  Future<void> sendRequest() async {
    setState(() {
      description = descriptionController.text;
      isSendLoading = true;
    });
    (await RequestLocalService().saveRequests(title, description))!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          isSendLoading = false;
          showMessageSend();
        }));
  }

  Future<void> showMessageSend() async {
    isRequestSend = true;
    sendEmail();
    Future.delayed(const Duration(seconds: 2)).then((value) => setState(() {
          _navigateToPreviousScreen(context);
        }));
  }

  Future<void> sendEmail() async {
    await FlutterEmailSender.send(Email(
      body: description,
      subject: title,
      recipients: ['M.arto@outlook.fr'],
      isHTML: false,
    ));
  }

  @override
  void initState() {
    setState(() {
      isRequestSend = false;
    });
    super.initState();
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
                      child: SizedBox(
                        child: switch (isSendLoading) {
                          false => Card(
                              color: theme.colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide.none),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Titre : ',
                                      style: TextStyle(
                                          color: theme.colorScheme.onSecondary,
                                          fontSize: 20),
                                    ),
                                    DropdownButton<String>(
                                      value: title,
                                      icon: Icon(
                                        Icons.arrow_downward,
                                        color: theme.colorScheme.onSecondary,
                                      ),
                                      elevation: 16,
                                      style: TextStyle(
                                          color: theme.colorScheme.onSecondary,
                                          fontSize: 20),
                                      dropdownColor: theme.colorScheme.tertiary,
                                      underline: Container(
                                        height: 2,
                                        color: theme.colorScheme.onSecondary,
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
                                    Text(
                                      'Description : ',
                                      style: TextStyle(
                                          color: theme.colorScheme.onSecondary,
                                          fontSize: 20),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: TextFormField(
                                        controller: descriptionController,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ),
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: theme.colorScheme.scrim
                                                .withOpacity(0.5),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 120),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: theme
                                                        .colorScheme.primary)),
                                            border: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.transparent),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            hintStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          true => LoadingAnimationWidget.waveDots(
                              size: 200,
                              color: Colors.black45,
                            ),
                        },
                      ),
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
                                    theme.colorScheme.secondary),
                              ),
                              onPressed: () {
                                _navigateToPreviousScreen(context);
                              },
                              child: Icon(
                                Icons.keyboard_arrow_left,
                                color: theme.colorScheme.onSecondary,
                              )),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    theme.colorScheme.secondary),
                              ),
                              onPressed: () {
                                sendRequest();
                              },
                              child: Text(
                                'Envoyer',
                                style: TextStyle(
                                    color: theme.colorScheme.onSecondary),
                              ))
                        ],
                      ),
                    ),
                  )
                ]),
              ),
            true => const Text('Message envoyer avec succès!'),
          },
        ));
  }

  void _navigateToPreviousScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}
