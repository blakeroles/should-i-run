import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/components/custom_suffix_item.dart';

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();
  String location;
  final List<String> errors = [];
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          buildLocationFormField(),
        ]));
  }

  TextFormField buildLocationFormField() {
    return TextFormField(
        keyboardType: TextInputType.text,
        onSaved: (newValue) => location = newValue,
        onChanged: (value) {
          if (value.isNotEmpty && errors.contains(kLocationNullError)) {
            setState(() {
              errors.remove(kLocationNullError);
            });
          }
          return null;
        },
        validator: (value) {
          if (value.isEmpty && !errors.contains(kLocationNullError)) {
            setState(() {
              errors.add(kLocationNullError);
            });
            return "";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Location",
          hintText: "Enter your location",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: CustomSuffixIcon(
            svgIcon: "assets/icons/Location point.svg",
          ),
        ));
  }
}
