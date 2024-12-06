import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/main_page.dart';
import '../services/request_services.dart';

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
  TextEditingController descriptionController = TextEditingController();
  late AnimationController animationController;
  String title = list.first;
  bool isSendLoading = false;
  String description = '';
  bool isRequestSend = false;
  bool isRequestSendSucces = false;

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
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
          child: switch (isRequestSend) {
            false => Form(
                child: Column(children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: switch (isSendLoading) {
                        false => Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: kElevationToShadow[2],
                                color: Colors.black45.withOpacity(0.3)),
                            child: Card(
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
                                    Row(
                                      children: [
                                        Text(
                                          'Objet : ',
                                          style: TextStyle(
                                              color: theme.colorScheme
                                                  .onSecondaryContainer,
                                              fontSize: 20),
                                        ),
                                        DropdownButton<String>(
                                          value: title,
                                          icon: Icon(
                                            Icons.arrow_downward,
                                            color: theme.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                          elevation: 16,
                                          style: TextStyle(
                                              color: theme.colorScheme
                                                  .onSecondaryContainer,
                                              fontSize: 20),
                                          dropdownColor: theme
                                              .colorScheme.primaryContainer,
                                          underline: Container(
                                            height: 2,
                                            color: theme.colorScheme
                                                .onSecondaryContainer,
                                          ),
                                          onChanged: (String? value) {
                                            // This is called when the user selects an item.
                                            setState(() {
                                              title = value!;
                                            });
                                          },
                                          items: list
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
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
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: TextField(
                                          minLines: 8,
                                          maxLines: 8,
                                          keyboardType: TextInputType.multiline,
                                          controller: descriptionController,
                                          style: TextStyle(
                                            color: theme.colorScheme.onTertiary,
                                            fontSize: 20,
                                          ),
                                          decoration: InputDecoration(
                                              filled: true,
                                              fillColor: theme
                                                  .colorScheme.tertiary
                                                  .withOpacity(0.5),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 10),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 3,
                                                      color: theme
                                                          .colorScheme.primary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16)),
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
        );
  }

  void _navigateToPreviousScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}
