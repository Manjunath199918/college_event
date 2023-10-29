import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/details_upload/details_upload.dart';
import 'package:clg_events/event_page/event_list.dart';
import 'package:clg_events/login/select_optins.dart';
import 'package:clg_events/phone_auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchPage extends StatefulWidget {
  const LaunchPage({Key? key}) : super(key: key);

  @override
  State<LaunchPage> createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  Widget? type;
  int index =0;

  @override
  void initState() {
    setRoute();
    super.initState();
  }

  setRoute()async{


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isAdmin = prefs.getBool('isAdmin');

    if(FirebaseAuth.instance.currentUser==null){
      setState(() {
        index=0;
      });
    }else{
      if(!isAdmin!){
        final firebaseFirestore = FirebaseFirestore.instance;

        QuerySnapshot snapshot = await firebaseFirestore
            .collection('students')
            .where('email', isEqualTo: FirebaseAuth.instance.currentUser!.email)
            .get();
        if(snapshot.docs.isEmpty){
          setState(() {
            index=2;
          });
        }else{
          setState(() {
            index=1;
          });
        }

      }
      else{
        setState(() {
          index=1;
        });
      }

    }




  }

  @override
  Widget build(BuildContext context) {
    Widget type;
    switch (index)
    {


      case 0:
        type = const SelectOption();
        break;
      case 1:
        type =  EventPage();
        break;
      case 2:
        type =  UploadDetails();
        break;



      default:
        type = const Scaffold(
          body: Center(
            child: Text(
              'Unimplemented Screen',
            ),
          ),
        );
    }
    return
      type;
  }
}
