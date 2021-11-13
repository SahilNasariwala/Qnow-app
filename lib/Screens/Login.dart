import 'dart:ui';
import 'package:discuss/Screens/Signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

var showPass=false;
bool wrongNumber = false;
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserEmail_controller = TextEditingController();
  final UserPassword_controller = TextEditingController();

  @override
  void initState(){
    super.initState();
    UserEmail_controller.addListener(() => setState(() {}));
    UserPassword_controller.addListener(() => setState(() {}));
    // final ref = fb.reference().child("hello i");
    // ref.child("R_name").set("111");
  }

  @override
  void dispose() {
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
                            "Login",
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
                            SizedBox(height: 20,),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),
                                  TextFormField(
                                    style: GoogleFonts.getFont(
                                      'Montserrat',
                                      color: Color(0xFF6F35A5),
                                      fontSize: 17,
                                    ),
                                    maxLength: 30,
                                    validator: (value) {
                                      if (UserEmail_controller.text.isNotEmpty) {
                                        if(wrongNumber==true){
                                          return "Wrong Email";
                                        }else{
                                          return null;
                                        }
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
                                            showPass=!showPass;
                                          });
                                        },
                                        child: Icon(
                                        showPass?Icons.remove_red_eye:Icons.visibility_off,
                                        color: Color(0xFF6F35A5),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.text,
                                    obscureText: !showPass,
                                  ),
                                  SizedBox(height: 20,),
                                ],
                              ),
                            ),
                            SizedBox(height: 25,),
                            Container(
                              width: double.infinity,
                              child: RaisedButton(
                                onPressed: () {
                                  // final fb = FirebaseDatabase.instance;
                                  // final ref = fb.reference().child("app");
                                  // ref.child("C_name").set("abcd");
                                  Future signInWithEmailAndPassword(String email, String password) async {
                                    try {
                                      UserCredential result = await _auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                      final SharedPreferences sharedpreferences=await SharedPreferences.getInstance();
                                      sharedpreferences.setString('Email', UserEmail_controller.text);
                                      Navigator.of(context).pushReplacementNamed("/HomePage");
                                    } catch (e) {
                                      print(e.toString());
                                      return null;
                                    }
                                  }
                                  signInWithEmailAndPassword(UserEmail_controller.text,UserPassword_controller.text);
                                },
                                color: Color(0xFF6F35A5),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color: Colors.white,
                                      fontSize: 19,
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
                                      "Don't have an account?",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14
                                      ),
                                    ),
                                    SizedBox(width: 7,),
                                    GestureDetector(
                                      onTap: (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SignUpPage1(
                                            ), // navigate to 12 page
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Sign up",
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