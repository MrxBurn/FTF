import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/authentication/fighter_image_upload.dart';
import 'package:ftf/main.dart';
import 'package:ftf/reusableWidgets/dropdown_widget.dart';
import 'package:ftf/reusableWidgets/input_field_widget.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/general.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/utils/snack_bar_no_context.dart';

class RegisterFighterPage extends StatefulWidget {
  RegisterFighterPage({super.key});

  @override
  State<RegisterFighterPage> createState() => _RegisterFighterPageState();
}

class _RegisterFighterPageState extends State<RegisterFighterPage> {
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

  Future<void> registerFighterPage(
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
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async => {
                users.doc(value.user?.uid).set({
                  'email': email,
                  'firstName': firstName,
                  'lastName': lastName,
                  'nationality': nationality,
                  'fighterType': fighterType,
                  'gender': gender,
                  'weightClass': weightClass,
                  'fighterStatus': fighterStatus,
                  'description': bio,
                  'route': 'fighter',
                  'profileImageURL': '',
                  'id': value.user?.uid,
                  'followers': [],
                  'deviceToken': await FirebaseMessaging.instance.getToken(),
                  'eula': false,
                  'reportCount': 0
                })
              });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      String authenticationError = e.message.toString();
      if (context.mounted) {
        isLoading = false;
        showSnackBarNoContext(
            text: authenticationError, snackbarKey: snackbarKey);
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
                      dropDownName: 'Athlete status*'),
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
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(200),
                      ],
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
                          hintText:
                              'Provide a brief description of yourself\nand your accomplishments,\n maximum of 200 characters.'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Center(
              child: BlackRoundedButton(
                isLoading: isLoading,
                onPressed: () => {
                  if (_formKey.currentState!.validate() == true)
                    {
                      registerFighterPage(
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
                          .then((value) => {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FighterImageUpload(),
                                  ),
                                ),
                              })
                    }
                },
                text: 'Register',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
