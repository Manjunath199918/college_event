import 'package:clg_events/constants/colorsss.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SponsorSendRequest extends StatefulWidget {
  String? docId;

   SponsorSendRequest({this.docId,Key? key}) : super(key: key);

  @override
  State<SponsorSendRequest> createState() => _SponsorSendRequestState();
}

class _SponsorSendRequestState extends State<SponsorSendRequest> {
  TextEditingController textControllerThree=TextEditingController();
  TextEditingController textControllerone=TextEditingController();
  TextEditingController textControllerTwo=TextEditingController();
  TextEditingController textControllerFour=TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),

      body:
      Center(
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
                      const Text('Enter The Information',style: TextStyle(
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
                          labelText: "Enter phone number",

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
                        //maxLines: 5,
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
                          labelText: "Enter email",

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
                        //maxLines: 5,
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
                          labelText: "Enter Donation",

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
                        height: 50,
                      ),



                      InkWell(
                        onTap: ()async{
                          if(!isLoading){
                          final isValid = formKey
                              .currentState!
                              .validate();
                          if (!isValid){
                            return;
                          } else{
                            setState(() {
                              isLoading=true;
                            });
                            var uuid = const Uuid();
                            FirebaseMessaging _fcm = FirebaseMessaging.instance;
                            String? token = await _fcm.getToken();



                            FirebaseFirestore.instance
                                .collection('events').doc(widget.docId).collection('sponsors')
                                .add({'name': textControllerone.text.trim(),
                              'phone': textControllerTwo.text.trim(),
                              'email': textControllerThree.text.trim(),
                              'donation': textControllerFour.text.trim(),
                              'docId':widget.docId,
                              'id':uuid.v1(),
                              'isAccepted':false,
                              'uid':FirebaseAuth.instance.currentUser!.uid,
                              'fcmToken':token

                            }).then((value) {
                              setState(() {
                                isLoading=false;
                              });
                              textControllerone.clear();
                              textControllerTwo.clear();
                              textControllerThree.clear();
                              textControllerFour.clear();


                            });
                          }}
                        },
                        child: Container(
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
                          child: isLoading?const Center(
                            child: CircularProgressIndicator(color: Colors.white,),
                          ):const Center(
                            child: Text('Send Sponsors Request',style: TextStyle(
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
