
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
  bool isSuccess = false;
  var inputFile ;
  String fileName = "None";
  var outputFile ;
  var downloadLink;
  var docID;
  Uri api = Uri.parse("https://893c-35-247-136-96.ngrok-free.app/curate/document/");


  Future<String> uploadPdf(String fileName, io.File file) async{
    String? user = auth.currentUser!.email;
    final reference = FirebaseStorage.instance.ref().child("$user/Data_Curation/Uploaded_documents/$file.pdf");
    final uploadTask = reference.putFile(file);
    await uploadTask.whenComplete(() {} );
    final downloadLink = await reference.getDownloadURL();
    return downloadLink;
  }

  void pickFile() async {
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['docx'],
    );
    if(pickedFile != null) {
      fileName = pickedFile.files[0].name;
      inputFile = io.File(pickedFile.files[0].path!);
      downloadLink = await uploadPdf(fileName, inputFile);
    }
    setState(() {});
  }

  void curateDocument() async {
    setState(() {
      isSuccess = true;
    });
    showToast(message: "Curating document!");
    var request = http.MultipartRequest("POST", api);
    request.files.add(await http.MultipartFile.fromPath(
      'file', // This is the key for the file parameter in your API
      inputFile.path,
      contentType: MediaType('application', 'octet-stream'), // You may need to adjust the content type based on your API requirements
    ));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode == 200){
      String? user = auth.currentUser?.email; // Access user information (adjust if needed)
      //String contentType = response.headers['Content-Type'] ?? 'application/octet-stream'; // Get file type from header

      var file = fileName.split(".docx")[0];
      Reference ref = FirebaseStorage.instance.ref().child("$user/Data_Curation/Output_documents/$file.pdf");

      UploadTask uploadTask = ref.putData(response.bodyBytes);

      // Handle completion and errors
      await uploadTask.whenComplete(() => print('File uploaded to Firebase Storage'));
      final outputLink = await ref.getDownloadURL();


      uploadTask.snapshotEvents.listen((event) {
        // Handle progress events
        print(event.bytesTransferred / event.totalBytes);
      });
      DocumentReference docRef = await store.collection("User_Documents").doc(user.toString()).collection("Foreign_Translation").add({
        "input": downloadLink,
        "output": outputLink
      });
      setState(() {
        isSuccess = false;
      });
      docID = docRef.id;
      outputUrl = outputLink;
      name = fileName;
      setState(() {});
      showToast(message: "Data curation successfull!");
    }else{
      setState(() {
        isSuccess = false;
      });
      showToast(message: response.statusCode.toString());
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
                    fileName,
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
              onTap: (){
                if(inputFile == null){
                  showToast(message: "Upload a document!");
                }else{
                  curateDocument();
                }
              },
              child: Container(
                height: 55.0,
                width: 250.0,
                child: Card(
                    elevation: 8.0,
                    color: Colors.lightBlue[200],
                    child: Center(
                        child: isSuccess ? CircularProgressIndicator(
                          color: Colors.white,) : Text(
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

