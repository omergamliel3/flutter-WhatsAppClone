import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:WhatsAppClone/presentation/search/search_viewmodel.dart';
import 'package:WhatsAppClone/presentation/shared/mode.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  final ContactMode mode;
  final List<ContactEntity> contacts;
  final String imagePath;
  SearchView({this.mode, this.contacts, this.imagePath});

  final TextEditingController _textController = TextEditingController();

  // UnFocusScope Method, creates a new FocusNode
  void _unFocusScope(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // build title textField widget method
  Widget _buildTitleTextField(SearchViewModel model) {
    return TextField(
      controller: _textController,
      autofocus: true,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search contacts',
        hintStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        // search suggestions
        //model.searchSuggestions(value);
        model.handleOnSearchChange(value);
      },
    );
  }

  // build streamBuilder that listen to suggestions stream from viewmodel
  Widget _buildSuggestions(SearchViewModel model) {
    return StreamBuilder<List<ContactEntity>>(
      stream: model.suggestions,
      builder: (context, snapshot) {
        // If an error occurs
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong :('),
          );
        }
        // If snapshot data is not null and empty, return listView widget
        if (snapshot.data != null && snapshot.data.isNotEmpty) {
          return _buildDataWidget(snapshot.data, model);
        }
        // While loading return empty container
        return Container();
      },
    );
  }

  Widget _buildDataWidget(
      List<ContactEntity> suggestions, SearchViewModel model) {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final contact = suggestions[index].displayName ?? '<unknown>';
        return Container(
          padding: const EdgeInsets.all(2),
          child: ListTile(
            onTap: () {
              _textController.text = contact;
              _textController.selection = TextSelection(
                  baseOffset: contact.length, extentOffset: contact.length);
              model.performAction(
                  mode: mode,
                  contactEntity: suggestions[index],
                  imagePath: imagePath);
            },
            leading: const Icon(Icons.search),
            trailing: const Icon(Icons.call_made),
            title: Text(contact,
                style: TextStyle(
                    fontSize: 18, color: Theme.of(context).accentColor)),
          ),
        );
      },
    );
  }

  // set textController text value to empty string
  void _clear(SearchViewModel model) {
    _textController.text = '';
    model.searchSuggestions(null);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: ViewModelBuilder<SearchViewModel>.nonReactive(
          viewModelBuilder: () => SearchViewModel(),
          onModelReady: (model) => model.contacts = contacts,
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: _buildTitleTextField(model),
                actions: <Widget>[
                  IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: () => _clear(model),
                  )
                ],
              ),
              body: GestureDetector(
                onTap: () => _unFocusScope(context),
                child: _buildSuggestions(model),
              ),
            );
          },
        ));
  }
}
