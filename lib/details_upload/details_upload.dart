import 'dart:io';

import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/event_page/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UploadDetails extends StatefulWidget {
  const UploadDetails({Key? key}) : super(key: key);

  @override
  State<UploadDetails> createState() => _UploadDetailsState();
}

class _UploadDetailsState extends State<UploadDetails> {
  DateTime selectedDate = DateTime.now();

  final formKey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  XFile? image;
  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),
      appBar: AppBar(
        backgroundColor: HexColor.fromHex('#12141D'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Enter The Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      image == null
                          ? Container()
                          : Image.file(File(image!.path)),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          XFile? i = await picker.pickImage(
                              source: ImageSource.gallery);
                          setState(() {
                            image = i;
                          });
                        },
                        child: Container(
                          height: 55,
                          //  width: 150,
                          decoration: BoxDecoration(
                              // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              color: HexColor.fromHex('#5C5C5C')),
                          child: const Center(
                            child: Text(
                              'select Id Card ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          if(!isLoading){
                          if (image != null) {
                            setState(() {
                              isLoading=true;
                            });

                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();

                            final bool? isAdmin = prefs.getBool('isAdmin');

                            var uuid = const Uuid();
                            String id = uuid.v1();
                            final destination = 'files/$id';

                            try {
                              if (isAdmin!) {
                                const snackBar = SnackBar(
                                  content: Text('No need to add id for owner'),
                                );

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                FirebaseMessaging _fcm =
                                    FirebaseMessaging.instance;

                                // Future<String?> getToken() async {
                                String? token = await _fcm.getToken();

                                final ref = FirebaseStorage.instance
                                    .ref(destination)
                                    .child('file/');
                                await ref
                                    .putFile(File(image!.path))
                                    .then((p0) async {
                                  var url =
                                      (await ref.getDownloadURL()).toString();

                                  await FirebaseFirestore.instance
                                      .collection('students')
                                      .add({
                                    'name': FirebaseAuth
                                        .instance.currentUser!.displayName,
                                    'email': FirebaseAuth
                                        .instance.currentUser!.email,
                                    'uid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'date': DateTime.now(),
                                    'id': id,
                                    'idUrl': url,
                                    'fcmToken': token,
                                  }).then((value) {
                                    setState(() {
                                      isLoading=false;
                                    });
                                    Navigator.pushAndRemoveUntil<dynamic>(
                                      context,
                                      MaterialPageRoute<dynamic>(
                                        builder: (BuildContext context) => EventPage(),
                                      ),
                                          (route) => false,
                                    );
                                  });
                                });
                              }
                            } catch (e) {
                              const snackBar = SnackBar(
                                content:
                                    Text('There is error in creating a event'),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            const snackBar = SnackBar(
                              content: Text('Please Select a image'),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }}
                        },
                        child: Container(
                          height: 55,
                          width: 320,
                          decoration: BoxDecoration(
                              // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                              color: HexColor.fromHex('#5C5C5C')),
                          child:isLoading?Center(child: const CircularProgressIndicator(color: Colors.white,)): const Center(
                            child: Text(
                              'upload details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
