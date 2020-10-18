import 'package:WhatsAppClone/presentation/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SearchView extends StatelessWidget {
  final Function onPressed;

  SearchView({this.onPressed});

  final TextEditingController _textController = TextEditingController();

  // UnFocusScope Method, creates a new FocusNode
  void _unFocusScope(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // build title textField widget method
  Widget _buildTitleTextField() {
    return TextField(
      controller: _textController,
      autofocus: true,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        hintText: 'Search for articles',
        hintStyle: TextStyle(fontSize: 16),
        border: InputBorder.none,
      ),
      onChanged: (_) {
        // check for suggestions
        // setState(() {
        //   futureList = _getSuggestions();
        // });
      },
      onSubmitted: (search) {
        _submitSearch(search);
      },
    );
  }

  // build suggestions list view widget
  Widget _buildSuggestions() {
    return Container();
    // return ListView.builder(
    //   itemCount: suggestions.length,
    //   itemBuilder: (context, index) {
    //     final text = suggestions[index];
    //     return Container(
    //       padding: const EdgeInsets.all(2),
    //       child: ListTile(
    //         onTap: () {
    //           // set textfield text to suggestions[index], keep cursor at the end of the text
    //           _textController.text = text;
    //           _textController.selection = TextSelection(
    //               baseOffset: text.length, extentOffset: text.length);
    //           // call submit search
    //           _submitSearch(text);
    //         },
    //         leading: const Icon(Icons.search),
    //         trailing: const Icon(Icons.call_made),
    //         //subtitle: Text('SUGGESTION ${index + 1}'),
    //         title: Text(text,
    //             style: TextStyle(
    //                 fontSize: 18, color: Theme.of(context).accentColor)),
    //       ),
    //     );
    //   },
    // );
  }

  // clear method, called when pressed 'Clear' iconButton
  void _clear() {}

  // submit search method called when submit the search
  void _submitSearch(String search) {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: ViewModelBuilder<SearchViewModel>.reactive(
          viewModelBuilder: () => SearchViewModel(),
          builder: (context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: _buildTitleTextField(),
                actions: <Widget>[
                  IconButton(
                    tooltip: 'Clear',
                    icon: const Icon(Icons.clear),
                    onPressed: _clear,
                  )
                ],
              ),
              body: GestureDetector(
                onTap: () => _unFocusScope(context),
                child: _buildSuggestions(),
              ),
            );
          },
        ));
  }
}
