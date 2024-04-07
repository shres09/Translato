
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:translato/global/common/toast.dart';

class DataCuration extends StatefulWidget {
  const DataCuration({super.key});

  @override
  State<DataCuration> createState() => _DataCurationState();
}

class _DataCurationState extends State<DataCuration> {

  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> pdfs = [];
  String name = "output file - none";
  String? outputUrl = null;

  Future<String> uploadPdf(String fileName, io.File file) async{
    final reference = FirebaseStorage.instance.ref().child("Uploaded_documents/$fileName.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {} );
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if(pickedFile != null){
      String fileName = pickedFile.files[0].name;
      io.File file = io.File(pickedFile.files[0].path!);
      final downloadLink = await uploadPdf(fileName, file);
      User user = auth.currentUser!;
      await store.collection("User_Documents").doc(user.email.toString()).collection("Data_Curation").add({
        "name": fileName,
        "input": downloadLink,
        "output": ""
      });
    }
  }

  void getPdf() async {
    final result = await store.collection("User_Documents").doc(auth.currentUser!.email).collection("Data_Curation").get();
    pdfs = result.docs.map((e) => e.data()).toList();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPdf();
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
          'Data Curation',
          style: TextStyle(
          fontFamily: 'Anton-Regular',
          fontSize: 32.0,
        ),
      ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 50.0,
            width: 380.0,
            child: Card(
              color: Colors.lightBlue[100],
              child: Center(
                child: Text(
                'Input',
                style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Poppins-Medium',
                  color: Colors.black
              ),
              )
                )

                ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Upload document here',
            style: TextStyle(
              fontFamily: 'Poppins-Medium',
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                color: Colors.grey[300],
                height: 50.0,
                width: 150.0,
                child: Center(
                  child: Text(
                    'None',
                    style: TextStyle(
                      fontFamily: 'Poppins-Medium',
                      fontSize: 15.0
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.0,
              ),
              GestureDetector(
                onTap: (){
                  pickFile();
                },
                child: Container(
                  height: 55.0,
                  width: 120.0,
                  child: Card(
                    elevation: 8.0,
                      color: Colors.lightBlue[200],
                      child: Center(
                          child: Text(
                            'Upload',
                            style: TextStyle(
                                fontSize: 15.0,
                                fontFamily: 'Poppins-Medium',
                                color: Colors.white
                            ),
                          )
                      )

                  ),
                ),
              )
            ],
          ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              onTap: (){},
              child: Container(
                height: 55.0,
                width: 250.0,
                child: Card(
                    elevation: 8.0,
                    color: Colors.lightBlue[200],
                    child: Center(
                        child: Text(
                          'Curate data',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.white
                          ),
                        )
                    )

                ),
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              height: 50.0,
              width: 380.0,
              child: Card(
                  color: Colors.lightBlue[100],
                  child: Center(
                      child: Text(
                        'Output',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Poppins-Medium',
                            color: Colors.black
                        ),
                      )
                  )

              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Output after data curation: ',
              style: TextStyle(
                fontFamily: 'Poppins-Medium',
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                if(outputUrl==null){
                  showToast(message: "No output file was generated!");
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
                          name,
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
          ]

    )
      )
    )
    );
  }
}

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {

  PDFDocument? document;
  
  void initialisePdf() async {
    document = await PDFDocument.fromURL(widget.pdfUrl);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialisePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: document!=null? PDFViewer(document: document!,): Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

