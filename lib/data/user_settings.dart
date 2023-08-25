class UserSettings {
  final bool showGetStartedPopup;

  UserSettings({
    required this.showGetStartedPopup,
  });

  // Convert UserSettings to JSON
  Map<String, dynamic> toJson() => {
        'showGetStartedPopup': showGetStartedPopup,
      };

  // Convert JSON to UserSettings
  static UserSettings fromJson(Map<String, dynamic> json) => UserSettings(
        showGetStartedPopup: json['showGetStartedPopup'] ?? true,
      );
}
