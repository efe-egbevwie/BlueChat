import 'package:bluechat/models/message.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget({Key key, this.message, this.isMe}) : super(key: key);
  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(40)),
            child: Column(
              children: [
                Text(Utils.formatDateTime(message.createdAt)),
                SizedBox(height: 10),
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: message.imageUrl,
                  height: size.height * 0.40,
                  width: size.width * 0.60,
                ),
                SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}
