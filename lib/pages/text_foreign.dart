import 'package:flutter/material.dart';


class TextForeign extends StatefulWidget {
  const TextForeign({super.key});

  @override
  State<TextForeign> createState() => _TextForeignState();
}

class _TextForeignState extends State<TextForeign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        centerTitle: true,
        title: const Text(
        'Translato',
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
    'Foreign Language',
    style: TextStyle(
    fontFamily: 'Anton-Regular',
    fontSize: 32.0,
    ),
    ),
    SizedBox(
    height: 20.0,
    ),
    Center(
      child: Text('Text document'),
    )
    ])
      )
    )
    );
  }
}
