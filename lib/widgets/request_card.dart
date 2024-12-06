import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_transdata/screens/main_page.dart';
import 'package:project_transdata/screens/request_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/request_model.dart';
import '../model/user_model.dart';
import '../services/request_services.dart';
import '../services/users_services.dart';

class RequestCard extends StatefulWidget {
  final RequestModel request;

  const RequestCard({
    super.key,
    required this.request
  });

  @override
  State<RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {
  SharedPreferencesAsync? prefs = SharedPreferencesAsync();
  UserModel? responseUser;
  bool isLoading = false;
  var isAdmin = false;

  Future<void> initializeSharedPreferences() async {
    final bool userAdmin = await prefs?.getBool('admin') ?? false;
    setState(() {
      isAdmin = userAdmin;
    });
    getUser();
  }
  
  Future<void> deleteRequest() async {
    String result = (await RequestService().deleteRequests(widget.request.id));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage()));
  }

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    responseUser = (await UsersService().getUserById(widget.request.userId));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () => {
        goToDetails(context)
      },
      child: Padding(
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
                side: BorderSide.none
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: SizedBox(

              height: isAdmin?200:180,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Text(widget.request.title,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.w900)),
                              ),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    text: responseUser?.name,
                                    style: const TextStyle(
                                        fontSize: 22, color: Colors.blueAccent)),
                                )

                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(widget.request.description ?? '',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black)),
                          ),
                          const Spacer(),
                          if (isAdmin)
                            Row(
                              children: [
                                const SizedBox(),
                                const Spacer(),
                                IconButton(
                                    onPressed: () {
                                      _showAlertDialog(context);
                                    },
                                    style: IconButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.delete,
                                      color: theme.colorScheme.error,
                                    ))
                              ],
                            )
                        ],
                      )
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToDetails(BuildContext context) async {
    SharedPreferencesAsync? prefs = SharedPreferencesAsync();
    await prefs?.setString('page', 'detail_requests');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestDetail(request: widget.request)));
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Archive'),
          content: const Text('Vous êtes sur le point d\'archiver une demande.\n Voulez-vous continuer ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () {
                deleteRequest();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}