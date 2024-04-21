import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:translato/global/common/toast.dart';
import 'package:translato/widgets/text_field.dart';

class FeedbackPage extends StatefulWidget {
  final String data;
  const FeedbackPage({Key? key, required this.data})
      : super(key: key);

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  var auth = FirebaseAuth.instance;
  TextEditingController feedback = TextEditingController();
  int _selectedScore = 0;
  int accuracy = 0;

  @override
  void initState() {
    super.initState();
     // Fetch data immediately upon widget initialization
  }

  void _selectScore(int score) {
    setState(() {
      _selectedScore = score;
    });
  }

  void selectAccuracy(int score) {
    setState(() {
      accuracy = score;
    });
  }

  Future<void> _submitFeedback() async {
    try {
      var service = widget.data;
      String? user = auth.currentUser?.email; // Replace with the actual user ID or username
      await FirebaseFirestore.instance.collection('Feedback').add({
        'service': service,
        'user': user,
        'translation': _selectedScore,
        'accuracy': accuracy,
        'feedback' : feedback,
        'timestamp': Timestamp.now(),
      });
      // Show success message or navigate to another screen
      showToast(message: 'Feedback submitted successfully.');
    } catch (error) {
      // Handle error
      showToast(message: 'Error submitting feedback: $error');
    }
  }

  @override
  void dispose() {
    feedback.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How would you rate your experience?',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 50.0),
            Center(
              child: Row(
                children: [
                  Text(
                    "Translation quality: ",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Medium',
                        color: Colors.black
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () {
                            _selectScore(i);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedScore >= i ? Colors.blue : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                '$i',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: Row(
                children: [
                  Text(
                    "Translation accuracy: ",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins-Medium',
                        color: Colors.black
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      for (int i = 1; i <= 5; i++)
                        GestureDetector(
                          onTap: () {
                            selectAccuracy(i);
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accuracy >= i ? Colors.blue : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                '$i',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: 10.0,
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Column(
              children: [
                Text(
                  "Feedback"
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFieldFormat(
                  controller: feedback,
                  hintText: "Feedback",
                  isPasswordField: false,
                ),
              ],
            ),
            SizedBox(
              height: 30.0,
            ),
            GestureDetector(
              onTap: (){
                _selectedScore != 0 || accuracy != 0? _submitFeedback : null;
                Navigator.pushNamed(context, '/services');
              },
              child: Container(
                height: 55.0,
                width: 250.0,
                child: Card(
                    elevation: 8.0,
                    color: Colors.lightBlue[200],
                    child: Center(
                        child: Text(
                          'Submit feedback',
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-Medium',
                              color: Colors.white
                          ),
                        )
                    )

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}