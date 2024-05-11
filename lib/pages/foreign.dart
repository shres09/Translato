import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io' as io;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:translato/global/common/toast.dart';
import 'package:translato/pages/audio_foreign.dart';
import 'package:translato/pages/feedback_page.dart';
import 'package:translato/pages/text_foreign.dart';
import 'package:translato/pages/video_foreign.dart';

class Foreign extends StatefulWidget {
  const Foreign({super.key});

  @override
  State<Foreign> createState() => _ForeignState();
}


class _ForeignState extends State<Foreign> {

  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> pdfs = [];
  String name = "output file - none";
  String lang = "fr";
  var fileName;
  bool isSuccess = false;
  String? outputUrl = null;
  final List<String> languages = ['French', 'German', 'Portugese', 'Italian', 'Spanish', 'Dutch'];
  String selectedItem = "French";
  var inputFile ;
  var outputFile ;
  var downloadLink;
  var docID;
  Uri api = Uri.parse("https://90ee-2401-4900-1cba-914b-95c4-8f23-b01b-8951.ngrok-free.app/translate/document/");
  Uri audio_api = Uri.parse("https://6fc7-35-197-140-189.ngrok-free.app/audio");
  Uri video_api = Uri.parse("https://6fc7-35-197-140-189.ngrok-free.app/video");

  Future<String> uploadPdf(String fileName, io.File file) async{
    String? user = auth.currentUser!.email;
    final reference = FirebaseStorage.instance.ref().child("$user/Foreign_Translation/Uploaded_documents/$fileName.pdf");
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

  void getPdf() async {
    final result = await store.collection("User_Documents").doc(auth.currentUser!.email).collection("Data_Curation").get();
    pdfs = result.docs.map((e) => e.data()).toList();
    setState(() {});
  }

  String setLanguage(String? item){
    switch(item){
      case "French":
        lang = "fr";
        break;
      case "German":
        lang = "de";
        break;
      case "Spanish":
        lang = "es";
        break;
      case "Portugese":
        lang = "pt";
        break;
      case "Italian":
        lang = "it";
        break;
      case "Dutch":
        lang = "nl";
        break;
      default:
        lang = "";
        break;
    }
    return lang;
  }

  void translateDocument() async {
    setState(() {
      isSuccess = true;
    });
    showToast(message: "Translating document!");
    var request = http.MultipartRequest("POST", api);
    request.files.add(await http.MultipartFile.fromPath(
      'file', // This is the key for the file parameter in your API
      inputFile.path,
      contentType: MediaType('application', 'octet-stream'), // You may need to adjust the content type based on your API requirements
    ));

    // Add other parameters if needed
     request.fields['source_language'] = 'en';
     request.fields['target_language'] = setLanguage(selectedItem);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode == 200){
      String? user = auth.currentUser?.email; // Access user information (adjust if needed)
      //String contentType = response.headers['Content-Type'] ?? 'application/octet-stream'; // Get file type from header

      var file = fileName.split(".docx")[0];
      Reference ref = FirebaseStorage.instance.ref().child("$user/Foreign_Translation/Output_documents/$file-$selectedItem.pdf");

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
      docID = docRef.id;

      setState(() {
        isSuccess = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TextForeign(data: docID, name: file+"-"+selectedItem+".pdf"),
        ),
      );
    }else{
      setState(() {
        isSuccess = false;
      });
      showToast(message: response.statusCode.toString());
    }
  }

  void translateDocumentAudio() async {
    setState(() {
      isSuccess = true;
    });
    showToast(message: "Translating document!");
    var request = http.MultipartRequest("POST", audio_api);
    request.files.add(await http.MultipartFile.fromPath(
      'file', // This is the key for the file parameter in your API
      inputFile.path,
      contentType: MediaType('audio', 'mp3'), // You may need to adjust the content type based on your API requirements
    ));

    // Add other parameters if needed
    request.fields['source_language'] = 'en';
    request.fields['target_language'] = setLanguage(selectedItem);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode == 200){
      showToast(message: "Success!");
      final audioBytes = response.bodyBytes;
      String? user = auth.currentUser?.email; // Access user information (adjust if needed)
      //String contentType = response.headers['Content-Type'] ?? 'application/octet-stream'; // Get file type from header

      var file = fileName.toString().split(".docx")[0];
      Reference ref =  FirebaseStorage.instance.ref().child("$user/Foreign_Translation/Output_Audios/$file-$selectedItem.mp3");

      UploadTask uploadTask = ref.putData(audioBytes);

      // Handle completion and errors
      await uploadTask.whenComplete(() => print('File uploaded to Firebase Storage'));
      final outputLink = await ref.getDownloadURL();


      uploadTask.snapshotEvents.listen((event) {
        // Handle progress events
        print(event.bytesTransferred / event.totalBytes);
      });
      DocumentReference docRef = await store.collection("User_Documents").doc(user.toString()).collection("Foreign_Translation_Audio").add({
        "input": downloadLink,
        "output": outputLink
      });
      docID = docRef.id;

      setState(() {
        isSuccess = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioForeign(data: docID, name: file+"-"+selectedItem+".mp3"),
        ),
      );
    }else{
      setState(() {
        isSuccess = false;
      });
      showToast(message: response.statusCode.toString());
    }
  }

  void translateDocumentVideo() async {
    setState(() {
      isSuccess = true;
    });
    showToast(message: "Translating document!");
    var request = http.MultipartRequest("POST", video_api);
    request.files.add(await http.MultipartFile.fromPath(
      'file', // This is the key for the file parameter in your API
      inputFile.path,
      contentType: MediaType('application', 'octet-stream'), // You may need to adjust the content type based on your API requirements
    ));

    // Add other parameters if needed
    request.fields['source_language'] = 'en';
    request.fields['target_language'] = setLanguage(selectedItem);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if(response.statusCode == 200){
      String? user = auth.currentUser?.email; // Access user information (adjust if needed)
      //String contentType = response.headers['Content-Type'] ?? 'application/octet-stream'; // Get file type from header

      var file = fileName.split(".docx")[0];
      Reference ref = FirebaseStorage.instance.ref().child("$user/Foreign_Translation/Output_documents/$file-$selectedItem.mp4");

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
      docID = docRef.id;

      setState(() {
        isSuccess = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoForeign(data: docID, name: file+"-"+selectedItem+".mp4"),
        ),
      );
    }else{
      setState(() {
        isSuccess = false;
      });
      showToast(message: response.statusCode.toString());
    }
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
                      Row(
                        children: [
                          SizedBox(
                            width: 50.0,
                          ),
                          Image(
                            image: AssetImage('assets/logo.png'),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Image(
                            image: AssetImage('assets/logo2.png'),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
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
                                fileName.toString(),
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
                              setState(() {});
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
                      Center(
                        child: Text('Select language for output',
                          style: TextStyle(
                              fontFamily: 'Poppins-Medium',
                              fontSize: 16.0
                          ),),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                          child: SizedBox(
                            width: 150.0,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(width: 1, color: Colors.black)
                                  )
                              ),
                              value: selectedItem,
                              items: languages
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item, style: TextStyle(fontFamily: 'Poppins-Medium'),),
                              )).toList(),
                              onChanged: (item) => setState(() => selectedItem = item!),
                            ),
                          )
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
                                child: isSuccess ? CircularProgressIndicator(
                                  color: Colors.white,) : Text(
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
                      Center(
                        child: Text(
                          'Select the type of output you want to view: ',
                          style: TextStyle(
                            fontFamily: 'Poppins-Medium',
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(selectedItem == ""){
                            showToast(message: "Select a language!");
                          }else if(inputFile == null){
                            showToast(message: "Upload a document!");
                          }else{
                            translateDocument();
                          }
                        },
                        child: Container(
                          height: 55.0,
                          width: 250.0,
                          child: Card(
                              elevation: 8.0,
                              color: Colors.lightBlue[200],
                              child: Center(
                                  child: Text(
                                    'Text Document',
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
                          if(selectedItem == ""){
                            showToast(message: "Select a language!");
                          }else if(inputFile == null){
                            showToast(message: "Upload a document!");
                          }else{
                            translateDocumentAudio();
                          }
                        },
                        child: Container(
                          height: 55.0,
                          width: 250.0,
                          child: Card(
                              elevation: 8.0,
                              color: Colors.lightBlue[200],
                              child: Center(
                                  child: Text(
                                    'Audio File',
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
                          if(selectedItem == ""){
                            showToast(message: "Select a language!");
                          }else if(inputFile == null){
                            showToast(message: "Upload a document!");
                          }else{
                            translateDocumentVideo();
                          }
                        },
                        child: Container(
                          height: 55.0,
                          width: 250.0,
                          child: Card(
                              elevation: 8.0,
                              color: Colors.lightBlue[200],
                              child: Center(
                                  child: Text(
                                    'Video Avatar',
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
                        height: 100.0,
                      )
                    ]

                )
            )
        ),
        floatingActionButton:GestureDetector(
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FeedbackPage(data: "Foreign Translation"),
              ),
            );
          },
          child: Container(
            height: 50.0,
            width: 120.0,
            child: Card(
                elevation: 8.0,
                color: Colors.lightBlue[200],
                child: Center(
                    child: Text(
                      'Feedback',
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins-Medium',
                          color: Colors.white
                      ),
                    )
                )

            ),
          ),
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