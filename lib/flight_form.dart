import 'package:flutter/material.dart';

import 'flight_model.dart';

typedef OnDelete();
typedef AddNewFlightForm();

class FlightForm extends StatefulWidget {
  final Flight flight;
  final state = _FlightFormState();
  final OnDelete onDelete;
  final AddNewFlightForm addNewFlightForm;

  FlightForm({Key key, this.flight, this.onDelete, this.addNewFlightForm})
      : super(key: key);
  @override
  _FlightFormState createState() => state;

  bool isValid() => state.validate();
}

class _FlightFormState extends State<FlightForm> {
  final form = GlobalKey<FormState>();
  DateTime date = DateTime.now();

  String getDateText() {
    if (date == null) {
      return 'yyyy/mm/dd';
    } else {
      return '${date.year}/${date.month}/${date.day}';
    }
  }

  @override
  void initState() {
    super.initState();
    widget.flight.departue = getDateText();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Card(
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: TextFormField(
                  initialValue: widget.flight.from,
                  validator: (val) =>
                      val.length > 3 ? null : "Enter a valid city name",
                  onSaved: (val) => widget.flight.from = val,
                  decoration: InputDecoration(
                      labelText: "From", hintText: "Enter a city name"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: TextFormField(
                  initialValue: widget.flight.to,
                  validator: (val) =>
                      val.length > 3 ? null : "Enter a valid city name",
                  onSaved: (val) => widget.flight.to = val,
                  decoration: InputDecoration(
                      labelText: "To", hintText: "Enter a city name"),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15.0),
                    Text('Departure'),
                    SizedBox(height: 5.0),
                    GestureDetector(
                      child: Text(getDateText()),
                      onTap: () async {
                        var sDate = await pickDate(context);

                        setState(() {
                          date = sDate;
                          widget.flight.departue = getDateText();
                        });
                      },
                    ),
                    SizedBox(height: 5.0),
                    Divider(thickness: 1.0, color: Colors.black87)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        color: Colors.red,
                        icon: Icon(
                          Icons.remove_circle,
                          size: 36,
                        ),
                        onPressed: widget.onDelete,
                      ),
                      IconButton(
                        color: Colors.green,
                        icon: Icon(
                          Icons.add_circle,
                          size: 36,
                        ),
                        onPressed: widget.addNewFlightForm,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickDate(context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) {
      return initialDate;
    } else {
      return newDate;
    }
  }

  bool validate() {
    var valid = form.currentState.validate();
    if (valid) form.currentState.save();
    return valid;
  }
}
