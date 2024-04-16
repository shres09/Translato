import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:translato/firebase_options.dart';
import 'package:translato/pages/sign_up.dart';
import 'package:translato/pages/text_foreign.dart';
import 'package:translato/pages/text_indian.dart';
import 'package:translato/pages/video_foreign.dart';
import 'package:translato/pages/video_indian.dart';
import 'pages/home.dart';
import 'pages/intro.dart';
import 'pages/services.dart';
import 'pages/data_curation.dart';
import 'pages/foreign.dart';
import 'pages/indian.dart';
import 'pages/login.dart';
import 'pages/audio_foreign.dart';
import 'pages/audio_indian.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Make sure WidgetsFlutterBinding is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const Home(),
    '/login': (context) => const Login(),
    '/register': (context) => const SignUp(),
    '/intro': (context) => const Intro(),
    '/services' : (context) => const Services(),
    '/data_curation' : (context) => const DataCuration(),
    '/foreign' : (context) => const Foreign(),
    '/indian' : (context) => const Indian(),
    '/text_foreign': (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
        final data = args['data'] as String;
        final name = args['name'] as String;
        return TextForeign(data: data, name: name);
    },
    '/video_foreign' : (context) => const VideoForeign(),
    '/audio_foreign' : (context) {
  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
  final data = args['data'] as String;
  final name = args['name'] as String;
  return AudioForeign(data: data, name: name);
  },
    '/text_indian' : (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final data = args['data'] as String;
      final name = args['name'] as String;
      return TextIndian(data: data, name: name);
    },
    '/audio_indian' : (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      final data = args['data'] as String;
      final name = args['name'] as String;
      return AudioIndian(data: data, name: name);
    },
    '/video_indian' : (context) => const VideoIndian(),
  },
));}
