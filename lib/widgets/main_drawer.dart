import 'package:ar_dreams/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/log_screen.dart';
import '../screens/reportedIncidentsDisplayScreen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  Widget buildListTile(
    IconData icon,
    String name,
    void Function() tapAction,
    BuildContext context,
  ) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
      title: Text(
        name,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
      onTap: tapAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/R&C-Logo.png')),
          ),
          // SizedBox(
          //   height: 100,
          //   width: 100,
          //   child: Container(
          //     height: 150,
          //     width: double.infinity,
          //     padding: const EdgeInsets.all(20),
          //     alignment: Alignment.center,
          //     child: Text("Logs",
          //         style: TextStyle(
          //             color: Theme.of(context).colorScheme.onBackground)),
          //   ),
          // ),
        ]),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: buildListTile(
            FontAwesomeIcons.hourglassEnd,
            "Open AR Log",
            () {
              Navigator.pushNamed(context, LogScreen.routeName);
            },
            context,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: buildListTile(
            FontAwesomeIcons.bell,
            "Incident Report Log",
            () {
              Navigator.pushNamed(
                  context, ReportedIncidentsDisplayScreen.routeName);
            },
            context,
          ),
        ),
      ]),
    );
  }
}
