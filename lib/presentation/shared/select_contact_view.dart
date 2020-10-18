import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'select_contact_viewmodel.dart';

import '../../core/models/contact_entity.dart';

import 'mode.dart';
import 'widgets/popup_menu_button.dart';

class SelectContactScreen extends StatelessWidget {
  final ContactMode _contactMode;
  final String imagePath;
  const SelectContactScreen(this._contactMode, [this.imagePath]);

  // build contact list tile
  Widget _buildContactListTile(
      ContactEntity contactEntity, SelectContactViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(contactEntity.displayName[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          title: Text(contactEntity.displayName),
          trailing: _contactMode != ContactMode.calls
              ? const SizedBox()
              : IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: _contactMode == ContactMode.calls
                      ? () => model.launchCall(contactEntity.phoneNumber)
                      : null),
          onTap: () => handleOnTapType(contactEntity, model)),
    );
  }

  // build appbar title
  Widget _buildAppBarTitle(BuildContext context, int contactsLength) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select contact'),
        const SizedBox(height: 3.0),
        Text(
          '${contactsLength.toString()} contacts',
          style: Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Colors.grey[300]),
        ),
      ],
    );
  }

  // build scaffold appbar
  PreferredSizeWidget _buildAppBar(BuildContext context,
      List<ContactEntity> contacts, SelectContactViewModel model) {
    return AppBar(
      title: _buildAppBarTitle(context, contacts.length),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              model.navigateSearch();
            }),
        if (_contactMode != ContactMode.setImage)
          PopUpMenuButton()
        else
          Container()
      ],
    );
  }

  void handleOnTapType(
      ContactEntity contactEntity, SelectContactViewModel model) {
    if (_contactMode == ContactMode.chat) {
      model.activateContact(contactEntity);
    } else if (_contactMode == ContactMode.setImage) {
      model.sendImage(imagePath, contactEntity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectContactViewModel>.reactive(
        viewModelBuilder: () => SelectContactViewModel(),
        builder: (context, model, child) {
          final contacts = model.getViewContacts(_contactMode);
          return SafeArea(
            top: false,
            child: Scaffold(
              appBar: _buildAppBar(context, contacts, model),
              body: Scrollbar(
                child: ListView.builder(
                    physics: const ScrollPhysics(),
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return Container(
                          key: ValueKey('contact$index'),
                          child: _buildContactListTile(contacts[index], model));
                    }),
              ),
            ),
          );
        });
  }
}
