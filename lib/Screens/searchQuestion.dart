import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discuss/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'addComment.dart';

class SearchQuestion extends StatefulWidget {
  var userID,questionID;
  SearchQuestion({Key key,this.userID,this.questionID}) : super(key: key);

  @override
  _SearchQuestionState createState() => _SearchQuestionState();
}

var relatedQuestion = [];
var searchedData = {};
class _SearchQuestionState extends State<SearchQuestion> {
  final search_Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    searchDocs(widget.userID,widget.questionID,"________");
    super.initState();
  }

  Future searchDocs(var userID,var questionID, var word) async {
    var temp1,temp2,temp3;
    searchedData.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      CollectionReference collection2 = FirebaseFirestore.instance.collection("users/${a.id}/questions");
      QuerySnapshot querySnapshot2 = await collection2.get();
      CollectionReference collection3 = FirebaseFirestore.instance.collection("users/${a.id}/user_info");
      QuerySnapshot querySnapshot3 = await collection3.get();
      setState(() {
        AllQuestions = querySnapshot3.docs.map((doc) {
          temp1 = "${doc.get("user_name")}";
          return doc.get("user_name");
        }).toList();
        AllQuestions = querySnapshot2.docs.map((doc) {
          temp2 = "${doc.get("question")}";
          temp3 = "${doc.get("Upvote")}";
          if(temp2.toString().toLowerCase().contains(word.toString().toLowerCase())){
            searchedData.addAll(<String, String>{
              "${temp2}": "${temp1}::${temp3}::${a.id}::${doc.id}",
            });
            print(searchedData);
          }
          return doc.get("question");
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    search_Controller.dispose();
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
            'Search Question',
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
        child: Column(
            children: <Widget>[
              build_comment(),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 18,right: 18),
                child: RaisedButton(
                    child: Text(
                      "         Search          ",
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
                    padding: EdgeInsets.symmetric(horizontal: 100,vertical: 5),
                    textColor: Colors.white,
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      searchDocs("${widget.userID}","${widget.questionID}","${search_Controller.text}");
                    }
                  },
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: searchedData.length,
                itemBuilder: (_, index_) {
                  return UserInterface("${searchedData.keys.elementAt(index_)}",
                      "${searchedData.values.elementAt(index_).toString().split("::")[0]}",
                      "${searchedData.values.elementAt(index_).toString().split("::")[1]}",
                      "${searchedData.values.elementAt(index_).toString().split("::")[2]}",
                      "${searchedData.values.elementAt(index_).toString().split("::")[3]}");
                },
              ),
            ]
        ),
      ),
    );
  }
  Widget build_comment() => Padding(
    padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text('Question',
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
              }
              return null;
            },
            maxLines: 5,
            autofocus: true,
            cursorColor: Color(0xFF6F35A5),
            controller: search_Controller,
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
              hintText: 'search question',
              hintStyle: TextStyle(
                color: Colors.purple[200],
                fontSize: 19,
                fontWeight: FontWeight.bold,),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 65),
                child: Icon(Icons.search,color: Color(0xFF6F35A5),),
              ),
              suffixIcon: search_Controller.text.isEmpty
                  ? Container(width: 0)
                  : Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                    child: IconButton(
                color: Color(0xFF6F35A5),
                icon: Icon(Icons.close),
                onPressed: () => search_Controller.clear(),
              ),
                  ),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
          ),
        ),
      ],
    ),
  );
  Widget UserInterface(var Question, var user_name, var Upvote, var userID, var questionID) {
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
                        setState(() {searchDocs("${widget.userID}","${widget.questionID}","${search_Controller.text}");});
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