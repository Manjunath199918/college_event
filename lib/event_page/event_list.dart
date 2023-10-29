import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/event_create/event_create.dart';
import 'package:clg_events/event_histroy/event_history.dart';
import 'package:clg_events/request_page/send_request_page.dart';
import 'package:clg_events/request_page/sponser_request_page.dart';
import 'package:clg_events/request_page/sponsor_send_request.dart';
import 'package:clg_events/request_page/volunteer_request_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventPage extends StatefulWidget {
  EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Stream<QuerySnapshot> s = const Stream<QuerySnapshot>.empty();
  @override
  void initState() {
    // TODO: implement initState
    getEvents();
    super.initState();
  }

  getEvents() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final bool? isAdmin = prefs.getBool('isAdmin');
    if (isAdmin!) {
      setState(() {
        DateTime x = DateTime.now().subtract(const Duration(days: 5));

        s = FirebaseFirestore.instance
            .collection('events')
            .where('date', isGreaterThan: x)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots();
      });
    } else {
      setState(() {
        DateTime x = DateTime.now().subtract(const Duration(days: 5));

        s = FirebaseFirestore.instance
            .collection('events')
            .where('date', isGreaterThan: x)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        backgroundColor: HexColor.fromHex('#12141D'),
        actions: [
          InkWell(
            onTap: ()async{
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();

              final bool? isAdmin = prefs.getBool('isAdmin');
              if (isAdmin!) {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) =>  EventHistory( )));
              } else {
                const snackBar = SnackBar(
                  content: Text('you don\'t have access to see history of events'),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }

            },
            child: const Padding(
              padding:  EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('History',style: TextStyle(color: Colors.white,fontSize: 18),),
            ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();

            final bool? isAdmin = prefs.getBool('isAdmin');
            if (isAdmin!) {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const CreateEvent()));
            } else {
              const snackBar = SnackBar(
                content: Text('you dont have access to create a event'),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          backgroundColor: HexColor.fromHex('#5C5C5C'),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: StreamBuilder(
        stream: s,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Container(
                child: const Text(
                  'There is no events at this time',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: Container(
                  height: 280,
                  width: 320,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              document['url'])),
                      // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                      borderRadius: const BorderRadius.only(
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
                        Text(document['name'] ?? '',
                            maxLines: 1,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(document['des'] ?? '',
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Date :',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                    DateTime.fromMillisecondsSinceEpoch(
                                                document['date']
                                                    .millisecondsSinceEpoch)
                                            .toString() ??
                                        '',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Place :',
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(document['place'] ?? '',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                final bool? isAdmin = prefs.getBool('isAdmin');
                                if (isAdmin!) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VolRequestPage(
                                          docId: document.reference.id,
                                          isvol: true)));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SendRequest(
                                          docId: document.reference.id,
                                          isvol: true)));
                                }
                              },
                              child: Container(
                                // height: 55,
                                // width: 320,
                                decoration: const BoxDecoration(
                                    // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.black),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Volunteer',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                final bool? isAdmin = prefs.getBool('isAdmin');
                                if (isAdmin!) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => VolRequestPage(
                                          docId: document.reference.id,
                                          isvol: false)));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SendRequest(
                                          docId: document.reference.id,
                                          isvol: false)));
                                }
                              },
                              child: Container(
                                // height: 55,
                                // width: 320,
                                decoration: const BoxDecoration(
                                    // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.black),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Participants',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                final bool? isAdmin = prefs.getBool('isAdmin');
                                if (isAdmin!) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SponsorRequestPage(
                                            docId: document.reference.id,
                                          )));
                                } else {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => SponsorSendRequest(
                                            docId: document.reference.id,
                                          )));
                                }
                              },
                              child: Container(
                                // height: 55,
                                // width: 320,
                                decoration: const BoxDecoration(
                                    // color: currentTheme.themeBox.colors.blankButton.withOpacity(0.04),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                    color: Colors.black),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    'Sponsors',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
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
