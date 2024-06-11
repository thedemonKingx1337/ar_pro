import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'sosCardItem.dart';

class SosCard extends StatelessWidget {
  const SosCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          padding: const EdgeInsets.all(8),
          children: const [
            SosCardItem(
                icon: Icons.local_police, text: 'Police', color: Colors.blue),
            SosCardItem(
                icon: Icons.fire_extinguisher,
                text: 'Fire & Safety',
                color: Colors.orange),
            SosCardItem(
                icon: Icons.local_hospital,
                text: 'Health Care',
                color: Colors.green),
            SosCardItem(
                icon: Icons.notifications_active,
                text: 'Alarm',
                color: Colors.purple),
          ],
        ),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white,
                  width: 8,
                  strokeAlign: BorderSide.strokeAlignOutside)),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ],
    );
  }
}
