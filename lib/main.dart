import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Screens/Login.dart';
import 'Screens/MyQuestions.dart';
import 'Screens/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Screens/addComment.dart';
import 'Screens/addQuestion.dart';
import 'Screens/searchQuestion.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_button/animated_button.dart';
import 'package:like_button/like_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discuss.ly',
      debugShowCheckedModeBanner: false,
      routes: {
        "/login": (ctx) => LoginScreen(),
        "/HomePage": (ctx) => MyHomePage(),
      },
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: starting(),
    );
  }
}

var finalPhone;

class starting extends StatefulWidget {
  @override
  _startingState createState() => _startingState();
}

CollectionReference collection = FirebaseFirestore.instance.collection("users");

class _startingState extends State<starting> {
  void initState() {
    getDocs();
    getValidation().whenComplete(() async {
      new Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context)
            .pushReplacementNamed(finalPhone == null ? "/login" : "/HomePage");
      });
    });
    super.initState();
  }

  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      CollectionReference collection2 =
          FirebaseFirestore.instance.collection("users/${a.id}/questions");
      QuerySnapshot querySnapshot2 = await collection2.get();
      final allData2 = querySnapshot2.docs.map((doc) {
        return doc.get("question");
      }).toList();
      // print(allData2);
    }
  }

  Future getValidation() async {
    final SharedPreferences sharedpreferences =
        await SharedPreferences.getInstance();
    var obtainedPhone = sharedpreferences.getString('Email');
    setState(() {
      finalPhone = obtainedPhone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Container(
                    height: 350,
                    width: 400,
                    child: Stack(
                        children:[
                          Positioned(
                            child: SvgPicture.asset(
                              "lib/Assets/Images/splash.svg",
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 150,bottom: 20),
                  child: SpinKitWave(
                    color: Color.fromRGBO(156, 100, 228, 2),
                    size: 35.0,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: new Text(
                    'Loading...',
                    style: GoogleFonts.getFont(
                      'Montserrat',
                      color: Color.fromRGBO(156, 100, 228, 2),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List AllQuestions = [];
List AllUsers = [];
List finalQuestions = [];
List finalUsername = [];
var allData = {};
var querySnapshot2;
var querySnapshot3;

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  var temp1, temp2, temp3, temp4;
  Map<String, dynamic> data;
  var dataList = [];

  Future getDocs() async {
    finalQuestions.clear();
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      CollectionReference collection2 =
      FirebaseFirestore.instance.collection("users/${a.id}/questions");
      QuerySnapshot querySnapshot2 = await collection2.get();
      CollectionReference collection3 =
      FirebaseFirestore.instance.collection("users/${a.id}/user_info");
      QuerySnapshot querySnapshot3 = await collection3.get();
      setState(() {
        AllQuestions = querySnapshot3.docs.map((doc) {
          temp1 = "${doc.get("user_name")}";
          return doc.get("user_name");
        }).toList();
        AllQuestions = querySnapshot2.docs.map((doc) {
          temp2 = "${doc.get("question")}";
          temp3 = "${doc.get("Upvote")}";
          allData.addAll(<String, String>{
            "${temp2}": "${temp1}::${temp3}::${a.id}::${doc.id}",
          });
          return doc.get("question");
        }).toList();
        finalQuestions = finalQuestions + AllQuestions;
      });
    }
    setState(() {});
  }

  AnimationController _controller;
  bool isPlaying = false;

  @override
  void initState() {
    getDocs();
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
            'Qnow',
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
      body: Center(
        child: allData.keys.length == 0
            ? new Text('No Data is Available',
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFF6F35A5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ))
            : RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 500));
            setState(() {
              getDocs();
            });
          },
          child: new ListView.builder(
            itemCount: allData.keys.length,
            itemBuilder: (_, index_) {
              return UserInterface(
                  "${allData.keys.elementAt(index_)}",
                  "${allData.values.elementAt(index_).toString().split(
                      "::")[0]}",
                  "${allData.values.elementAt(index_).toString().split(
                      "::")[1]}",
                  "${allData.values.elementAt(index_).toString().split(
                      "::")[2]}",
                  "${allData.values.elementAt(index_).toString().split(
                      "::")[3]}");
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 17, left: 17, right: 17),
        child: BottomAppBar(
          color: Color(0xFF6F35A5),
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
          ),
          child: Row(
            children: [
              Spacer(),
              IconButton(
                  icon: Icon(Icons.home),
                  color: Color(0xFFF1E6FF),
                  onPressed: () {
                    setState(() {
                      getDocs();
                    });
                  }),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.category),
                  color: Color(0xFFF1E6FF),
                  onPressed: () {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final User user = auth.currentUser;
                    var userUid = user.uid;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyQuestions(userID: userUid),
                      ),
                    );
                  }),
              Spacer(),
              Spacer(),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.search),
                  color: Color(0xFFF1E6FF),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchQuestion(),
                      ),
                    );
                  }),
              Spacer(),
              IconButton(
                  icon: Icon(Icons.account_circle),
                  color: Color(0xFFF1E6FF),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  }),
              Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 10,
          shape: CircleBorder(side: BorderSide(color: Color(0xFF6F35A5), width: 2.0)),
          backgroundColor: Color(0xFFF1E6FF),
          child: Icon(
            Icons.add,
            color: Color(0xFF6F35A5),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => addQuestion()),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget UserInterface(var Question, var user_name, var Upvote, var userID,
      var questionID) {
    return new Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(23),
        ),
      ),
      color: Color(0xFFF1E6FF),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 2, right: 15, left: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Color(0xFF6F35A5), width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 32,
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20, top: 5, bottom: 5, right: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "${user_name}",
                          style: GoogleFonts.getFont(
                            'Montserrat',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(right: 20),
                //   child: Divider(color: Color(0xFF6F35A5),thickness: 2,),
                // ),
                SizedBox(height: 5,),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 5, bottom: 5, right: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "${Question}",
                      style: GoogleFonts.getFont(
                        'Montserrat',
                        fontSize: 22,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            Divider(color: Color(0xFF6F35A5),indent: 20,endIndent: 20,thickness: 2,),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: GestureDetector(
                      onTap: () {
                        FirebaseFirestore.instance
                            .collection('users/${userID}/questions')
                            .doc(questionID)
                            .update({
                          "Upvote": int.parse(Upvote) + 1,
                        });
                        setState(() {
                          getDocs();
                        });
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 30, right: 17),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Icon(
                                Icons.star,
                                size: 30,
                                color: Color(0xFF6F35A5)
                              ),
                            ),
                          ),
                          Text("${Upvote}",
                            style: GoogleFonts.getFont(
                            'Montserrat',
                            color: Color(0xFF6F35A5),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                    ),
                  ),
                ),
                // Divider(color: Color(0xFF6F35A5),),
                Padding(
                  padding: const EdgeInsets.only(right: 45),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              addComment(
                                  userID: "${userID}", questionID: "$questionID",question: Question,),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, right: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Icon(
                              Icons.question_answer,
                              size: 30,
                              color: Color(0xFF6F35A5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      margin: EdgeInsets.fromLTRB(20, 12, 20, 5),
      elevation: 4,
      shadowColor: Color(0xFF6F35A5),
    );
  }
}
