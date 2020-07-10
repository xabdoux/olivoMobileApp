import 'package:flutter/material.dart';

class AddNewPaletteForm extends StatefulWidget {
  Function addPalette;
  AddNewPaletteForm(this.addPalette);

  @override
  _AddNewPaletteFormState createState() => _AddNewPaletteFormState();
}

class _AddNewPaletteFormState extends State<AddNewPaletteForm> {
  final _formPalette = GlobalKey<FormState>();
  var sac;
  var weight;

  void saveForm() {
    if (!_formPalette.currentState.validate()) {
      return;
    }
    _formPalette.currentState.save();

    widget.addPalette(sac, weight);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomKeyboard = MediaQuery.of(context).viewInsets.bottom;
    print(bottomKeyboard);
    return SingleChildScrollView(
      child: Container(
        height: 300,
        margin: EdgeInsets.only(bottom: bottomKeyboard),
        child: Form(
            key: _formPalette,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          decoration: InputDecoration(
                              hintText: "Sac",
                              suffixIcon: Image.asset(
                                "assets/images/sacks.png",
                                width: 1,
                              )
                              //prefixIcon: Icon(prefixIcon, size: 30),
                              ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            sac = int.parse(value);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          decoration: InputDecoration(
                            hintText: "Weight",
                            suffixIcon: Image.asset(
                              "assets/images/measure.png",
                              width: 5,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            weight = double.parse(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green[300],
                      ),
                      margin: EdgeInsets.all(20),
                      child: IconButton(
                        icon: Icon(
                          Icons.save_alt,
                          size: 30,
                        ),
                        onPressed: saveForm,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
