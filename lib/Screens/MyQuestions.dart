import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discuss/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'addComment.dart';

class MyQuestions extends StatefulWidget {
  var userID;
  MyQuestions({Key key,this.userID}) : super(key: key);

  @override
  _MyQuestionsState createState() => _MyQuestionsState();
}

var MyQuestion = {};
class _MyQuestionsState extends State<MyQuestions> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    getDocs();
    super.initState();
  }

  Future getDocs() async {
    MyQuestion.clear();
    // CollectionReference collection2 = FirebaseFirestore.instance.collection("users/${userID}/questions");
    // QuerySnapshot querySnapshot2 = await collection2.get();
    // MyQuestion = querySnapshot2.docs.map((doc) {
    //   return doc.get("question");
    // }).toList();
    // setState(() {});
      CollectionReference collection2 = FirebaseFirestore.instance.collection("users/${widget.userID}/questions");
      QuerySnapshot querySnapshot2 = await collection2.get();
      setState(() {
        querySnapshot2.docs.map((doc) {
          var temp2 = "${doc.get("question")}";
          var temp3 = "${doc.get("Upvote")}";
          MyQuestion.addAll(<String, String>{
            "${temp2}": "${temp3}::${widget.userID}::${doc.id}",
          });
          // return doc.get("question");
        }).toList();
      });
  }

  @override
  void dispose() {
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
            'My Questions',
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
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.delayed(Duration(milliseconds: 500));
            setState(() {
              getDocs();
            });
          },
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: MyQuestion.length,
            itemBuilder: (_, index_) {
              return UserInterface(
                  "${MyQuestion.keys.elementAt(index_)}",
                  "${MyQuestion.values.elementAt(index_).toString().split("::")[0]}",
                  "${MyQuestion.values.elementAt(index_).toString().split("::")[1]}",
                  "${MyQuestion.values.elementAt(index_).toString().split("::")[2]}",);
            },
          ),
        ),
      ),
    );
  }
  Widget UserInterface(var Question, var Upvote, var userID, var questionID) {
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
                        setState(() {getDocs();});
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
