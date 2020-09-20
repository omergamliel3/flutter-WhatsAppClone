import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

import '../../../core/models/contact_entity.dart';
import '../../../core/provider/main.dart';

class SelectContactViewModel extends BaseViewModel {
  // create new contactEntity to main model
  Future<void> createContactEntity(
      ContactEntity contactEntity, BuildContext context) async {
    // activate contactEntity
    await context.read<MainModel>().activeContact(contactEntity);
  }

  // get un-active contacts from main model
  List<ContactEntity> getUnActiveContacts(BuildContext context) {
    return context.read<MainModel>().unActiveContacts;
  }
}
