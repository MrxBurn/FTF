// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/utils/snack_bar.dart';

class RegisterFighter extends StatefulWidget {
  String? offerId;

  RegisterFighter({super.key, this.offerId});

  @override
  State<RegisterFighter> createState() => _RegisterFighterState();
}

class _RegisterFighterState extends State<RegisterFighter> {
  String genderValue = genderList.first;

  var weightValue = weightList.first;

  var fighterStatusValue = fighterStatusList.first;

  var fighterType = fighterTypeList.first;

  var firstNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  var lastNameController = TextEditingController();

  var bioController = TextEditingController();

  var nationalityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  bool isLoading = false;

  String route = '';

  void registerFighter(
      String email,
      String password,
      String firstName,
      String lastName,
      String nationality,
      String fighterType,
      String gender,
      String weightClass,
      String fighterStatus,
      String bio) async {
    try {
      isLoading = true;
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                users.doc(value.user?.uid).set({
                  'firstName': firstName,
                  'lastName': lastName,
                  'nationality': nationality,
                  'fighterType': fighterType,
                  'gender': gender,
                  'weightClass': weightClass,
                  'fighterStatus': fighterStatus,
                  'description': bio,
                  'route': 'fighter',
                  'profileImageURL': ''
                })
              });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      isLoading = false;

      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FighterImageUpload(
                  offerId: widget.offerId,
                )));
      }
    } on FirebaseAuthException catch (e) {
      String authenticationError = e.message.toString();
      if (context.mounted) {
        isLoading = false;
        showSnackBar(text: authenticationError, context: context);
      }
    }
    firstNameController.clear();

    emailController.clear();

    passwordController.clear();

    lastNameController.clear();

    bioController.clear();

    nationalityController.clear();

    confirmPasswordController.clear();
  }

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
                  InputFieldWidget(
                    pLabelText: 'First name*',
                    controller: firstNameController,
                    validatorFunction: (value) => fieldRequired(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'Last name*',
                    controller: lastNameController,
                    validatorFunction: (value) => fieldRequired(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'Email*',
                    controller: emailController,
                    validatorFunction: (value) => emailValidation(value),
                  ),
                  InputFieldWidget(
                    pLabelText: 'Password*',
                    controller: passwordController,
                    validatorFunction: (value) => fieldRequired(value),
                    passwordField: true,
                  ),
                  InputFieldWidget(
                    pLabelText: 'Confirm password*',
                    controller: confirmPasswordController,
                    validatorFunction: (value) => confirmPasswordValidator(
                        value, passwordController.text),
                    passwordField: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      controller: nationalityController,
                      keyboardType: TextInputType.none,
                      readOnly: true,
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          onSelect: (Country country) {
                            setState(() =>
                                nationalityController.text = country.name);
                          },
                        );
                      },
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        labelStyle: TextStyle(color: Colors.grey),
                        labelText: "Nationality*",
                      ),
                    ),
                  ),
                  DropDownWidget(
                      changeParentValue: (v) => {
                            setState(() => fighterType = v),
                          },
                      dropDownValue: fighterType,
                      dropDownList: fighterTypeList,
                      dropDownName: 'Fighter type*'),
                  DropDownWidget(
                      changeParentValue: (v) => {
                            setState(() => genderValue = v),
                          },
                      dropDownValue: genderValue,
                      dropDownList: genderList,
                      dropDownName: 'Gender*'),
                  DropDownWidget(
                      changeParentValue: (v) =>
                          {setState(() => weightValue = v)},
                      dropDownValue: weightValue,
                      dropDownList: weightList,
                      dropDownName: 'Weight class*'),
                  DropDownWidget(
                      changeParentValue: (v) => {
                            setState(() => fighterStatusValue = v),
                          },
                      dropDownValue: fighterStatusValue,
                      dropDownList: fighterStatusList,
                      dropDownName: 'Fighter status*'),
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
                  const SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24),
                    child: TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: bioController,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 25.0, horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Press to type...'),
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
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shadowColor: Colors.red,
                    ),
                    onPressed: () => {
                          if (_formKey.currentState!.validate() == true)
                            {
                              registerFighter(
                                  emailController.text,
                                  passwordController.text,
                                  firstNameController.text,
                                  lastNameController.text,
                                  nationalityController.text,
                                  fighterType,
                                  genderValue,
                                  weightValue,
                                  fighterStatusValue,
                                  bioController.text)
                            }
                        },
                    child: isLoading == true
                        ? const CircularProgressIndicator()
                        : const Text(
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
