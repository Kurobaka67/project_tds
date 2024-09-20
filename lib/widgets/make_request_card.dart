import 'package:flutter/material.dart';

const List<String> list = <String>['Panne', 'Devis', 'Renseignement'];

class MakeRequestCard extends StatefulWidget {
  final Function(String, String) callback;

  const MakeRequestCard({
    super.key,
    required this.callback
  });

  @override
  State<MakeRequestCard> createState() => _MakeRequestCardState();
}

class _MakeRequestCardState extends State<MakeRequestCard> {
  TextEditingController descriptionController = TextEditingController();
  String title = list.first;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide.none),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Titre : ',
              style: TextStyle(
                  color: theme.colorScheme.onSecondary,
                  fontSize: 20
              ),
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
                  fontSize: 20
              ),
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
                  fontSize: 20
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
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
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 120),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary)),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
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
    );
  }
}