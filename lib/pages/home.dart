import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
        child: const Center(
          child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
              child: Image(
                image: AssetImage('assets/logo.png'),
              ),
            ),
          SizedBox(
            height: 20.0,
          ),
          Text(
              'Translate with ease',
              style: TextStyle(
                fontFamily: 'Anton-Regular',
                fontSize: 32.0,
              ),
            ),
            Text(
                'Break language barriers',
                style: TextStyle(
                  fontFamily: 'Anton-Regular',
                  fontSize: 16.0,
                ),
              ),
            SizedBox(
              height: 10.0,
            ),
            Image(
                image: AssetImage('assets/display_image.png'),
            ),
          SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
            child: Text(
              'Translate all your documents to your desired language',
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Poppins-Medium',
                color: Colors.lightBlue,
              ),
            ),
          ),
            Padding(
              padding: EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 0.0),
              child: Text(
                'View your data in the form of text, audio or video avatar.',
                style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Poppins-Medium',
                  color: Colors.indigo,
                ),
              ),
            ),SizedBox(
              height: 20.0,
            )],
        ),
      ),
      ),
        floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: () {
            setState(() {
              Navigator.pushNamed(context, '/intro');
            });
          },
          height: 40.0,
          color: Colors.lightBlue,
          child: const Text(
            'Try it now',
            style: TextStyle(
              fontSize: 18.0,
              fontFamily: 'Poppins-Medium',
              color: Colors.white,
              letterSpacing: 1.5
            ),
          ),
        ),
      ),
    );
  }
}
