import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('PHONE NUMBER VERIFICATION'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('INPUT FIELD PHONE NUMBER'),
                TextFormField(
                  autofocus: true,
                  autovalidate: true,
                  decoration: InputDecoration(
                    labelText: 'Phone number',
                  ),
                  keyboardType: TextInputType.phone,
                  onFieldSubmitted: (String value) {
                    Navigator.pushReplacementNamed(context, '/main_page');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
