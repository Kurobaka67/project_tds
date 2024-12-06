import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_transdata/model/user_model.dart';
import 'package:project_transdata/services/responses_services.dart';

import '../model/request_model.dart';
import '../model/response_model.dart';
import '../services/users_services.dart';
import '../widgets/response_card.dart';
import '../screens/main_page.dart';

class RequestDetail extends StatefulWidget {
  final RequestModel request;

  const RequestDetail({super.key, required this.request});

  @override
  State<RequestDetail> createState() => _RequestDetail();
}

class _RequestDetail extends State<RequestDetail> {
  TextEditingController responseController = TextEditingController();
  UserModel? requestUser;
  late List<ResponseModel>? responsesModel = [];
  String response = '';
  bool isLoading = false;
  bool isSendLoading = false;

  Future<void> sendResponse() async {
    setState(() {
      response = responseController.text;
      isSendLoading = true;
    });
    (await ResponsesService().saveResponses(widget.request.id, response));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          isSendLoading = false;
          reloadScreen();
        }));
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    requestUser = (await UsersService().getUserById(widget.request.userId));
  }

  Future<void> getResponses() async {
    responsesModel =
        (await ResponsesService().getResponsesByRequestId(widget.request.id));
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {
          isLoading = false;
        }));
  }

  Future<void> reloadScreen() async {
    getUser();
    getResponses();
  }

  @override
  void initState() {
    super.initState();
    reloadScreen();
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: switch (isLoading) {
                    false => Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: kElevationToShadow[2],
                                    ),
                                    child: Card(
                                      color: theme.colorScheme.surfaceContainer,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          side: BorderSide.none),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 3),
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          minHeight: 150
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 10),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 15),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(widget.request.title,
                                                      style: TextStyle(
                                                          fontSize: 22, color: theme.colorScheme.primary, fontWeight: FontWeight.w900)),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text('De : ',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Text(requestUser?.email ?? '',
                                                      style: const TextStyle(
                                                          fontSize: 20))
                                                ],
                                              ),
                                              RichText(
                                                  text: TextSpan(children: [
                                                const TextSpan(
                                                    text: 'Description : ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        widget.request.description ??
                                                            '',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.black))
                                              ])),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                for (var response in responsesModel!)
                                  ResponseCard(response: response)
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: TextField(
                                minLines: 2,
                                maxLines: 2,
                                keyboardType: TextInputType.multiline,
                                controller: responseController,
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondary,
                                  fontSize: 20,
                                ),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        theme.colorScheme.tertiary,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 3,
                                          color: theme.colorScheme.secondary),
                                        borderRadius: BorderRadius.circular(25)),
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    true => LoadingAnimationWidget.waveDots(
                        size: 150,
                        color: Colors.black45,
                      ),
                  }),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  border: Border(top: BorderSide(width: 2))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3, vertical: 30),
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
                          sendResponse();
                        },
                        child: switch (isSendLoading) {
                          false => Text(
                              'Répondre',
                              style: TextStyle(
                                  color: theme.colorScheme.onPrimary),
                            ),
                          true => LoadingAnimationWidget.waveDots(
                              size: 20,
                              color: Colors.black45,
                            ),
                        })
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }

  void _navigateToPreviousScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}
