import 'package:flutter/foundation.dart';

import 'package:olivoalcazar/widgets/dynamic_textfield.dart';

class TextfieldProvider with ChangeNotifier {
  List<DynamicTextField> _textFields = [
    DynamicTextField(),
  ];

  List<DynamicTextField> get all {
    return _textFields;
  }

  void addTextfield() {
    _textFields.add(DynamicTextField());
    notifyListeners();
  }
  void addEditedTextfield(DynamicTextField field) {
    _textFields.add(field);
    //notifyListeners();
  }

  void removeTextField(int index) {
    _textFields.removeAt(index);
    notifyListeners();
  }

  void clearList() {
    _textFields.clear();
    addTextfield();
  }

  void clearallList() {
    _textFields.clear();
    //notifyListeners();

  }
}
