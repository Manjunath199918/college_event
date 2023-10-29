import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/details_upload/details_upload.dart';
import 'package:clg_events/event_page/event_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _codeController = TextEditingController();
  TextEditingController textControllerone = TextEditingController();
  TextEditingController textControllerTwo = TextEditingController();
  TextEditingController textControllerFour = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading =false;
  Future registerUser(String mobile, BuildContext context) async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      print("+91mobile");
      print("+91$mobile");
      print("+91mobile");

      _auth.verifyPhoneNumber(
          phoneNumber: "+91$mobile",
          timeout: const Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) {
            print('aefsukdvbjgasvsdgjhfsdhgfv');

            print(authCredential.token);
            print('forceResendingToken');
            print(authCredential.runtimeType);
            print(authCredential.providerId);
            print('aefsukdvbjgasvsdgjhfsdhgfv');
          },
          verificationFailed: (FirebaseAuthException authException) {},
          codeSent: (String verificationId, int? forceResendingToken) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                      title: const Text("Enter SMS Code"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _codeController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text("Done"),
                          onPressed: () {
                            FirebaseAuth auth = FirebaseAuth.instance;
                            final _credential = PhoneAuthProvider.credential(
                                verificationId: verificationId,
                                smsCode: _codeController.text.trim());
                            auth
                                .signInWithCredential(_credential)
                                .then((UserCredential result) async {
                              FirebaseAuth _auth = FirebaseAuth.instance;
                              final firebaseFirestore =
                                  FirebaseFirestore.instance;
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              final bool? isAdmin = prefs.getBool('isAdmin');
                              if (isAdmin!) {
                                QuerySnapshot snapshot = await firebaseFirestore
                                    .collection('admins')
                                    .where('phone',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.phoneNumber)
                                    .get();
                                if (snapshot.docs.isEmpty) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UploadDetails()));
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventPage()));
                                }
                              } else {
                                QuerySnapshot snapshot = await firebaseFirestore
                                    .collection('students')
                                    .where('phone',
                                        isEqualTo: FirebaseAuth
                                            .instance.currentUser!.phoneNumber)
                                    .get();
                                if (snapshot.docs.isEmpty) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const UploadDetails()));
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventPage()));
                                }
                              }
                            }).catchError((e) {
                              print(e);
                            });
                          },
                        )
                      ],
                    ));
          },
          codeAutoRetrievalTimeout: (sss) {});
    } catch (e) {

    }
  }

  Future<User?> signInWithGoogle({required BuildContext context}) async {
    setState(() {
      isLoading=true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        final firebaseFirestore = FirebaseFirestore.instance;
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        final bool? isAdmin = prefs.getBool('isAdmin');
        if (isAdmin!) {
          QuerySnapshot snapshot = await firebaseFirestore
              .collection('admins')
              .where('email', isEqualTo: user!.email)
              .get();
          if (snapshot.docs.isEmpty) {
            var uuid = const Uuid();
            String id = uuid.v1();
            FirebaseMessaging _fcm = FirebaseMessaging.instance;
            String? token = await _fcm.getToken();
            await FirebaseFirestore.instance.collection('admins').add({
              'name': FirebaseAuth.instance.currentUser!.displayName,
              'email': FirebaseAuth.instance.currentUser!.email,
              'uid': FirebaseAuth.instance.currentUser!.uid,
              'date': DateTime.now(),
              'id': id,
              'idUrl': 'url',
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
                    (route) => false,//if you want to disable back feature set to false
              );

            });
          }else{
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
          }
        } else {
          QuerySnapshot snapshot = await firebaseFirestore
              .collection('students')
              .where('email', isEqualTo: user!.email)
              .get();
          if (snapshot.docs.isEmpty) {
            setState(() {
              isLoading=false;
            });
            Navigator.pushAndRemoveUntil<dynamic>(
              context,
              MaterialPageRoute<dynamic>(
                builder: (BuildContext context) => const UploadDetails(),
              ),
                  (route) => false,
            );

          } else {
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
          }
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading=false;
        });
        if (e.code == 'account-exists-with-different-credential') {
          const snackBar = SnackBar(
            content: Text('Error please deklete the app and reinstall it'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          setState(() {
            isLoading=false;
          });
          const snackBar = SnackBar(
            content: Text('Error please deklete the app and reinstall it'),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // handle the error here
        }
      } catch (e) {
        setState(() {
          isLoading=false;
        });
        const snackBar = SnackBar(
          content: Text('Error please deklete the app and reinstall it'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: HexColor.fromHex('#12141D'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if(!isLoading){
                  signInWithGoogle(context: context);}

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
                  child: isLoading==true?const Center(
                    child: CircularProgressIndicator(
                      color:Colors.white ,
                    ),
                  ):Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              image: DecorationImage(
                                image: AssetImage('assets/img.png'),
                                fit: BoxFit.fill,
                              )),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          'SignIn With Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
