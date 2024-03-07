import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ftf/reusableWidgets/custom_image_header.dart';
import 'package:ftf/reusableWidgets/dropdown_box.dart';
import 'package:ftf/reusableWidgets/logo_header.dart';
import 'package:ftf/reusableWidgets/rounded_black_button.dart';
import 'package:ftf/reusableWidgets/rounded_text_box.dart';
import 'package:ftf/reusableWidgets/upload_option.dart';
import 'package:ftf/styles/styles.dart';
import 'package:ftf/utils/lists.dart';
import 'package:ftf/utils/snack_bar.dart';
import 'package:image_picker/image_picker.dart';

class MyAccountFighter extends StatefulWidget {
  const MyAccountFighter({super.key});

  @override
  State<MyAccountFighter> createState() => _MyAccountFighterState();
}

class _MyAccountFighterState extends State<MyAccountFighter> {
  final String? currentUser = FirebaseAuth.instance.currentUser?.uid;

  String weight = '';

  TextEditingController emailController = TextEditingController();

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController weightClassController = TextEditingController();

  TextEditingController nationalityController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  ScrollController scrollController = ScrollController();

  CollectionReference<Map<String, dynamic>> userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> getUser() async {
    var result = await userCollection
        .doc(currentUser)
        .get()
        .then((value) => value.data());

    weight = result?['weightClass'];

    emailController.text = result?['email'];
    firstNameController.text = result?['firstName'];
    lastNameController.text = result?['lastName'];
    weightClassController.text = result?['weightClass'];
    nationalityController.text = result?['nationality'];
    bioController.text = result?['description'];

    return result as Map<String, dynamic>;
  }

  late Future<Map<String, dynamic>> future;

  void onDropDownChanged(value) {
    setState(() {
      weight = value!;
    });
  }

  bool isDisabled = true;
  bool isLoading = false;

  void onEditPress() {
    setState(() {
      isDisabled = false;
    });
    scrollController.jumpTo(50);
  }

  void onCancelPress() {
    setState(() {
      isDisabled = true;
    });
  }

  Future<void> onSavePress(String bio, String weightClass) async {
    setState(() {
      isLoading = true;
    });
    await userCollection
        .doc(currentUser)
        .update({'weightClass': weightClass, 'description': bio});
    setState(() {
      isLoading = false;
    });
  }

  File? image;
  String imageName = '';
  final storageRef = FirebaseStorage.instance.ref();

  Future<void> saveImage(File? img) async {
    if (img != null) {
      Reference file =
          storageRef.child('fighterProfiles/$currentUser/profileImage');

      await file.putFile(img);

      String imageURL = (await file.getDownloadURL()).toString();

      await userCollection
          .doc(currentUser)
          .update({'profileImageURL': imageURL});
    }
  }

  void getImage(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemporary = File(image.path);

      imageName = image.name;

      setState(() {
        this.image = imageTemporary;
      });

      await saveImage(this.image);
    } on PlatformException catch (e) {
      if (context.mounted) {
        showSnackBar(text: e.toString(), context: context);
      }
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    future = getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (isDisabled == true) {
                  emailController.text = snapshot.data['email'];
                  firstNameController.text = snapshot.data['firstName'];
                  lastNameController.text = snapshot.data['lastName'];
                  weightClassController.text = snapshot.data['weightClass'];
                  nationalityController.text = snapshot.data['nationality'];
                  bioController.text = snapshot.data['description'];
                  weight = snapshot.data['weightClass'];
                }

                return SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        CustomImageHeader(
                          networkImage: true,
                          backRequired: true,
                          imagePath: snapshot.data['profileImageURL'],
                          onTap: () => chooseUploadOption(
                              context: context, uploadFunction: getImage),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'My account',
                          style: headerStyle,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Container(
                                constraints:
                                    const BoxConstraints(minHeight: 370),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    color: const Color(black),
                                    boxShadow: [containerShadowRed]),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Your details',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        isDisabled != false
                                            ? Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      containerShadowYellow
                                                    ]),
                                                height: 25,
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty.all<
                                                              RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                      )),
                                                    ),
                                                    onPressed: onEditPress,
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.yellow),
                                                    )),
                                              )
                                            : const SizedBox()
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 10,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const SizedBox(
                                              width: 80, child: Text('Email')),
                                          RoundedTextInput(
                                            disabled: true,
                                            controller: emailController,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const SizedBox(
                                              width: 80, child: Text('Name')),
                                          RoundedTextInput(
                                            disabled: true,
                                            width: 95,
                                            controller: firstNameController,
                                          ),
                                          RoundedTextInput(
                                            disabled: true,
                                            width: 95,
                                            controller: lastNameController,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const SizedBox(
                                              width: 80,
                                              child: Text('Weightclass')),
                                          DropdownBox(
                                              disabled: isDisabled,
                                              dropDownValue: weight,
                                              dropDownList: weightList,
                                              changeParentValue: (value) =>
                                                  onDropDownChanged(value))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Wrap(
                                        spacing: 8,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          const SizedBox(
                                              width: 80,
                                              child: Text('Nationality')),
                                          RoundedTextInput(
                                            disabled: true,
                                            width: 150,
                                            controller: nationalityController,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    TextFormField(
                                      style: TextStyle(
                                          color: isDisabled == true
                                              ? Colors.grey
                                              : Colors.white,
                                          fontSize: 14),
                                      keyboardType: TextInputType.multiline,
                                      readOnly: isDisabled,
                                      maxLines: null,
                                      controller: bioController,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 25.0,
                                                horizontal: 10.0),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: isDisabled == true
                                                  ? Colors.grey
                                                  : Colors.white),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: isDisabled == true
                                                    ? Colors.grey
                                                    : Colors.white)),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    isDisabled != true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextButton(
                                                onPressed: onCancelPress,
                                                child: const Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                              BlackRoundedButton(
                                                  isLoading: isLoading,
                                                  onPressed: () => onSavePress(
                                                          bioController.text,
                                                          weight)
                                                      .then((value) => {
                                                            Navigator.pushNamed(
                                                                context,
                                                                'fighterHome'),
                                                            showSnackBar(
                                                                text:
                                                                    'Details updated successfully',
                                                                context:
                                                                    context,
                                                                color: Colors
                                                                    .green)
                                                          }),
                                                  text: 'Save')
                                            ],
                                          )
                                        : const SizedBox()
                                  ]),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              BlackRoundedButton(
                                isLoading: false,
                                onPressed: () => FirebaseAuth.instance
                                    .signOut()
                                    .then((value) => Navigator.pushNamed(
                                        context, 'loginPage')),
                                text: 'Logout',
                              ),
                            ],
                          ),
                        )
                      ],
                    ));
              } else {
                return Column(
                  children: [
                    LogoHeader(backRequired: true),
                    const Center(
                      child: CircularProgressIndicator(),
                    )
                  ],
                );
              }
            }));
  }
}
