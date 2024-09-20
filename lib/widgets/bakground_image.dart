import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration:  BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("assets/images/medical_office.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(theme.colorScheme.primaryFixed, BlendMode.modulate)
        ),
      ),
    );
  }
}