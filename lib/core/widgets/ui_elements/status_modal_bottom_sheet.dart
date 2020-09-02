// show status input modal bottom sheet
import 'package:WhatsAppClone/services/firebase/firestore_service.dart';
import 'package:flutter/material.dart';

import 'package:WhatsAppClone/core/models/status.dart';

import 'package:WhatsAppClone/services/local_storage/prefs_service.dart';

final borderRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(8.0),
        topRight: const Radius.circular(8.0)));

void showStatusModalBottomSheet(BuildContext context) {
  final bool isLight = Theme.of(context).brightness == Brightness.light;
  final targetSize = MediaQuery.of(context).size.height * 0.2;
  TextEditingController _textEditingController = TextEditingController();
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: borderRadius,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(8.0),
                    topRight: const Radius.circular(8.0))),
            child: Container(
              height: targetSize,
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: isLight ? Colors.grey[300] : Colors.grey[600],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _textEditingController,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      decoration: InputDecoration.collapsed(
                          hintText: 'Enter your status'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    child: Text(
                      'UPLOAD STATUS',
                    ),
                    onPressed: () async {
                      if (_textEditingController.value.text == null ||
                          _textEditingController.value.text.isEmpty) return;
                      Status status = Status(
                          name: PrefsService.userName,
                          content: _textEditingController.value.text,
                          dateTime: DateTime.now());
                      // upload status to firestore db
                      bool upload = await FirestoreService.uploadStatus(status);
                      if (upload) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      });
}
