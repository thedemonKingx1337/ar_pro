import 'package:flutter/material.dart';

import '../model/reportModel.dart';
import 'ReportMap_fullscreen.dart';
import 'ReportedIncidentImageFullScreen.dart';

class ReportedIncidents_DetailsScreen extends StatelessWidget {
  static const routeName = "/reportedIncidents_DetailsScreen";
  static const googleapi = "AIzaSyAuRZaxxxxxxxxxxxxxxxxxxxxx";
  final Report report;

  const ReportedIncidents_DetailsScreen({super.key, required this.report});

  String get locationImageURL {
    final lat = report.location.latitude;
    final lng = report.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:purple%7Clabel:A%7C$lat,$lng&key=$googleapi';
  }

  @override
  Widget build(BuildContext context) {
    final severityText = report.severity.toString().split('.').last.toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Incident Details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).highlightColor.withOpacity(.1),
          ),
          child: Column(
            children: [
              _buildSeverityHeader(context, severityText),
              _buildTitle(context),
              _buildDescription(context),
              _buildImagesGrid(context),
              _buildLocationMap(context),
              _buildAddress(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeverityHeader(BuildContext context, String severityText) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: severityColor[report.severity],
          ),
        ),
        Text(
          "$severityText SEVERITY",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        )
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        report.title,
        style: Theme.of(context)
            .textTheme
            .titleLarge!
            .copyWith(color: Theme.of(context).colorScheme.onBackground, fontSize: 20),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            report.description,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Theme.of(context).colorScheme.onBackground, fontSize: 15),
          ),
        ),
      ),
    );
  }

  Widget _buildImagesGrid(BuildContext context) {
    int getGridCount() {
      int imageCount = report.images.length;
      if (imageCount == 1) {
        return 1;
      } else if (imageCount == 2) {
        return 2;
      } else {
        return 3;
      }
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 18),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getGridCount(),
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 2 / 3,
      ),
      itemCount: report.images.length,
      itemBuilder: (context, index) {
        final image = report.images[index];
        if (image != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReportedIncidentImageFullScreen(imageFile: image),
                ),
              ),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildLocationMap(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(100)),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ReportMapFullScreen(
              initialLocation: report.location,
              isSelecting: false,
            ),
          ),
        );
      },
      child: CircleAvatar(
        radius: 70,
        backgroundImage: NetworkImage(locationImageURL),
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.transparent, Colors.black26],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Text(
        report.location.address,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
