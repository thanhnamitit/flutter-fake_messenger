import 'package:conversation_maker/domain/entity/story_image.dart';
import 'package:conversation_maker/resource/R.dart';
import 'package:conversation_maker/widget/dynamic_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'dialog/text_input_dialog.dart';

class StoryPreviewImage extends StatefulWidget {
  final StoryImage storyImage;
  final Function delete;

  StoryPreviewImage({this.storyImage, this.delete});

  @override
  _StoryPreviewImageState createState() => _StoryPreviewImageState();
}

class _StoryPreviewImageState extends State<StoryPreviewImage> {
  void editTime() async {
    var newTime = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => TextInputDialog(
        widget.storyImage.time,
        "Edit",
        R.color.defaultConversationColor.value,
      ),
    );
    if (newTime != null) {
      setState(() {
        widget.storyImage.time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width / 2.2;
    return SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16),
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 2 / 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      child: DynamicImage(
                        filePath: widget.storyImage.filePath,
                        assetPath: R.drawable.defaultAvatar,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: FractionalTranslation(
                      translation: Offset(0.35, -0.35),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: FloatingActionButton(
                          elevation: 1,
                          onPressed: () {
                            widget.delete();
                          },
                          heroTag: null,
                          child: Icon(
                            Icons.close,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Text(
                  widget.storyImage.time,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(),
                ),
              ),
              SizedBox(
                width: 28,
                height: 28,
                child: InkWell(
                  focusColor: null,
                  hoverColor: null,
                  splashColor: null,
                  onTap: () {
                    editTime();
                  },
                  highlightColor: null,
                  child: Icon(
                    Icons.edit,
                    size: 16,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
