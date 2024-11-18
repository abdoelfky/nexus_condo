// Constants
const double iconSize = 120.0; // Size for the logo display
const double iconSizeDefault = 25.0; // Size for the logo display
const double containerWidth = 300.0; // Width for the blurred container
const double paddingVertical = 40.0; // Vertical padding for layout spacing
const double headerTextFontSize = 16.0;
//enums
enum UserType {
  store,
  customer,
  admin,
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.store:
        return 'store';
      case UserType.customer:
        return 'customer';
      case UserType.admin:
        return 'admin';
    }
  }
}
