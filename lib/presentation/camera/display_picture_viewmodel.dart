import '../../core/routes/router.dart';
import 'package:stacked/stacked.dart';

import '../../locator.dart';

import '../index.dart';

class DisplayPictureViewModel extends BaseViewModel {
  final router = locator<Router>();

  void sendPicture(String imagePath) {
    router.navigateContactScreen(ContactMode.setImage, imagePath);
  }
}
