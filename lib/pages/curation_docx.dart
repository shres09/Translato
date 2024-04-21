import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:document_viewer/document_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translato/global/common/toast.dart';
import 'package:translato/pages/data_curation.dart';
import 'package:translato/pages/text_indian.dart';
import 'package:permission_handler/permission_handler.dart';



class CurationDocx extends StatefulWidget {
  final String data;
  final String name;

  const CurationDocx({Key? key, required this.data, required this.name})
      : super(key: key);

  @override
  State<CurationDocx> createState() => _CurationDocxState();
}

class _CurationDocxState extends State<CurationDocx> {
  String outputUrl = "";
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;
  String? downloadedFilePath;

  @override
  void initState() {
    super.initState();
    getDoc(); // Fetch data immediately upon widget initialization
  }

  Future<bool> requestStoragePermission() async {
    final storageStatus = await Permission.storage.request();
    return storageStatus == PermissionStatus.granted;
  }


  Future<void> downloadFileFromStorage(String storagePath, String fileName) async {
    try {
      // Get the reference to the file in Firebase Storage
      Reference ref = FirebaseStorage.instance.ref().child(storagePath);

      // Get the temporary directory on the device
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      // Download the file to the device
      File downloadToFile = File(filePath);
      await ref.writeToFile(downloadToFile);

      print('File downloaded to: $filePath');
    } catch (error) {
      print('Error downloading file: $error');
    }
  }



  void getDoc() async {
    // Handle potential null arguments using null-safe operators
    final data = widget.data;
    final name = widget.name;

    if (data == null || name == null) {
      // Handle the case where arguments are missing (e.g., show error message)
      print('Error: Missing arguments in TextIndian');
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
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        'Curated Document - Docx',
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
                              onTap: () async {
                                showToast(message: "Downloading Document");
                                await downloadFileFromStorage(outputUrl, fileName);
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
                              'Click to view the document',
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
