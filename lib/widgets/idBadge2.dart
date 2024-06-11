import 'package:flutter/material.dart';

class HomeIdBadgeVertical extends StatelessWidget {
  const HomeIdBadgeVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hi Joe!',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 25),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: const CircleAvatar(
              backgroundImage: AssetImage(
                  "assets/WhatsApp Image 2024-04-15 at 19.56.46_41182347-gigapixel-low_res-height-1028px.jpg"),
              radius: 100,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            textAlign: TextAlign.center,
            'No of incidents  reported : 0 \n Total survillance : 0 \n Total distance covered : 0 km',
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 13, color: Colors.amber),
          ),
        ],
      ),
    );
  }
}
