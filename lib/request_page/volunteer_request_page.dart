import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/helpers/notification_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolRequestPage extends StatefulWidget {
  String? docId;
  bool? isvol;
  VolRequestPage({this.docId, this.isvol, Key? key}) : super(key: key);

  @override
  State<VolRequestPage> createState() => _VolRequestPageState();
}

class _VolRequestPageState extends State<VolRequestPage> {
  Stream<QuerySnapshot> s = const Stream<QuerySnapshot>.empty();
  @override
  void initState() {
    // TODO: implement initState
    getEvents();
    super.initState();
  }

  getEvents() async {
    if (widget.isvol!) {
      setState(() {
        s = FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docId)
            .collection('volunteer')
            .snapshots();
      });
    } else {
      setState(() {
        s = FirebaseFirestore.instance
            .collection('events')
            .doc(widget.docId)
            .collection('participants')
            .snapshots();
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),
      appBar: AppBar(
        title: Text(
         !widget.isvol!?'Participants': 'volunteer',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        backgroundColor: HexColor.fromHex('#12141D'),
        leading: const BackButton(color: Colors.white),

      ),

      body:
      StreamBuilder(
        stream: s,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Container(
                  height: 230,
                  width: 320,
                  decoration: const BoxDecoration(
                      // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20.0, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(document['name']?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email :',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(document['email']?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Phone Number :',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(document['phone']?? '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: ()async{
                              bool isdonene = await NotificationHelper.sendFcmMessage('Declined','Request has been declined',document['fcmToken']);
  print('isdonene');
                              print(isdonene);
                              print('isdonene');
                              },
                              child: Container(
                                height: 35,
                                width: 120,
                                decoration: const BoxDecoration(
                                    // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.red),
                                child: const Center(
                                  child: Text(
                                    'Decline',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                NotificationHelper.sendFcmMessage('Accepted','Request has been accepted',document['fcmToken']);
                              },
                              child: Container(
                                height: 35,
                                width: 120,
                                decoration: const BoxDecoration(
                                    // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.green),
                                child: const Center(
                                  child: Text(
                                    'Accept',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),

    );
  }
}
