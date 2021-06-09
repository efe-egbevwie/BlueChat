import 'dart:io';

import 'package:bluechat/service_locator.dart';
import 'package:bluechat/services/auth.dart';
import 'package:bluechat/services/navigation_service.dart';
import 'package:bluechat/view_models/chat_page_view_model.dart';
import 'package:bluechat/view_models/crop_image_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:provider/provider.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({
    Key key,
    @required this.image,
    @ required this.receiverUid,
  }) : super(key: key);
  final File image;
  final String receiverUid;

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final cropKey = GlobalKey<CropState>();

  @override
  Widget build(BuildContext context) {
    final _cropImageViewModel = Provider.of<CropImageViewModel>(context);
    final _chatPageViewModel = Provider.of<ChatPageViewModel>(context);
    NavigationService _navigationService = locator<NavigationService>();

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
                    onPressed: () async {
                      final image = await _cropImageViewModel.cropImage(cropKey: cropKey, file: widget.image);
                      _chatPageViewModel.sendImage(
                        image: image,
                        receiverUid: widget.receiverUid,
                        senderUid: AuthService.getUid(),
                      );
                      _navigationService.pop();
                    },
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
