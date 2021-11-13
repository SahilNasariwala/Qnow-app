import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discuss/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class addQuestion extends StatefulWidget {
  const addQuestion({Key key}) : super(key: key);

  @override
  _addQuestionState createState() => _addQuestionState();
}

class _addQuestionState extends State<addQuestion> {

  var user_name;
  var userUid;
  final question_Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> getData() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    var userUid = user.uid;

    CollectionReference collection2 = FirebaseFirestore.instance.collection("users/${userUid}/user_info");
    QuerySnapshot querySnapshot2 = await collection2.get();
    setState(() {
      this.user_name = querySnapshot2.docs.map((doc) {return doc.get("user_name");}).toList()[0];
    });
  }

  @override
  void initState(){
    getData();
    super.initState();
    question_Controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    question_Controller.dispose();
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
            'Add Question',
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
            children: [
              build_question(),
              const SizedBox(height: 23),
              RaisedButton(
                child: Text(
                  "add question",
                    style: GoogleFonts.getFont(
                      'Montserrat',
                      color: Color(0xFFF1E6FF),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                ),
                shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(color: Colors.red)
                    ),
                color: Color(0xFF6F35A5),
                padding: EdgeInsets.symmetric(horizontal: 100,vertical: 5),
                textColor: Colors.white,
                onPressed: (){
                    if(_formKey.currentState.validate()){
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final User user = auth.currentUser;
                      userUid = user.uid;
                      CollectionReference collection = FirebaseFirestore.instance.collection("users");
                      Future<void> addItem(
                          String question,
                          ) async {
                        DocumentReference question_reference =
                        collection.doc(userUid).collection('questions').doc();
                        DocumentReference comment_reference =
                        collection.doc(userUid).collection('comments').doc(question_reference.id);
                        DocumentReference createdAt = collection.doc(userUid);

                        Map<String, dynamic> data = <String, dynamic>{
                          "question": "${question}",
                          "Upvote": 0,
                        };
                        Map<String, dynamic> comment = <String, dynamic>{
                          "commentID": 0,
                        };
                        Map<String, dynamic> createdTime = <String, dynamic>{
                          "createdAt": "${userUid}",
                        };

                        await question_reference.set(data);
                        await createdAt.set(createdTime);
                        await comment_reference.set(comment);
                      }
                      addItem("${question_Controller.text}");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(),
                        ),
                      );
                    }
                  }
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Container(
                  height: 250,
                  width: 250,
                  child: Stack(
                      children:[
                        Positioned(
                          child: SvgPicture.asset(
                            "lib/Assets/Images/mind.svg",
                          ),
                        ),
                      ]
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget build_question() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text('${this.user_name} asked : ',
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFF6F35A5),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
      ),
      const SizedBox(height: 8),
      Form(
        key: _formKey,
        child: TextFormField(
          style: GoogleFonts.getFont(
            'Montserrat',
            color: Color(0xFF6F35A5),
            fontSize: 17,
          ),
          validator: (value) {
            if(value.isEmpty) {
              return 'Please enter question';
            }else if(value.length<12){
              return 'Please enter minimum 10 character';
            }else if(value.length>250){
              return 'Word limit extended';
            }
            return null;
          },
          maxLines: 5,
          autofocus: true,
          cursorColor: Color(0xFF6F35A5),
          controller: question_Controller,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Color(0xFF6F35A5),
                width: 2,
              ),
            ),
            errorStyle: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFF6F35A5),
              fontSize: 17,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            hintText: 'Question',
            hintStyle: TextStyle(
                color: Colors.purple[200],
                fontSize: 19,
              fontWeight: FontWeight.bold,),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Icon(Icons.question_answer,color: Color(0xFF6F35A5),),
            ),
            suffixIcon: question_Controller.text.isEmpty
                ? Container(width: 0)
                : Padding(
              padding: const EdgeInsets.only(bottom: 60),
                  child: IconButton(
              color: Color(0xFF6F35A5),
              icon: Icon(Icons.close),
              onPressed: () => question_Controller.clear(),
            ),
                ),
          ),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
        ),
      ),
    ],
  );
}