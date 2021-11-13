import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../main.dart';
import 'Login.dart';
import 'Signup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
class _ProfileScreenState extends State<ProfileScreen> {
  var username,email,Bio;
  final Bio_Controller = TextEditingController();

  void getNameEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    var userUid = user.uid;

    CollectionReference collection2 = FirebaseFirestore.instance.collection("users/${userUid}/user_info");
    QuerySnapshot querySnapshot2 = await collection2.get();
    username = querySnapshot2.docs.map((doc) {
      return doc.get("user_name");
    }).toList()[0];
    email = querySnapshot2.docs.map((doc) {
      return doc.get("user_email");
    }).toList()[0];
    Bio = querySnapshot2.docs.map((doc) {
      return doc.get("user_bio");
    }).toList()[0];
    setState(() {});
  }

  void initState(){
    getNameEmail();
  }

  void dispose() {
    Bio_Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF6F35A5),
        title: Padding(
          padding: EdgeInsets.only(left: 15),
          child: new Text(
            'Profile',
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFFF1E6FF),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
            color: Color(0xFF6F35A5),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            }, icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 13,left: 13,bottom: 16,top: 13),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  color: Color(0xFF6F35A5),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/Assets/Images/backGround.jpeg"),
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.topLeft,
                      ),
                    ),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 20),
                            child: Container(
                              width: 250,
                              child: Column(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(18.0,0.0,8.0,0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: new Text(
                                            "${username}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            // textAlign: TextAlign.left,
                                            style: GoogleFonts.getFont(
                                              'Montserrat',
                                              color: Colors.white,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(color: Colors.white,)
                                    ],
                                  ),
                                  // SizedBox(height: 20,),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 160,
                                width: 130,
                                alignment: Alignment.centerRight,
                                child: ClipRect(
                                  child: Image(
                                    fit: BoxFit.contain,
                                    alignment: Alignment.topRight,
                                    image: AssetImage(
                                        "lib/Assets/Images/UserImage.png"
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Email",
                        style: GoogleFonts.getFont(
                            'Montserrat',
                            color: Color(0xFF6F35A5),
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      width: 220,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: new Text(
                          "${email}",
                          textAlign: TextAlign.start,
                          style: GoogleFonts.getFont(
                            'Montserrat',
                            color: Colors.black,
                            fontSize: 23,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,12,0,12),
                  child: Divider(color: Color(0xFF6F35A5),),
                ),
                GestureDetector(
                  onTap: (){
                    showAlertDialog(context);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Bio",
                          style: GoogleFonts.getFont(
                              'Montserrat',
                              color: Color(0xFF6F35A5),
                              fontSize: 23,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      SizedBox(width: 20,),
                      Container(
                        width: 220,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            "${Bio}",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.getFont(
                              'Montserrat',
                              color: Colors.black,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                RaisedButton(
                  child: Text(
                    "         Logout         ",
                    style: GoogleFonts.getFont(
                      'Montserrat',
                      color: Color(0xFFF1E6FF),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // side: BorderSide(color: Colors.red)
                  ),
                  color: Color(0xFF6F35A5),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 5),
                  textColor: Colors.white,
                  onPressed: (){
                    _auth.signOut();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20,),
                Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/Assets/Images/design.png"),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topLeft,
                    ),
                  ),
                  child: Container(),
                )
                // Container(
                //   height: 200,
                //   width: 200,
                //   child: Stack(
                //       children:[
                //         Positioned(
                //           child: SvgPicture.asset(
                //             "lib/Assets/Images/Lord_ram.svg",
                //           ),
                //         ),
                //       ]
                //   ),
                // ),
              ],
            ),
          ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
        child: Text(
          "Cancel",
          style: GoogleFonts.getFont('Montserrat',
            color: Colors.white,
            fontWeight:FontWeight.bold,
            fontSize: 22.0,),
        ),
        onPressed:  () {
          Navigator.of(context, rootNavigator: true).pop();
        }
    );
    Widget continueButton = FlatButton(
      child: Text(
        "Set Bio",
        style: GoogleFonts.getFont('Montserrat',
          color: Colors.white,
          fontWeight:FontWeight.bold,
          fontSize: 22.0,),
      ),
      onPressed:  () {
        final FirebaseAuth auth = FirebaseAuth.instance;
        final User user = auth.currentUser;
        var userUid = user.uid;

        FirebaseFirestore.instance.collection('users/${userUid}/user_info').doc("${user_info_id}").update({
          "user_bio": "${Bio_Controller.text}",
        });
        setState(() {
          getNameEmail();
        });

        Bio_Controller.clear();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xFF6F35A5),
      title: Text(
        "Bio",
        style: GoogleFonts.getFont('Montserrat',
          color: Colors.white,
          fontWeight:FontWeight.bold,
          fontSize: 22.0,),
      ),
      content: TextFormField(
        controller: Bio_Controller,
        maxLines: 3,
        style: GoogleFonts.getFont('Montserrat',
          color: Colors.white,
          // fontWeight:FontWeight.bold,
          fontSize: 19.0,),
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        cursorColor: Colors.white,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}