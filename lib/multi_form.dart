import 'package:dynamic_form/flight_form.dart';
import 'package:dynamic_form/flight_model.dart';
import 'package:flutter/material.dart';

class MultiForm extends StatefulWidget {
  @override
  _MultiFormState createState() => _MultiFormState();
}

class _MultiFormState extends State<MultiForm> {
  List<FlightForm> flights = [];

  var onPressed;
  @override
  void initState() {
    super.initState();
    onAddFlight();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flight Search"),
        centerTitle: true,
      ),
      body: flights.length <= 0
          ? Center(
              child: Text("Add flight form by tapping [+] button below"),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    addAutomaticKeepAlives: true,
                    itemCount: flights.length,
                    itemBuilder: (_, i) => flights[i],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: searchNow,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'SEARCH',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
      floatingActionButton: flights.length <= 0
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: onAddFlight,
            )
          : null,
    );
  }

  void onDelete(Flight _flight) {
    setState(() {
      var find = flights.firstWhere(
        (element) => element.flight == _flight,
        orElse: () => null,
      );
      if (find != null) flights.removeAt(flights.indexOf(find));
    });
  }

  void onAddFlight() {
    setState(() {
      var _flight = Flight();
      flights.add(FlightForm(
        flight: _flight,
        onDelete: () => onDelete(_flight),
        addNewFlightForm: () => onAddFlight(),
      ));
    });
  }

  void searchNow() {
    if (flights.length > 0) {
      var allvalid = true;
      flights.forEach((form) => allvalid = allvalid && form.isValid());
      if (allvalid) {
        var data = flights.map((e) => e.flight).toList();
        Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text('Search for flight'),
              ),
              body: ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) => ListTile(
                  title: Text(data[i].from),
                  subtitle: Text(data[i].to),
                  trailing: Text(data[i].departue),
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
