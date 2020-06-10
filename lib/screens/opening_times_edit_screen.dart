import 'package:flutter/material.dart';
import 'package:foodorderingadmin/models/opening_hour.dart';

class OpeningTimesEditScreen extends StatefulWidget {
  static const routeName = "openingtimesedit";

  @override
  _OpeningTimesEditScreenState createState() => _OpeningTimesEditScreenState();
}

class _OpeningTimesEditScreenState extends State<OpeningTimesEditScreen> {
  @override
  Widget build(BuildContext context) {
    final openingHour =
        ModalRoute.of(context).settings.arguments as OpeningHour;

    return Scaffold(
        appBar: AppBar(
          title: Text("Edit ${openingHour.day}"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            CheckboxListTile(
              title: Text("Closed"),
              value: openingHour.closed,
              onChanged: (value) {
                setState(() {
                  openingHour.closed = value;
                });
              },
            ),
            Divider(),
            ListTile(
              title: Text("Open From"),
              trailing: Container(
                width: 75,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.right,
                  initialValue:
                      openingHour.start != null ? openingHour.start : "N/A",
                  onChanged: (value) {
                    openingHour.start = value;
                  },
                ),
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Open To"),
              trailing: Container(
                width: 75,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    initialValue:
                        openingHour.end != null ? openingHour.end : "N/A",
                    onChanged: (value) {
                      openingHour.end = value;
                    }),
              ),
            ),
            Divider(),
          ]),
        ));
  }
}
