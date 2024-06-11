import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/idBadge.dart';
import 'ar_view.dart';
import 'reportScreen.dart';
import '../widgets/sosCard.dart';
import '../widgets/main_drawer.dart';
import '../widgets/idBadge2.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void sosCardUp(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (bcontext) => const SosCard(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const MainDrawer(),
      appBar: AppBar(
          leading: Container(
            padding: const EdgeInsets.only(left: 5, bottom: 5),
            child: Image.asset('assets/R&C-Logo.png'),
          ),
          title: const Text('AR  SURVEILLANCE')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const HomeIdBadgeVertical(),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 3,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () => Navigator.pushNamed(context, ARView.routeName),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'AR Viewer',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ReportScreen())),
              style: ElevatedButton.styleFrom(
                elevation: 5,
                foregroundColor: Theme.of(context).colorScheme.onBackground,
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Report Incident',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 3.0,
          ),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: FloatingActionButton(
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(.2),
            onPressed: () {
              return sosCardUp(context);
            },
            child: Icon(
              Icons.sos_rounded,
              size: 25,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
