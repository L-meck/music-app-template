import 'package:flutter/material.dart';

class ImageSong extends StatelessWidget {
  final String _assetPath;

  const ImageSong(this._assetPath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(height: 400.0),
      // decoration: BoxDecoration(),
      child: Image.asset(
        _assetPath,
        fit: BoxFit.none,
      ),
    );
  }
}
