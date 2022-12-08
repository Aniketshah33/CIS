/// _ScoreScreenState extends State&lt;ScoreScreen&gt; and overrides build() to return a Scaffold with
/// an AppBar and a Center widget containing a Column with a Text and four ListTile widgets.
import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({Key? key}) : super(key: key);

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "All score",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            ListTile(
              title: Text("10"),
            ),
            ListTile(
              title: Text("11"),
            ),
            ListTile(
              title: Text("7"),
            ),
            ListTile(
              title: Text("0"),
            ),
          ],
        ),
      ),
    );
  }
}
