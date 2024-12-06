import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:project_transdata/model/response_model.dart';
import '../model/user_model.dart';
import '../services/users_services.dart';

class ResponseCard extends StatefulWidget {
  final ResponseModel response;

  const ResponseCard({super.key, required this.response});

  @override
  State<ResponseCard> createState() => _ResponseCardState();
}

class _ResponseCardState extends State<ResponseCard> {
  UserModel? responseUser;
  bool isLoading = false;

  Future<void> getUser() async {
    setState(() {
      isLoading = true;
    });
    responseUser = (await UsersService().getUserById(widget.response.userId));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: kElevationToShadow[2],
        ),
        child: Card(
          color: theme.colorScheme.surfaceContainer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), side: BorderSide.none),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
          child: Container(
            constraints: const BoxConstraints(
                minHeight: 130
            ),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: switch (isLoading) {
                  false => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RichText(
                            textAlign: TextAlign.left,
                            text: TextSpan(children: [
                              const TextSpan(
                                  text: 'Rép. de : ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: responseUser?.email,
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black))
                            ])),
                        Container(
                            alignment: Alignment.topLeft,
                            child: RichText(
                                text: TextSpan(
                                  text: widget.response.description ?? '',
                                  style: const TextStyle(fontSize: 20, color: Colors.black)
                                )
                            ),
                        )],
                    ),
                  true => LoadingAnimationWidget.waveDots(
                      size: 150,
                      color: Colors.black45,
                    ),
                }),
          ),
        ),
      ),
    );
  }
}
