import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  static final _formKey = GlobalKey<FormState>();

  final String _currentContent;
  final String _title;
  final int _color;
  final bool nullable;

  TextInputDialog(this._currentContent, this._title, this._color,
      {this.nullable = false});

  @override
  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  final _contentController = new TextEditingController();

  @override
  void initState() {
    _contentController.text = widget._currentContent;
    _contentController.selection = TextSelection(
        baseOffset: 0, extentOffset: widget._currentContent.length);
    super.initState();
  }

  void _updateMessageContent(BuildContext context) {
    if (TextInputDialog._formKey.currentState.validate()) {
      Navigator.of(context).pop(_contentController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          title: Text(widget._title),
          content: Form(
            key: TextInputDialog._formKey,
            child: TextFormField(
              controller: _contentController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(widget._color),
                  ),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(widget._color),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(widget._color),
                  ),
                ),
                disabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(widget._color),
                  ),
                ),
              ),
              validator: (value) {
                String result;
                if (!widget.nullable && value.trim().isEmpty) {
                  result = "This field cannot be empty";
                }
                return result;
              },
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: new Text(
                "Save".toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(widget._color)),
              ),
              onPressed: () {
                _updateMessageContent(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
