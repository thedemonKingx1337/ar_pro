import 'package:ar_dreams/main.dart';
import 'package:flutter/material.dart';

class HomeIdBadge extends StatelessWidget {
  const HomeIdBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(
              'assets/R&C-Logo.png',
              height: 60,
              width: 60,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'R&C Product',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontSize: 15),
                ),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //   'Logged in as',
                  //   style: Theme.of(context).textTheme.titleMedium,
                  // ),
                  // const SizedBox(height: 8),
                  const CircleAvatar(
                    backgroundImage: AssetImage(
                        "assets/WhatsApp Image 2024-04-15 at 19.56.46_41182347-gigapixel-low_res-height-1028px.jpg"),
                    radius: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hi Joe!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
