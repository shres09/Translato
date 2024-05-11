import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:translato/global/common/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CurationDocx extends StatefulWidget {
  final String data;
  final String name;

  const CurationDocx({Key? key, required this.data, required this.name}) : super(key: key);

  @override
  State<CurationDocx> createState() => _CurationDocxState();
}

class _CurationDocxState extends State<CurationDocx> {
  String fileName = "None";
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  var outputUrl;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    getDoc(); // Fetch data immediately upon widget initialization
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String filePath) async {
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      ticker: 'ticker',
    );
    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Downloaded File',
      'File downloaded to: $filePath',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  Future<void> requestStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, proceed with download
      showToast(message: "Downloading Document");
      await downloadFileFromStorage();
    } else if (status.isDenied) {
      // Permission denied, show dialog to open app settings
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Storage Permission Required"),
            content: Text(
              "Please grant storage permission to download the document.",
            ),
            actions: <Widget>[
              TextButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text("SETTINGS"),
                onPressed: () {
                  Navigator.of(context).pop();
                  openAppSettings(); // Open app settings screen
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> downloadFileFromStorage() async {
    try {
      String downloadUrl = outputUrl; // Add your Firebase Storage download URL here
      if (downloadUrl.isEmpty) {
        showToast(message: 'Download URL is empty');
        return;
      }

      // Get the temporary directory on the device
      Directory? appDocDir = await getDownloadsDirectory();
      String downloadsDirPath = '/storage/emulated/0/download';
      await Directory(downloadsDirPath).create(recursive: true); // Create the directory if it doesn't exist
      String filePath = '$downloadsDirPath/$fileName';

      // Send a GET request to download the file
      var response = await http.get(Uri.parse(downloadUrl));

      // Write the file to the device
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print('File downloaded to: $filePath');
      showToast(message: 'File downloaded successfully');
      showNotification(filePath);

      setState(() {
        this.fileName = fileName;
      });
    } catch (error) {
      print('Error downloading file: $error');
      showToast(message: 'Error downloading file');
    }
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
                        // Request storage permission
                        await requestStoragePermission();
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
                                height: 100.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                fileName,
                                style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 13.0,
                                ),
                              ),
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
                        fontFamily: 'Poppins-Medium',
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
