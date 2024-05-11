import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:translato/global/common/toast.dart';

class VideoIndian extends StatefulWidget {
  final String data;
  final String name;

  const VideoIndian({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  State<VideoIndian> createState() => _VideoIndianState();
}

class _VideoIndianState extends State<VideoIndian> {
  String outputUrl = "";
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    getDoc();
  }

  void getDoc() async {
    final data = widget.data;
    final name = widget.name;

    if (data == null || name == null) {
      print('Error: Missing arguments in CurationMp4');
      return;
    }

    try {
      final docRef = FirebaseFirestore.instance
          .collection("User_Documents")
          .doc(auth.currentUser!.email)
          .collection("Indian_Translation")
          .doc(data);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        outputUrl = docSnapshot.get('output');
        fileName = name;
        _controller = VideoPlayerController.network(outputUrl);
        _initializeVideoPlayerFuture = _controller.initialize();
        _controller.setLooping(true);
        setState(() {});
      } else {
        print('Error: Document not found');
      }
    } on FirebaseException catch (e) {
      print('Error fetching document: $e');
    }
  }

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
          ),
        ),
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
