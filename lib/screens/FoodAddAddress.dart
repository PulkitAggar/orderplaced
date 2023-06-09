import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nb_utils/nb_utils.dart';

import '../blocs/address/address_bloc.dart';

class FoodAddAddress extends StatefulWidget {
  static String tag = '/FoodAddAddress';

  @override
  FoodAddAddressState createState() => FoodAddAddressState();
}

class FoodAddAddressState extends State<FoodAddAddress> {
  String? _selectedLocation = 'Home';
  TextEditingController fullname = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController mobileno = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
          backgroundColor: Colors.white,
          title: const Text(
            'Address',
            style: TextStyle(fontSize: 24, color: Colors.black),
          )),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      foodEditTextStyle('Full name', fullname),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: foodEditTextStyle('Pincode', pincode)),
                          const SizedBox(width: 16),
                          Expanded(child: foodEditTextStyle('City', city)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(child: foodEditTextStyle('State', state)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFFDADADA),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(40))),
                              width: MediaQuery.of(context).size.width,
                              child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                value: _selectedLocation,
                                items: <String>['Home', 'Work']
                                    .map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value,
                                        style: primaryTextStyle(
                                            size: 16,
                                            color: const Color(0xFF949292))),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedLocation = newValue;
                                  });
                                },
                              )),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      foodEditTextStyle('Address', address),
                      const SizedBox(height: 16),
                      foodEditTextStyle('Mobile No', mobileno),
                      const SizedBox(height: 16),
                      GestureDetector(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: const Color(0xFF3B8BEA),
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: defaultBoxShadow()),
                          child: Text('Save address',
                                  style: primaryTextStyle(color: Colors.white))
                              .center(),
                        ),
                        onTap: () {
                          BlocProvider.of<AddressBloc>(context)
                              .add(SaveAddressEvent(
                            address: address.text,
                            city: city.text,
                            fullname: fullname.text,
                            mobileno: mobileno.text,
                            pincode: pincode.text,
                            state: state.text,
                          ));
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Padding foodEditTextStyle(var hintText, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: TextFormField(
      validator: (value) {
        return value != null ? 'Enter $hintText' : null;
      },
      controller: controller,
      style: primaryTextStyle(size: 14),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        hintText: hintText,
        filled: false,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1.0)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40),
            borderSide: const BorderSide(color: Color(0xFFDADADA), width: 1.0)),
      ),
    ),
  );
}
