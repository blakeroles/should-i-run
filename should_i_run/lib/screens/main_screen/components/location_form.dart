import 'package:flutter/material.dart';
import 'package:should_i_run/constants.dart';
import 'package:should_i_run/components/custom_suffix_item.dart';
import 'package:should_i_run/size_config.dart';
import 'package:should_i_run/components/form_error.dart';
import 'package:should_i_run/components/default_button.dart';

class LocationForm extends StatefulWidget {
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _formKey = GlobalKey<FormState>();
  String location;
  bool remember = false;
  final List<String> errors = [];
  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          buildLocationFormField(),
          Row(children: [
            Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                }),
            Text("Remember location"),
          ]),
          SizedBox(height: getProportionateScreenHeight(20)),
          FormError(errors: errors),
          DefaultButton(
              text: "Submit",
              press: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                }
              })
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
