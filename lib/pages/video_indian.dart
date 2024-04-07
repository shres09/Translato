import 'package:flutter/material.dart';

class VideoIndian extends StatefulWidget {
  const VideoIndian({super.key});

  @override
  State<VideoIndian> createState() => _VideoIndianState();
}

class _VideoIndianState extends State<VideoIndian> {
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
                        'Indian Language',
                        style: TextStyle(
                          fontFamily: 'Anton-Regular',
                          fontSize: 32.0,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text('Avatar Video'),
                      )
                    ])
            )
        )
    );
  }
}
