import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:translato/global/common/toast.dart';

class CurationMp4 extends StatefulWidget {

  final String data;
  final String name;
  const CurationMp4({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  State<CurationMp4> createState() => _CurationMp4State();
}

class _CurationMp4State extends State<CurationMp4> {
  String outputUrl = "";
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;
  final player = AudioPlayer();
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    getDoc(); // Fetch data immediately upon widget initialization
    _controller = VideoPlayerController.network(
      outputUrl
    );
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
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
          .collection("Data_Curation")
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
        body: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}