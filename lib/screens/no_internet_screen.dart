import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("No Internet Connection"),
      ),
    );
  }
}
