import 'dart:io';

import 'package:clg_events/constants/colorsss.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({Key? key}) : super(key: key);

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  DateTime selectedDate = DateTime.now();

  TextEditingController textControllerThree=TextEditingController();
  TextEditingController textControllerone=TextEditingController();
  TextEditingController textControllerTwo=TextEditingController();
  TextEditingController textControllerFour=TextEditingController();

  final formKey = GlobalKey<FormState>();
  ImagePicker picker = ImagePicker();
  XFile? image;
  bool isLoading =false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),
      appBar: AppBar(
        backgroundColor: HexColor.fromHex('#12141D'),

      ),

      body:  Center(
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
                    const Text('Enter The Details',style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,

                    ),),
                    const SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      controller: textControllerone,
                      style: const TextStyle(color: Colors.white),


                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Colors.white
                            ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white,
                        labelText: "Enter name",

                        labelStyle: const TextStyle(
                            color: Colors.white
                        ),
                        border:const OutlineInputBorder(

                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )

                        ) ,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Cannot be empty';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: textControllerTwo,
                      style: const TextStyle(color: Colors.white),

                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Colors.white
                            ),

                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white,
                        labelText: "Enter description",

                        labelStyle: const TextStyle(
                            color: Colors.white
                        ),
                        border:const OutlineInputBorder(

                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white,

                            )

                        ) ,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Cannot be empty';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: textControllerThree,
                      style: const TextStyle(color: Colors.white),

                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Colors.white
                            ),

                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white,
                        labelText: "Enter Place",

                        labelStyle: const TextStyle(
                            color: Colors.white
                        ),
                        border:const OutlineInputBorder(

                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )

                        ) ,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )
                        ),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Cannot be empty';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: textControllerFour,
                      style: const TextStyle(color: Colors.white),

                      decoration:   InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2,
                              color: Colors.white
                          ),

                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        fillColor: Colors.white,
                        labelText: "Enter date",

                        labelStyle: const TextStyle(
                            color: Colors.white
                        ),
                        border:const OutlineInputBorder(

                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )

                        ) ,
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Colors.white
                            )
                        ),

                      ),
                      onTap: ()async{
                        final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2015, 8),
                            lastDate: DateTime(2101));
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                            textControllerFour.text =picked.toString();
                          });
                        }
                      },
                      // readOnly: true,
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Cannot be empty';
                        }else{
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 50,),
                    image == null?Container():
                    Image.file(File(image!.path)),
                    const SizedBox(height: 30,),
                    InkWell(
                      onTap: ()async{
                        XFile? i = await picker.pickImage(
                            source: ImageSource.gallery);
                        setState(() {
                          image = i;
                        });




                      },
                      child: Container(
                        height: 55,
                        width: 150,
                        decoration: BoxDecoration(
                          // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                            borderRadius: const BorderRadius.
                            only(
                              topLeft: Radius.circular(  12),
                              topRight: Radius.circular(  12),
                              bottomLeft: Radius.circular( 12),
                              bottomRight: Radius.circular( 12),
                            ),
                            color: HexColor.fromHex('#5C5C5C')

                        ),
                        child: const Center(
                          child: Text('Select Image',style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                          ),),
                        ),

                      ),
                    ),
                    const SizedBox(height: 30,),


                    InkWell(
                      onTap: () async {
                        if(!isLoading){

                        final isValid = formKey
                            .currentState!
                            .validate();
                        if (!isValid){
                          return;
                        }
                        else{
                          if(image!=null){
                            setState(() {
                              isLoading=true;
                            });

                          var uuid = const Uuid();
                          String id =uuid.v1();

                            if (image == null) return;
                            final destination = 'files/$id';

                            try {

                              final ref = FirebaseStorage.instance
                                  .ref(destination)
                                  .child('file/');
                              await ref.putFile(File(image!.path)).then((p0) async{
                               var url = (await ref.getDownloadURL()).toString();


                                await  FirebaseFirestore.instance
                                    .collection('events')
                                    .add({'name': textControllerone.text.trim(),
                                  'place': textControllerThree.text.trim(),
                                  'des': textControllerTwo.text.trim(),
                                  'date': selectedDate,
                                  'id':id,
                                  'url':url,
                                  'uid':FirebaseAuth.instance.currentUser!.uid,
                                }).then((value) {
                                  setState(() {
                                    isLoading=false;
                                    image=null;
                                  });
                                  const snackBar = SnackBar(
                                    content: Text('Successfully created a event'),

                                  );


                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                  textControllerone.clear();
                                  textControllerTwo.clear();
                                  textControllerThree.clear();
                                  textControllerFour.clear();

                                });
                              });
                            } catch (e) {
                              setState(() {
                                isLoading=false;
                              });
                              const snackBar = SnackBar(
                                content: Text('There is error in creating a event'),

                              );


                              ScaffoldMessenger.of(context).showSnackBar(snackBar);                            }






                        }else{
                            setState(() {
                              isLoading=false;
                            });
                            const snackBar = SnackBar(
                              content: Text('Please Select a image'),

                            );


                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }}
                      },
                      child:
                      Container(
                        height: 55,
                        width: 320,
                        decoration: BoxDecoration(
                          // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                            borderRadius: const BorderRadius.
                            only(
                              topLeft: Radius.circular(  12),
                              topRight: Radius.circular(  12),
                              bottomLeft: Radius.circular( 12),
                              bottomRight: Radius.circular( 12),
                            ),
                            color: HexColor.fromHex('#5C5C5C')

                        ),
                        child: isLoading?const Center(child: CircularProgressIndicator(color: Colors.white,)): const Center(
                          child: Text('Post An Event',style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,

                          ),),
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
