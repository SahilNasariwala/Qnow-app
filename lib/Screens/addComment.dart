import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discuss/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class addComment extends StatefulWidget {
  var userID, questionID,question;
  addComment({Key key, this.userID, this.questionID, this.question}) : super(key: key);

  @override
  _addCommentState createState() => _addCommentState();
}

var comments = {};

class _addCommentState extends State<addComment> {
  final comment_Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    getDocs("${widget.userID}", "${widget.questionID}");
    super.initState();
  }

  var commentID;
  var comment_id;
  Future getDocs(var userID, var questionID) async {
    comments.clear();
    CollectionReference collection2 =
    FirebaseFirestore.instance.collection("users/${userID}/comments");
    QuerySnapshot querySnapshot2 = await collection2.get();
    for (int i = 0; i < querySnapshot2.docs.length; i++) {
      var x = querySnapshot2.docs.map((doc) {
        if (doc.id == questionID) {
          commentID = doc.get("commentID");
          return doc.get("commentID");
        }
        return doc.get("commentID");
      }).toList()[0];
    }
    for (int i = 1; i <= commentID; i++) {
      var collection2 = await FirebaseFirestore.instance
          .collection("users/${userID}/comments")
          .doc("${questionID}")
          .get();
      CollectionReference collection3 = FirebaseFirestore.instance.collection("users/${collection2.get("username_${i}")}/user_info");
      QuerySnapshot querySnapshot2 = await collection3.get();
      var username = querySnapshot2.docs.map((doc) {
        return doc.get("user_name");
      }).toList()[0];
      comments.addAll(<String, String>{
        "${collection2.get("comment_${i}")}": "${username}",
      });
      // comments.add(collection2.get("comment_${i}"));
      setState(() {});
    }
  }

  @override
  void dispose() {
    comment_Controller.dispose();
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
            'Comments',
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back_rounded)),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          build_comment(),
          SizedBox(
            height: 20,
          ),
          RaisedButton(
            child: Text(
              "add comment",
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
            onPressed: () async {
              CollectionReference collection2 = FirebaseFirestore.instance
                  .collection("users/${widget.userID}/comments");
              QuerySnapshot querySnapshot2 = await collection2.get();
              for (int i = 0; i < querySnapshot2.docs.length; i++) {
                var x = querySnapshot2.docs.map((doc) {
                  if (doc.id == widget.questionID) {
                    comment_id = doc.get("commentID");
                    return doc.get("commentID");
                  }
                  return doc.get("commentID");
                }).toList()[0];
              }
              final FirebaseAuth auth = FirebaseAuth.instance;
              final User user = auth.currentUser;
              var userUid = user.uid;
              FirebaseFirestore.instance
                  .collection('users/${widget.userID}/comments')
                  .doc(widget.questionID)
                  .update({
                "comment_${comment_id + 1}": "${comment_Controller.text}",
                "commentID": comment_id + 1,
                "username_${comment_id + 1}": "${userUid}",
              });
              comment_Controller.clear();

              setState(() {
                getDocs("${widget.userID}", "${widget.questionID}");
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Color(0xFF6F35A5),
            thickness: 2,
            indent: 19,
            endIndent: 19,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(Duration(milliseconds: 500));
                setState(() {
                  getDocs("${widget.userID}", "${widget.questionID}");
                });
              },
              child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: comments.length,
                itemBuilder: (_, index_) {
              return UserInterface(
              "${comments.keys.elementAt(index_)}",
              "${comments.values.elementAt(index_)}",
              );
              },
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget build_comment() => Padding(
    padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5,left: 15),
          child: Text('${widget.question}',
              style: GoogleFonts.getFont(
                'Montserrat',
                color: Color(0xFF6F35A5),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              )),
        ),
        const SizedBox(height: 17),
        Form(
          key: _formKey,
          child: TextFormField(
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFF6F35A5),
              fontSize: 17,
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter question';
              }
              return null;
            },
            maxLines: 4,
            autofocus: true,
            cursorColor: Color(0xFF6F35A5),
            controller: comment_Controller,
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
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              hintText: 'add comment',
              hintStyle: TextStyle(
                color: Colors.purple[200],
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 45),
                  child: Icon(
                    Icons.comment,
                    color: Color(0xFF6F35A5),
                  )),
              suffixIcon: comment_Controller.text.isEmpty
                  ? Container(width: 0)
                  : Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: IconButton(
                  color: Color(0xFF6F35A5),
                  icon: Icon(Icons.close),
                  onPressed: () => comment_Controller.clear(),
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
}

Widget UserInterface(var comment,var userName) {
  return new Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    color: Color(0xFF6F35A5),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Column(
        children: <Widget>[
          Text(
            "${userName}",
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Color(0xFFF1E6FF),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Divider(
              color: Color(0xFFF1E6FF),
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Text(
              "${comment}",
              style: GoogleFonts.getFont(
                'Montserrat',
                color: Color(0xFFF1E6FF),
                fontSize: 19,
              ),
            ),
          )
        ],
      ),
    ),
    margin: EdgeInsets.fromLTRB(15, 12, 15, 0),
    elevation: 2,
    shadowColor: Colors.black,
  );
}