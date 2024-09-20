import 'package:flutter/material.dart';
import 'package:project_transdata/screens/request_detail.dart';

import '../model/request_model.dart';

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
  var cardColor = Color(0xFFCAD3DB);


  @override
  Widget build(BuildContext context) {
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
            color: cardColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide.none
            ),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            child: SizedBox(

              height: 130,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Container(
                            alignment: Alignment.center,
                            width: 100,
                            height: 35,
                            decoration: BoxDecoration(
                                border: Border.all(width: 1),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                color: Colors.lightBlue
                            ),
                            child: Text(widget.request.title, style: TextStyle(fontSize: 20, color: Colors.black))
                        ),
                        trailing: const Icon(Icons.keyboard_arrow_right),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                          child: Text(widget.request.description, maxLines: 3, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16, color: Colors.black))
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void goToDetails(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => RequestDetail(request: widget.request)));
  }
}