import 'package:flutter/material.dart';
import 'package:stripe_widget/stripe_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _token = "";
  @override
  void initState() {
    super.initState();
    StripeWidget.setPublishableKey("pk_test");
    StripeWidget.addSource().then((String token) {
      print("token:$token");
      _addSource(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Stripe Widget'),
        ),
        body: Center(
          child: Text(_token),
        ),
      ),
    );
  }

  void _addSource(String token) {
    setState(() {
      _token = token;
    });
  }
}
