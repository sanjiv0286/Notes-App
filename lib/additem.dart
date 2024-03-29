import 'package:flutter/material.dart';

class AddItemPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  AddItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // const Spacer(flex: 10),
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
            const Spacer(flex: 5),
            ElevatedButton(
              onPressed: () {
                final title = titleController.text;
                final body = bodyController.text;
                Navigator.pop(context, {'title': title, 'body': body});
              },
              child: const Text('Submit'),
            ),
            const Spacer(flex: 75),
          ],
        ),
      ),
    );
  }
}
