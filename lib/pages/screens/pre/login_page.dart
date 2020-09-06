import 'package:flutter/material.dart';

import 'package:WhatsAppClone/services/firebase/auth_service.dart';
import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

import 'package:WhatsAppClone/helpers/navigator_helper.dart';

import 'package:WhatsAppClone/core/shared/constants.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/spinkit_loading_indicator.dart';

enum FormMode { PhoneNum, UserName }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form global keys
  GlobalKey<FormState> _formKeyAuth;
  GlobalKey<FormState> _formKeyUserName;
  // holds form fields data variables
  String _phoneNum;
  String _userName;
  // holds the current shown widget
  Widget _displayWidget;
  // holds the current form mode [PhoneNum/UserName]
  FormMode _formMode;
  final navigator = NavigatorHelper;

  // Called when this object is inserted into the tree.
  @override
  void initState() {
    _formKeyAuth = GlobalKey<FormState>();
    _formKeyUserName = GlobalKey<FormState>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _displayWidget = _buildPhoneNumForm();
      });
    });

    super.initState();
  }

  // build progress indicator widget
  Widget _buildProgressBarIndicator() {
    return Center(
      child: SpinkitLoadingIndicator(),
    );
  }

  // build phone number text field
  Widget _buildPhoneNumFormField() {
    return TextFormField(
        autofocus: false,
        initialValue: '+9720587675744',
        decoration: InputDecoration(
            hintText: 'Enter your phone number',
            prefixIcon: Icon(Icons.phone),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(width: .7)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    width: .7, color: Theme.of(context).accentColor))),
        keyboardType: TextInputType.phone,
        validator: (String value) {
          if (!value.contains(
              RegExp(r'^\+?(972|0)(\-)?0?(([23489]{1}\d{7})|[5]{1}\d{8})$'))) {
            return 'Invalid phone number';
          }
          return null;
        },
        onSaved: (String value) {
          _phoneNum = value;
        });
  }

  // build phone number text field
  Widget _buildUserNameFormField() {
    return TextFormField(
        autofocus: false,
        initialValue: 'omer gamliel',
        decoration: InputDecoration(
            hintText: 'Enter username',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(width: .7)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    width: .7, color: Theme.of(context).accentColor))),
        keyboardType: TextInputType.text,
        validator: (String value) {
          if (!value.contains(
              RegExp(r"""^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"""))) {
            return 'Invalid username';
          }
          return null;
        },
        onSaved: (String value) {
          _userName = value;
        });
  }

  // build continue button
  Widget _buildContinueButton() {
    return RaisedButton(
      onPressed: _submitForm,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[kPrimaryColor, Colors.green],
          ),
          borderRadius: BorderRadius.all(Radius.circular(80.0)),
        ),
        child: Container(
          width: 150,
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
          alignment: Alignment.center,
          child: Text(
            'CONTINUE',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  // build whatsapp icon
  Widget _buildWhatsAppIcon() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Image.asset(
        iconAssetName,
        fit: BoxFit.contain,
        height: 100,
        width: 100,
      ),
    );
  }

  // build Form phone num auth
  Widget _buildPhoneNumForm() {
    _formMode = FormMode.PhoneNum;
    return Form(
      key: _formKeyAuth,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            _buildPhoneNumFormField(),
            SizedBox(height: 15),
            _buildContinueButton(),
            Spacer(),
            _buildWhatsAppIcon()
          ],
        ),
      ),
    );
  }

  // build user name form
  Widget _buildUserNameForm() {
    _formMode = FormMode.UserName;
    return Form(
      key: _formKeyUserName,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Column(
          children: [
            SizedBox(height: 15),
            _buildUserNameFormField(),
            SizedBox(height: 15),
            _buildContinueButton(),
            Spacer(),
            _buildWhatsAppIcon()
          ],
        ),
      ),
    );
  }

  // submit form according to formMode [PhoneNum/UserName]
  void _submitForm() {
    if (_formMode == FormMode.PhoneNum) {
      _submitPhoneNumForm();
    } else if (_formMode == FormMode.UserName) {
      _submitUserNameForm();
    }
  }

  //  submit phone num form
  void _submitPhoneNumForm() async {
    // validate phone num field
    if (_formKeyAuth.currentState.validate()) {
      // save phone num value
      _formKeyAuth.currentState.save();
      setState(() {
        _displayWidget = _buildProgressBarIndicator();
      });
      // register user
      //await AuthService.registerUser(_phoneNum, context);
      // TODO: REMOVE MOCK REGISTER ON RELEASE
      await AuthService.mockRegisterUser();
      if (PrefsService.isAuthenticated) {
        setState(() {
          _displayWidget = _buildUserNameForm();
        });
      } else {
        setState(() {
          _displayWidget = _buildPhoneNumForm();
        });
        // show alert dialog
        _showFailedAuthDialog();
      }
    }
  }

  // submit user name form
  void _submitUserNameForm() async {
    // validate username field
    if (_formKeyUserName.currentState.validate()) {
      _formKeyUserName.currentState.save();
      // save username in prefs service
      PrefsService.saveUserName(username: _userName);
      // set display widget to loading indicator
      setState(() {
        _displayWidget = _buildProgressBarIndicator();
      });
      // delay to show loading indicator
      await Future.delayed(Duration(seconds: 1));
      // navigate main page
      NavigatorHelper.navigateMainPage(context);
    }
  }

  // show authentication failed dialog
  void _showFailedAuthDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Phone auth failed'),
          content: Text('Please validate your phone number'),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Theme.of(context).accentColor),
                ))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Sign Up'),
          ),
          body: Container(
            padding: EdgeInsets.all(4.0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: _displayWidget,
            ),
          )),
    );
  }
}
