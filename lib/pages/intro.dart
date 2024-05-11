import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
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
              height: 50.0,
            ),
            Text(
              'Login or Register',
              style: TextStyle(
                fontFamily: 'Anton-Regular',
                fontSize: 32.0,
              ),
            ),
            Text(
              'to start using our services',
              style: TextStyle(
                fontFamily: 'Anton-Regular',
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 90.0,
            ),
          MaterialButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/login');
              });
            },
            color: Colors.blue,
            minWidth: 300.0,
            height: 50.0,
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontFamily: 'Poppins-Medium'
              ),
            ),
          ),
            SizedBox(
              height: 30.0,
            ),
            MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pushNamed(context, '/register');
                  });
                },
              color: Colors.blue,
              minWidth: 300.0,
              height: 50.0,
              child: Text(
                'Register',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontFamily: 'Poppins-Medium'
                ),
              ),
            )],
        ),
      ),
      )
    );
  }
}

