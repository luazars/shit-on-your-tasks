import "package:flutter/material.dart";

class SingleEntry extends StatelessWidget {
  final String _title;
  final bool _done;

  const SingleEntry(this._title, this._done, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 500,
              child: ListTile(
                leading: Checkbox(
                  value: _done,
                  onChanged: (bool? value) {
                    null;
                  },
                ),
                title: Text(_title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline_rounded),
                  onPressed: () => null,
                  color: Colors.red,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).cardColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
