import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/request_model.dart';
import '../model/user_model.dart';
import '../services/users_services.dart';

class ArchivedRequest extends StatefulWidget {
  final RequestModel request;

  const ArchivedRequest({
    super.key,
    required this.request
  });

  @override
  State<ArchivedRequest> createState() => _ArchivedRequestState();
}

class _ArchivedRequestState extends State<ArchivedRequest> {
  UserModel? responseUser;
  bool isLoading = false;

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
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(

      children: [
        Text(widget.request.title,
            style: TextStyle(
                fontSize: 22,
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w900)
        ),
        const Spacer(),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
              text: responseUser?.name,
              style: const TextStyle(
                  fontSize: 20, color: Colors.blueAccent)),
        ),
        const Spacer(),
        const Icon(Icons.keyboard_arrow_right),
      ],
    );
  }
}