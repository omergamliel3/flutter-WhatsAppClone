import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:WhatsAppClone/core/models/status.dart';
import 'package:WhatsAppClone/core/provider/main.dart';

import 'package:WhatsAppClone/services/firebase/firestore_service.dart';
import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:WhatsAppClone/core/alerts/toast.dart';

import 'package:WhatsAppClone/core/widgets/ui_elements/spinkit_loading_indicator.dart';

// parent container border radius
final borderRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(8.0),
        topRight: const Radius.circular(8.0)));

// evoke modal bottom sheet
void showStatusModalBottomSheet(BuildContext context) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: borderRadius,
      builder: (context) {
        return ModalBottomSheetScreen();
      });
}

class ModalBottomSheetScreen extends StatefulWidget {
  @override
  _ModalBottomSheetScreenState createState() => _ModalBottomSheetScreenState();
}

class _ModalBottomSheetScreenState extends State<ModalBottomSheetScreen> {
  // text field controller
  final TextEditingController _textEditingController = TextEditingController();
  // responsive widget
  Widget _responsiveWidget;

  @override
  void initState() {
    _responsiveWidget = _buildUploadButton();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  // inner child container border radius
  final borderRadiusGeometry = BorderRadius.only(
      topLeft: const Radius.circular(8.0),
      topRight: const Radius.circular(8.0));

  // build status text field
  Widget _buildTextField(BuildContext context) {
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: isLight ? Colors.grey[300] : Colors.grey[600],
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        controller: _textEditingController,
        keyboardType: TextInputType.text,
        autofocus: true,
        decoration: InputDecoration.collapsed(hintText: 'Enter your status'),
      ),
    );
  }

  // build upload status button
  Widget _buildUploadButton() {
    return FlatButton(
      child: Text(
        'UPLOAD STATUS',
      ),
      onPressed: () {
        _updateStatus();
      },
    );
  }

  // update status in FirestoreService, PrefsService, MainModel provider
  void _updateStatus() async {
    if (_textEditingController.value.text == null ||
        _textEditingController.value.text.isEmpty) return;
    Status status = Status(
        userName: PrefsService.userName,
        content: _textEditingController.value.text,
        timestamp: DateTime.now().toUtc());

    setState(() {
      _responsiveWidget = Center(
        child: SpinkitLoadingIndicator(),
      );
    });

    // upload status to firestore db
    bool upload = await FirestoreService.uploadStatus(status);
    if (upload) {
      // update user status in main model
      context.read<MainModel>().updateUserStatus(status.content);
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } else {
      // show toast allert
      showToast('Unable to upload status', Toast.LENGTH_SHORT);
      // reset flag and setState to update responsive widget back to button
      setState(() {
        _responsiveWidget = _buildUploadButton();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // execute this code one time only
    final targetSize = MediaQuery.of(context).size.height * 0.2;
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: BoxDecoration(borderRadius: borderRadiusGeometry),
        child: Container(
          height: targetSize,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(context),
              SizedBox(
                height: 10,
              ),
              _responsiveWidget
            ],
          ),
        ),
      ),
    );
  }
}
