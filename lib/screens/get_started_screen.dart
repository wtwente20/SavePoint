import 'package:flutter/material.dart';

import '../services/data_service.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  _GetStartedScreenState createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final DataService _dataService = DataService();
  int _currentPage = 0;
  bool dontShowAgain = false;
  final _pageController = PageController();

  final List<Map<String, Object>> slideData = [
    {
      "title": "CATEGORIES",
      "description":
          "Add or swipe left to delete categories. Default categories include Video Games, Books, and Tabletop RPGs.",
      "color": Colors.blue,
    },
    {
      "title": "TITLES",
      "description":
          "Swipe right to delete a title. Everything within the corresponding folders will be deleted.",
      "color": Colors.red,
    },
    {
      "title": "ENTRIES",
      "description": "Edit or delete entries within titles.",
      "color": Colors.green,
    },
  ];

  void onDonePress() async {
  if (dontShowAgain) {
    // Save the preference in Firebase RTD (I'm assuming you have access to _dataService here)
    await _dataService.setShowGetStartedPopup(false);
  }
  // Go back to the main screen
  Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Get Started"),
        actions: [
          if (_currentPage == slideData.length - 1)
            TextButton(
              onPressed: onDonePress,
              child: const Text("Done"),
            )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: slideData.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (ctx, index) => Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slideData[index]['title'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      slideData[index]['description'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_currentPage == slideData.length - 1)
            CheckboxListTile(
              title: const Text("Don't show me again"),
              value: dontShowAgain,
              onChanged: (bool? value) {
                setState(() {
                  dontShowAgain = value!;
                });
              },
            )
        ],
      ),
    );
  }
}

