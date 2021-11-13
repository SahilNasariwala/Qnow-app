import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discuss/model/user.dart';

var user_info_id;
var SignUpshowPass=false;
class SignUpPage1 extends StatefulWidget {

  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}
bool signUpbtn=true;
class _SignUpPage1State extends State<SignUpPage1> {
  final UserName_controller = TextEditingController();
  final OTP_controller = TextEditingController();
  final UserEmail_controller = TextEditingController();
  final UserPassword_controller = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    UserName_controller.addListener(() => setState(() {}));
    OTP_controller.addListener(() => setState(() {}));
    UserEmail_controller.addListener(() => setState(() {}));
    UserPassword_controller.addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    UserName_controller.dispose();
    UserName_controller.dispose();
    OTP_controller.dispose();
    UserEmail_controller.dispose();
    UserPassword_controller.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height,
              maxWidth: MediaQuery.of(context).size.width,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFF6F35A5),
                Color(0xFFF1E6FF),
              ],
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 36,horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 46,
                                fontWeight: FontWeight.w800
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "Welcome to QnA",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w400
                            ),
                          ),
                        ],
                      ),
                    )
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30,),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       child: Text(
                            //         "Choose Your Role : ",
                            //         style: TextStyle(
                            //           // color: Color(0xFFe7eded),
                            //           fontSize: 17,
                            //           // fontWeight: FontWeight.bold,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(width: 10,),
                            //     Padding(
                            //       padding: const EdgeInsets.only(right: 10),
                            //       child: Container(
                            //         child: DropdownButton<String>(
                            //           hint: Container(
                            //             child: Text("Select Role"),
                            //           ),
                            //           // dropdownColor: Color(0xFFe7eded),
                            //           value: dropdownValue,
                            //           icon: const Icon(Icons.arrow_downward),
                            //           iconSize: 22,
                            //           elevation: 16,
                            //           style: const TextStyle(
                            //               fontSize: 15,
                            //               color: Colors.black
                            //           ),
                            //           underline: Container(
                            //             height: 1,
                            //             color: Colors.black,
                            //           ),
                            //           onChanged: (String newValue) {
                            //             setState(() {
                            //               setState(() {
                            //                 dropdownValue = newValue;
                            //                 // var temp;
                            //                 // if(dropdownValue=='1 month'){temp=1;}
                            //                 // else if(dropdownValue=='3 month'){temp=2.75;}
                            //                 // else if(dropdownValue=='6 month'){temp=5;}
                            //                 // else {temp=9;}
                            //               });
                            //             });
                            //           },
                            //           items: <String>['Student', 'Parent', 'Councellor', 'Manager']
                            //               .map<DropdownMenuItem<String>>((String value) {
                            //             return DropdownMenuItem<String>(
                            //               value: value,
                            //               child: Text(value),
                            //             );
                            //           }).toList(),
                            //         ),
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    style: GoogleFonts.getFont(
                                      'Montserrat',
                                      color: Color(0xFF6F35A5),
                                      fontSize: 17,
                                    ),
                                    maxLength: 20,
                                    validator: (value) {
                                      if (UserName_controller.text.isEmpty) {
                                        return 'Enter valid username';
                                      }
                                      return null;
                                    },
                                    controller: UserName_controller,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFe7eded),
                                        hintText: "Name",
                                        hintStyle: TextStyle(
                                          color: Colors.purple[200],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.perm_identity,
                                          color: Color(0xFF6F35A5),
                                        )
                                    ),
                                    keyboardType: TextInputType.text,
                                  ),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    style: GoogleFonts.getFont(
                                      'Montserrat',
                                      color: Color(0xFF6F35A5),
                                      fontSize: 17,
                                    ),
                                    maxLength: 30,
                                    validator: (value) {
                                      if (UserEmail_controller.text.isNotEmpty) {
                                        return null;
                                      }
                                      return 'Enter valid Email';
                                    },
                                    controller: UserEmail_controller,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFe7eded),
                                        hintText: "Email",
                                        hintStyle: TextStyle(
                                          color: Colors.purple[200],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Color(0xFF6F35A5),
                                        )
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  SizedBox(width: 10,),
                                  SizedBox(height: 10,),
                                  TextFormField(
                                    style: GoogleFonts.getFont(
                                      'Montserrat',
                                      color: Color(0xFF6F35A5),
                                      fontSize: 17,
                                    ),
                                    validator: (value) {
                                      if (UserPassword_controller.text.isEmpty) {
                                        return 'Enter valid Password';
                                      }
                                      return null;
                                    },
                                    controller: UserPassword_controller,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            borderSide: BorderSide.none
                                        ),
                                        filled: true,
                                        fillColor: Color(0xFFe7eded),
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                          color: Colors.purple[200],
                                        ),
                                        prefixIcon: Icon(
                                          Icons.password,
                                          color: Color(0xFF6F35A5),
                                        ),
                                      suffix: GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            SignUpshowPass=!SignUpshowPass;
                                          });
                                        },
                                        child: Icon(
                                          SignUpshowPass?Icons.remove_red_eye:Icons.visibility_off,
                                          color: Color(0xFF6F35A5),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    obscureText: !SignUpshowPass,
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                disabledColor: Colors.blue[200],
                                onPressed: signUpbtn?() async{
                                  Future signUpWithEmailAndPassword(String email, String password) async {
                                    try {
                                      UserCredential result = await _auth.createUserWithEmailAndPassword(
                                          email: email, password: password);
                                      CollectionReference collection = FirebaseFirestore.instance.collection("users");
                                      Future<void> addItem(
                                          String UserName,
                                          String UserEmail,
                                          ) async {
                                        DocumentReference question_reference =
                                        collection.doc(result.user.uid).collection('user_info').doc();

                                        Map<String, dynamic> data = <String, dynamic>{
                                          "user_name": UserName,
                                          "user_email": UserEmail,
                                          "user_bio": "Click to add Bio...",
                                        };

                                        await question_reference.set(data) // Map<String,dynamic> demo = {"Questions":"${question_Controller.text}"};
                                        // CollectionReference collection = FirebaseFirestore.instance.collection("data");
                                        // collection.add(demo);
                                            .whenComplete(() => print("Notes item added to the database"))
                                            .catchError((e) => print(e));
                                        user_info_id = question_reference.id;
                                      }
                                      addItem("${UserName_controller.text}","${UserEmail_controller.text}");
                                      final SharedPreferences sharedpreferences=await SharedPreferences.getInstance();
                                      sharedpreferences.setString('Email', UserEmail_controller.text);
                                      Navigator.of(context).pushReplacementNamed("/HomePage");
                                    } catch (e) {
                                      print(e.toString());
                                      return null;
                                    }
                                  }
                                  signUpWithEmailAndPassword(UserEmail_controller.text,UserPassword_controller.text);

                                }:null,
                                color: Color(0xFF6F35A5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                shape: StadiumBorder(),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Already have an account?",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(width: 7,),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.of(context).pushReplacementNamed("/login");                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFF6F35A5),
                                          decoration: TextDecoration.underline,
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
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}