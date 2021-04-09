import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cached_network_image/cached_network_image.dart';

Future<Widget> getImage(
    BuildContext context, String imageUrl, double imageHeight) async {
  final image = firebase_storage.FirebaseStorage.instance.ref().child(imageUrl);
  imageHeight = imageHeight * 1.0;

  try {
    var url = await image.getDownloadURL();
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Scaffold(), //CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
      fit: BoxFit.scaleDown,
    );
  } catch (error) {
    print("ERROR: IMAGE $imageUrl NOT FOUND $error.toString()");
    return Icon(Icons.visibility_off);
  }
}
