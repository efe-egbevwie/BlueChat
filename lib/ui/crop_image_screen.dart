import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key key,
    this.image,
  }) : super(key: key);
  final File image;

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              Expanded(
                child: Crop.file(
                  widget.image,
                  key: cropKey,
                ),
              ),
              Row(
                children: [
                  SizedBox(width: 20),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(),
                  )),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
