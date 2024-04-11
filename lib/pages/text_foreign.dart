import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:document_viewer/document_viewer.dart';
import 'package:translato/global/common/toast.dart';
import 'package:translato/pages/data_curation.dart';

class TextForeign extends StatefulWidget {
  final String data;
  final String name;

  const TextForeign({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  State<TextForeign> createState() => _TextForeignState();
}

class _TextForeignState extends State<TextForeign> {
  String outputUrl = "";
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;

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
          .collection("Foreign_Translation")
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
      child: Column(
        children: [
           GestureDetector(
              onTap: () {
                getDoc();
                if(outputUrl==""){
                  showToast(message: "Error playing audio!");
                }else{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfUrl: outputUrl!)));
                }
              },
              child: Container(
                width: 120.0,
                child: Card(
                  elevation: 8.0,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Image(
                        image: AssetImage('assets/pdf.png'),
                        width: 100.0,
                        height: 100.0,),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        fileName,
                        style: TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontSize: 13.0
                        ),),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                'Click to view the pdf',
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
