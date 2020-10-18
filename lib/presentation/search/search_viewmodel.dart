import 'package:WhatsAppClone/core/models/contact_entity.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  // contacts
  List<ContactEntity> contacts;

  // suggestions
  final List<ContactEntity> _suggestions = [];
  List<ContactEntity> get suggestions => List.from(_suggestions);
}
