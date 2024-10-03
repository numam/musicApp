import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Page'),
      ),
      body: Center(
        child: Text('Welcome to the New Page!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
