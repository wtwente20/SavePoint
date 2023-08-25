import 'package:flutter/material.dart';

class AddTitleButton extends StatelessWidget {
  final VoidCallback onAddTitle;

  const AddTitleButton({super.key, required this.onAddTitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.add_box, color: Colors.green),
      title: const Text(
        'Add Title',
        style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold),
      ),
      onTap: onAddTitle,
    );
  }
}
