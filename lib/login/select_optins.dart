import 'package:clg_events/constants/colorsss.dart';
import 'package:clg_events/phone_auth/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectOption extends StatefulWidget {
  const SelectOption({Key? key}) : super(key: key);

  @override
  State<SelectOption> createState() => _SelectOptionState();
}

class _SelectOptionState extends State<SelectOption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor.fromHex('#12141D'),

      body:  Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Choose Your Role',style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,

              ),),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: ()async{
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isAdmin', false);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));



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
                  child: const Center(
                    child: Text('Student',style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,

                    ),),
                  ),

                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: ()async{
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isAdmin', true);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Login()));

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
                  child: const Center(
                    child: Text('Owner',style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,

                    ),),
                  ),

                ),
              )


            ],
          ),
        ),
      ),
    );
  }
}
