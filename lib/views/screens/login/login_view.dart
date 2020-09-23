import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:stacked/stacked.dart';
import 'login_viewmodel.dart';

import '../../../services/locator.dart';
import '../../../services/auth/auth_service.dart';

import '../../../core/shared/constants.dart';

import '../../../core/widgets/ui_elements/spinkit_loading_indicator.dart';
import 'widgets/dialogs.dart';
import 'widgets/whatapp_image.dart';

enum FormMode { phoneNum, userName }

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // viewmodel
  LoginViewModel _model;
  // form global keys
  GlobalKey<FormState> _formKeyAuth;
  GlobalKey<FormState> _formKeyUserName;
  // holds form fields data variables
  String _phoneNum;
  String _userName;
  // holds the current shown form widget
  Widget _responsiveWidget;
  // holds the current form mode [PhoneNum/UserName]
  FormMode _formMode;
  // busy bool flag to controll loading
  bool busy = false;

  @override
  didChangeDependencies() {
    _responsiveWidget = _buildPhoneNumForm();
    super.didChangeDependencies();
  }

  // build progress indicator widget
  Widget _buildProgressBarIndicator() {
    return SpinkitLoadingIndicator();
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
        validator: (value) {
          if (!value.contains(
              RegExp(r'^\+?(972|0)(\-)?0?(([23489]{1}\d{7})|[5]{1}\d{8})$'))) {
            return 'Invalid phone number';
          }
          return null;
        },
        onSaved: (value) {
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
        validator: (value) {
          if (!value.contains(
              RegExp(r"""^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"""))) {
            return 'Invalid username';
          }
          return null;
        },
        onSaved: (value) {
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

  // build Form phone num auth
  Widget _buildPhoneNumForm() {
    _formKeyAuth = GlobalKey<FormState>();
    _formMode = FormMode.phoneNum;
    return Form(
      key: _formKeyAuth,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: _buildPhoneNumFormField(),
      ),
    );
  }

  // build user name form
  Widget _buildUserNameForm() {
    _formKeyUserName = GlobalKey<FormState>();
    _formMode = FormMode.userName;
    return Form(
      key: _formKeyUserName,
      child: Container(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: _buildUserNameFormField(),
      ),
    );
  }

  // build user profile
  // ignore: unused_element
  Widget _buildUserProfile() {
    return Container(
      padding: EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        children: [
          Text('Pick your profile picture'),
          SizedBox(height: 5.0),
          CircleAvatar(backgroundColor: Colors.grey),
          SizedBox(height: 10.0),
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                    child: Text('FROM GALLERY'),
                    onPressed: () => _model.navigateMainPage()),
                SizedBox(width: 5.0),
                FlatButton(
                    child: Text('TAKE A NEW PICTURE'),
                    onPressed: () => _model.navigateMainPage()),
              ],
            ),
          )
        ],
      ),
    );
  }

  // submit form according to formMode [PhoneNum/UserName]
  void _submitForm() {
    if (_formMode == FormMode.phoneNum) {
      _submitPhoneNumForm();
    } else if (_formMode == FormMode.userName) {
      _submitUserNameForm();
    }
  }

  //  submit phone num form
  void _submitPhoneNumForm() async {
    // validate phone num field
    if (_formKeyAuth.currentState.validate()) {
      setState(() {
        _responsiveWidget = _buildProgressBarIndicator();
      });
      // save phone num value
      _formKeyAuth.currentState.save();
      if (!_model.connectivity) {
        showNoConnectionDialog(context);
        setState(() {
          _responsiveWidget = _buildPhoneNumForm();
        });
        return;
      }
      // register user
      if (foundation.kDebugMode) {
        await locator<AuthService>().mockRegisterUser();
      } else {
        await locator<AuthService>().registerUser(_phoneNum, context);
      }

      if (_model.isAuthenticated) {
        setState(() {
          _responsiveWidget = _buildUserNameForm();
        });
      } else {
        setState(() {
          _responsiveWidget = _buildPhoneNumForm();
        });
      }
    }
  }

  // submit user name form
  void _submitUserNameForm() async {
    // validate username field
    if (_formKeyUserName.currentState.validate()) {
      setState(() {
        _responsiveWidget = _buildProgressBarIndicator();
      });
      _formKeyUserName.currentState.save();
      if (!_model.connectivity) {
        showNoConnectionDialog(context);
        setState(() {
          _responsiveWidget = _buildUserNameForm();
        });
        return;
      }
      var validateUserWithDB = await _model.isUserValid(_userName.trim());
      if (!validateUserWithDB) {
        setState(() {
          _responsiveWidget = _buildUserNameForm();
        });
        showUserIsTakenDialog(context);
        return;
      }
      // add username to firestore usernames collection
      await _model.addUsername(_userName);
      // save username in prefs service
      _model.saveUsername(_userName);
      // delay to show loading indicator
      await Future.delayed(Duration(seconds: 1));
      _model.navigateMainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.nonReactive(
        viewModelBuilder: () => LoginViewModel(),
        builder: (context, model, child) {
          _model = model;
          return SafeArea(
            top: false,
            child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('Sign Up'),
                ),
                body: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Container(
                          height: 60,
                          child: AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            child: _responsiveWidget,
                          ),
                        ),
                        SizedBox(height: 15),
                        _buildContinueButton(),
                        Spacer(),
                        WhatsAppImage()
                      ],
                    ))),
          );
        });
  }
}
