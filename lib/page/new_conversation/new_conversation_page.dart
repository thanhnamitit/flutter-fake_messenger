import 'dart:io';

import 'package:conversation_maker/core/util/image_picker_utils.dart';
import 'package:conversation_maker/di/provider/view_model_provider.dart';
import 'package:conversation_maker/page/new_conversation/new_conversation_view_model.dart';
import 'package:conversation_maker/widget/clipper/bottom_wave_clipper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewConversationPage extends StatefulWidget {
  @override
  _NewConversationPageState createState() => _NewConversationPageState();
}

class _NewConversationPageState extends State<NewConversationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  void _save(BuildContext context) {
    if (_formKey.currentState.validate()) {
      Provider.of<NewConversationViewModel>(context)
          .saveConversation(_nameController.text)
          .then((it) {
        Navigator.of(context).pop(it);
      });
    }
  }

  Widget _buildBackground() {
    return ClipPath(
      clipper: BottomWaveClipper(),
      child: AspectRatio(
          aspectRatio: 6 / 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                // Where the linear gradient begins and ends
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                // Add one stop for each color. Stops should increase from 0 to 1
                stops: [0.1, 0.5, 0.7, 0.9],
                colors: [
                  // Colors are easy thanks to Flutter's Colors class.
                  Colors.indigo[800],
                  Colors.indigo[700],
                  Colors.indigo[600],
                  Colors.indigo[400],
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildInput() {
    return Consumer<NewConversationViewModel>(
        builder: (context, viewModel, __) {
      var avatarFilePath = viewModel.conversation.avatar;
      return Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 32, right: 32, top: 42, bottom: 42),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "New conversation",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: CircleAvatar(
                      backgroundColor: Colors.white10,
                      backgroundImage: avatarFilePath == null
                          ? AssetImage("assets/img_default_avatar.jpg")
                          : FileImage(File(avatarFilePath)),
                      child: SizedBox(
                          height: 72,
                          width: 72,
                          child: FloatingActionButton(
                              backgroundColor: Colors.black.withOpacity(.1),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white.withOpacity(.5),
                              ),
                              onPressed: () {
                                _pickAvatar(context);
                              })),
                    ),
                  ),
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _nameController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        String result;
                        if (value.trim().isEmpty) {
                          result = "This field cannot be empty";
                        }
                        return result;
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          labelText: "Name",
                          hintText: "Enter your friend name..."),
                    ),
                  ),
                  SizedBox(height: 32),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    padding: EdgeInsets.symmetric(horizontal: 48),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _save(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future _pickAvatar(BuildContext context) async {
    var pickedPath = await ImagePickerUtils.pickImageWithCropper();
    if (pickedPath != null) {
      print("File path: $pickedPath");
      Provider.of<NewConversationViewModel>(context).updateAvatar(pickedPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    ViewModelProvider viewModelProvider =
        Provider.of<ViewModelProvider>(context);
    return ChangeNotifierProvider<NewConversationViewModel>(
      builder: (context) => viewModelProvider.newConversationViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[_buildBackground(), _buildInput()],
        ),
      ),
    );
  }
}
