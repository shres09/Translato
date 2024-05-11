import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translato/global/common/toast.dart';

class AudioIndian extends StatefulWidget {

  final String data;
  final String name;
  const AudioIndian({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  State<AudioIndian> createState() => _AudioIndianState();
}

class _AudioIndianState extends State<AudioIndian> {
  String outputUrl = "";
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    getDoc(); // Fetch data immediately upon widget initialization
  }

  void getDoc() async {
    // Handle potential null arguments using null-safe operators
    final data = widget.data;
    final name = widget.name;

    if (data == null || name == null) {
      // Handle the case where arguments are missing (e.g., show error message)
      print('Error: Missing arguments in TextForeign');
      return;
    }

    try {
      final docRef = store.collection("User_Documents")
          .doc(auth.currentUser!.email)
          .collection("Indian_Translation_Audio")
          .doc(data);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        outputUrl = docSnapshot.get('output');
        fileName = name;
        setState(() {});
      } else {
        print('Error: Document not found');
      }
    } on FirebaseException catch (e) {
      print('Error fetching document: $e');
    }
  }

  final FirebaseFirestore store = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue[200],
          centerTitle: true,
          title: const Text(
            'VIVEKA',
            style: TextStyle(
              letterSpacing: 2.0,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Anton-Regular',
            ),),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Translated Audio',
                        style: TextStyle(
                          fontFamily: 'Anton-Regular',
                          fontSize: 32.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100.0,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          getDoc();
                                          if(outputUrl==""){
                                            showToast(message: "Error playing audio!");
                                          }else{
                                            await player.play(UrlSource(outputUrl));
                                          }
                                        },
                                        child: Text(
                                            "play"
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Center(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          await player.pause();
                                        },
                                        child: Text(
                                            "pause"
                                        )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              fileName,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'Poppins-Medium'
                              ),
                            ),
                            SizedBox(
                              height: 40.0,
                            )
                          ],
                        ),
                      )
                    ])
            )
        )
    );
  }
}


