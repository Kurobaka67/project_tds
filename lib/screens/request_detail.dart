import 'package:flutter/material.dart';

import '../model/request_model.dart';
import 'main_page.dart';

class RequestDetail extends StatefulWidget {
  final RequestModel request;

  const RequestDetail({
    super.key,
    required this.request
  });

  @override
  State<RequestDetail> createState() => _RequestDetail();
}

class _RequestDetail extends State<RequestDetail> {
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
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.8,
              child: ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      boxShadow: kElevationToShadow[2],
                    ),
                    child: Card(
                      color: const Color(0xFFCAD3DB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide.none
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("Titre : ", style: TextStyle(fontSize: 20)),
                                Text(widget.request.title, style: const TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                const Text('De : ', style: TextStyle(fontSize: 20)),
                                Text(widget.request.person, style: const TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Description : ', style: TextStyle(fontSize: 20)),
                                Expanded(
                                  flex: 1,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Text(widget.request.description, maxLines: null, style: const TextStyle(fontSize: 20)),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
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

                        },
                        child: Text(
                          'Répondre',
                          style: TextStyle(
                              color: theme.colorScheme.onSecondary),
                        ))
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  void _navigateToPreviousScreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const MainPage()));
  }
}