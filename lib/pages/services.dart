import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translato/global/common/toast.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/data_curation');
              },
              child: Card(
                shadowColor: Colors.blue,
                color: Colors.white,
                elevation: 8.0,
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        'Data Curation',
                        style: TextStyle(
                          fontFamily: 'Anton-Regular',
                          fontSize: 28.0,
                          color: Colors.blueAccent,
                          letterSpacing: 1.5
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            'Upload a document to summarize your data and get a better understanding ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Poppins-Medium',
                                fontSize: 13.0,
                                color: Colors.black,
                                letterSpacing: 1.0
                            )
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Start',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0
                            ),
                          ),
                          Icon(
                            Icons.arrow_right,
                            size: 40.0,
                            color: Colors.blueAccent,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      )
                    ],
                  ),
                ),
              )
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/foreign');
                },
                child: Card(
                  shadowColor: Colors.blue,
                  color: Colors.white,
                  elevation: 8.0,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Foreign Languages',
                          style: TextStyle(
                              fontFamily: 'Anton-Regular',
                              fontSize: 28.0,
                              color: Colors.blueAccent,
                              letterSpacing: 1.5
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Translate your documents from English to Foreign languages and get the output in the form of text, audio or video',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: 1.0
                              )
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Start',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0
                              ),
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: 40.0,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                )
            ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/indian');
                },
                child: Card(
                  shadowColor: Colors.blue,
                  color: Colors.white,
                  elevation: 8.0,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          'Indian Languages',
                          style: TextStyle(
                              fontFamily: 'Anton-Regular',
                              fontSize: 28.0,
                              color: Colors.blueAccent,
                              letterSpacing: 1.5
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Translate your documents from English to Indian languages and get the output in the form of text, audio or video',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins-Medium',
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  letterSpacing: 1.0
                              )
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Start',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2.0
                              ),
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: 40.0,
                              color: Colors.blueAccent,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        )
          ],
        ),
      )
                        )
                        ),
            SizedBox(
              height: 20.0,
            ),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                showToast(message: "User signed out!");
                Navigator.pop(context);
                Navigator.pushNamed(context, '/');
              },
              child: Container(
                width: 200,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
      )
    );
  }
}
