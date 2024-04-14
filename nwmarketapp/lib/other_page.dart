// other_page.dart

import 'package:flutter/material.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Other Page'),
      ),
      body: Center(
        child: Text(
          'This is the Other Page',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
