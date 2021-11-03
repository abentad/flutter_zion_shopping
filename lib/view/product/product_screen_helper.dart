import 'package:flutter/services.dart';
import 'package:flutter_node_auth/constants/api_path.dart';
import 'package:flutter_node_auth/controller/api_controller.dart';
import 'package:flutter_node_auth/utils/app_helpers.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:share_plus/share_plus.dart';

void shareProduct(ApiController controller, int selectedProductIndex) async {
  String? path;
  try {
    // Saved with this method.
    var imageId = await ImageDownloader.downloadImage("$kbaseUrl/${controller.products[selectedProductIndex].image}");
    if (imageId == null) {
      return;
    }
    // Below is a method of obtaining saved image information.
    // var fileName = await ImageDownloader.findName(imageId);
    path = await ImageDownloader.findPath(imageId);
    // var size = await ImageDownloader.findByteSize(imageId);
    // var mimeType = await ImageDownloader.findMimeType(imageId);
    // print(fileName);
    // print(path);
    // print(size);
    // print(mimeType);
  } on PlatformException catch (error) {
    print(error);
  }
  Share.shareFiles([path!],
      text:
          "${controller.products[selectedProductIndex].name.capitalize}\n${formatPrice(controller.products[selectedProductIndex].price)} Birr\ncall ${controller.products[selectedProductIndex].posterName.capitalize} : ${controller.products[selectedProductIndex].posterPhoneNumber}\nShared from Hooli Mart App");
}
