import 'package:flutter/material.dart';

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return const [Text('actions')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const Text('leading');
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('results');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Text('suggestions');
  }
}
