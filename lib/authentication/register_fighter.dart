import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/regex.dart';

const List<String> genderList = <String>['Male', 'Female'];

const List<String> weightList = <String>[
  'Heavyweight',
  'Cruiserweight',
  'Light heavyweight',
  'Super middleweight',
  'Middleweight',
  'Light middleweight',
  'Welterweight',
  'Light welterweight',
  'Lightweight',
  'Super featherweight',
  'Featherweight',
  'Super bantamweight',
  'Bantamweight',
  'Super flyweight',
  'Flyweight',
  'Light flyweight',
  'Strawweight',
];

class RegisterFighter extends StatefulWidget {
  const RegisterFighter({super.key});

  @override
  State<RegisterFighter> createState() => _RegisterFighterState();
}

class _RegisterFighterState extends State<RegisterFighter> {
  //TODO: Implement registration logic
  //TODO: Add fighter type - box, mma
  String firstName = '';

  String lastName = '';

  String weigthClass = '';

  String nationality = '';

  var genderValue = genderList.first;

  var weightValue = weightList.first;

  String email = '';

  String password = '';

  String bio = '';

  var firstNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var lastNameController = TextEditingController();

  var bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LogoHeader(
              backRequired: true,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 24.0),
              child: Text(
                'Register',
                style: headerStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Row(
                children: [
                  const Text(
                    "Already have an account?",
                    style: bodyStyle,
                  ),
                  TextButton(
                      style: const ButtonStyle(
                          splashFactory: NoSplash.splashFactory),
                      onPressed: () =>
                          Navigator.pushNamed(context, 'loginPage'),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ))
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'First name*',
                      ),
                      onChanged: (value) => firstName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'Last name*',
                      ),
                      onChanged: (value) => lastName = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'Email*',
                      ),
                      onChanged: (value) => email = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field is required';
                        } else if (!emailRgx.hasMatch(value)) {
                          return 'Invalid email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: 'Password*',
                      ),
                      onChanged: (value) => password = value,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: InkWell(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            setState(() => nationality = country.name);
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle:
                              TextStyle(color: Colors.grey, fontSize: 20),
                          labelText: "Nationality*",
                        ),
                        child: nationality != '' ? Text(nationality) : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gender',
                          style: bodyStyle,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        DropdownButton<String>(
                          value: genderValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              genderValue = value!;
                            });
                          },
                          items: genderList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weight class',
                          style: bodyStyle,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        DropdownButton<String>(
                          value: weightValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          style: const TextStyle(color: Colors.white),
                          underline: Container(
                            height: 2,
                            color: Colors.white,
                          ),
                          onChanged: (String? value) {
                            setState(() {
                              weightValue = value!;
                            });
                          },
                          items: weightList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 24.0, right: 24),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Bio/Achievements',
                        style: TextStyle(fontSize: 20, color: Colors.yellow),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: TextFormField(
                        controller: bioController,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: 'Press to type...',
                        ),
                        onChanged: (value) => bio = value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: SizedBox(
                width: 150,
                height: 48,
                child: ElevatedButton(
                    onPressed: () => {},
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
