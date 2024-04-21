
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:translato/global/common/toast.dart';

class CurationFirst extends StatefulWidget {
  const CurationFirst({super.key});

  @override
  State<CurationFirst> createState() => _CurationFirstState();
}

class _CurationFirstState extends State<CurationFirst> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                                  'Input - Type',
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
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/data_curation');
                        },
                        child: Container(
                          height: 55.0,
                          width: 250.0,
                          child: Card(
                              elevation: 8.0,
                              color: Colors.lightBlue[200],
                              child: Center(
                                  child: Text(
                                    'Document',
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
                        height: 15.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/data_curation_link');
                        },
                        child: Container(
                          height: 55.0,
                          width: 250.0,
                          child: Card(
                              elevation: 8.0,
                              color: Colors.lightBlue[200],
                              child: Center(
                                  child: Text(
                                    'Youtube link',
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
                        height: 50.0,
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

