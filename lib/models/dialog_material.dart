import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AddItemDialog extends StatefulWidget {
  final void Function(String txt) addItem;
  // ignore: use_key_in_widget_constructors
  const AddItemDialog(this.addItem);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  @override
  Widget build(BuildContext context) {
    SystemChannels.textInput.invokeMethod("TextInput.show");
    return AlertDialog(
      title: const Text("New Entry"),
      content: SizedBox(
        child: TextField(
          style: TextStyle(
            backgroundColor: Theme.of(context).focusColor,
          ),
          autofocus: true,
          onSubmitted: widget.addItem,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter your To-Do",
          ),
        ),
      ),
    );
  }
}
