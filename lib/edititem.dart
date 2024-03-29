import 'package:flutter/material.dart';

class EditItemPage extends StatelessWidget {
  final String initialTitle;
  final String initialBody;

  const EditItemPage({
    super.key,
    required this.initialTitle,
    required this.initialBody,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController =
        TextEditingController(text: initialTitle);
    final TextEditingController bodyController =
        TextEditingController(text: initialBody);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              // minLines: 5,
              // maxLines: 8,
              controller: titleController,
            ),
            const Spacer(
              flex: 1,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              minLines: 5,
              maxLines: 8,
              controller: bodyController,
            ),
            const Spacer(
              flex: 5,
            ),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final body = bodyController.text;
                Navigator.pop(context, {'title': title, 'body': body});
              },
              child: const Text('Update'),
            ),
            const Spacer(
              flex: 75,
            ),
          ],
        ),
      ),
    );
  }
}
