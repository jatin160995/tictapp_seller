
import 'dart:io';

import 'package:tictapp_seller/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;


class Chat extends StatefulWidget {

  String orderId;

  Chat(this.orderId);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  String meType = "seller";
  final databaseReference = Firestore.instance;
  final Firestore _firestore = Firestore.instance;

  TextEditingController messageController = TextEditingController();

  void getData() {
    databaseReference
        .collection("chats")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }


  bool isLoading =false;
  /*getImage() async
  {
    try
    {
      File file =
      await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 640, maxWidth: 480);
      if (file == null) {
        throw Exception('File is not available');
      }

      uploadFile(file);
    }
    catch(e)
    {
      print(e);
    }

  }*/


  String _uploadedFileURL;
  Future uploadFile(File image) async {
    try
    {
      print("chats/${Path.basename(image.path)}}");
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('chats/${Path.basename(image.path)}}');
      StorageUploadTask uploadTask = storageReference.putFile(image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          createRecord(_uploadedFileURL, "image");
          print(_uploadedFileURL);
        });
      });

    }
    catch(e){
      print(e);
    }

  }

  void createRecord(String text, String type) async {
    /*await databaseReference.collection("chats")
        .document("test@gmail.com").collection('chat')
        .add({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref = await databaseReference.collection("chats")
        .add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);*/
    DocumentReference ref = await databaseReference.collection("seller_chat").document(widget.orderId).collection("messages")
        .add({
      'type': type,
      'message': text,
      'date': DateTime.now().toIso8601String().toString(),
      'name': meType,
    });
    print(ref.documentID);
    messageController.text = "";
  }


  String textToSend = '';
  
  @override
  Widget build(BuildContext context) {
    print(widget.orderId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Order No.: #'+widget.orderId),
      ),
      body: Stack(

        children: <Widget>[

          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 60),
              color: Colors.white,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('seller_chat').document(widget.orderId).collection("messages")
                        ///.where('name', isEqualTo: 'rajesh')
                            .orderBy('date')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          List<DocumentSnapshot> docs = snapshot.data.documents;

                          List<Widget> messages = docs
                              .map((doc) => Message(
                            type: doc.data['type'].toString(),
                            text: doc.data['message'],
                            me: doc.data['name'] == meType,
                          ))
                              .toList();

                          return ListView(
                            //controller: scrollController,
                            children: <Widget>[
                              ...messages,
                            ],
                          );
                        },
                      ),
                    ),

                  ]),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 60,
              child: Row(
                children: <Widget>[
                 /* IconButton(
                    icon: Icon(Icons.image),
                    onPressed: (){
                      getImage();
                    },
                  ),*/
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 10),
                      child: TextField(

                        //onSubmitted: (value) => callback(),
                        decoration: InputDecoration(
                          hintText: "Enter a Message...",
                          border: InputBorder.none,
                        ),
                        controller: messageController,
                      ),
                    ),
                  ),
                  SendButton(
                    text: "Send",
                    callback: ()
                    {
                      if(messageController.text.trim()== "")
                      {
                        return;
                      }
                      createRecord(messageController.text, "text");
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


class SendButton extends StatelessWidget {
  final String text;
  final VoidCallback callback;

  const SendButton({Key key, this.text, this.callback}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 80,
      color: primaryColor,
      child: IconButton(
        color: white,
        onPressed: callback,
        icon: Icon(Icons.send),
      ),
    );
  }



}





class Message extends StatelessWidget {
  final String type;
  final String text;

  final bool me;

  const Message({Key key, this.type, this.text, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment:
        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[

          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            color: me ? type == "image"? transparent :primaryColor   : backgroundGrey,
            //borderRadius: BorderRadius.circular(10.0),
            elevation: 6.0,
            child:type == "image"? Container(
                height: 300,
                width: 300,
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.cover,
                  placeholder: 'assets/images/loading.gif',
                  image: text,
                ),
              ) : Container(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child:  Text(
                text,
                style: TextStyle(
                  color: white
                ),
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}

