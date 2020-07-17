import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/blue_thermal_provider.dart';
import 'package:provider/provider.dart';

class AddPhoneContactForm extends StatefulWidget {
  @override
  AddPhoneContactForm({this.number = ""});
  final String number;
  _AddPhoneContactFormState createState() => _AddPhoneContactFormState();
}

class _AddPhoneContactFormState extends State<AddPhoneContactForm> {
  final _form = GlobalKey<FormState>();
  bool isLoading = false;

  String phoneContact;

  Future<void> saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<BlueThermalProvider>(context, listen: false)
          .setEnterpriseNumber(phoneContact);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (error) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomKeyboard = MediaQuery.of(context).viewInsets.bottom;
    return SingleChildScrollView(
      child: Container(
        height: 150,
        margin: EdgeInsets.only(bottom: bottomKeyboard),
        child: Form(
            key: _form,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          style: TextStyle(fontSize: 30),
                          initialValue: widget.number,
                          decoration: InputDecoration(
                              hintText: "Numéro de téléphone",
                              prefixIcon: Icon(Icons.phone)
                              //prefixIcon: Icon(prefixIcon, size: 30),
                              ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          autofocus: true,
                          onFieldSubmitted: (_) {
                            //save form
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            if (value.contains(",") ||
                                value.contains(".") ||
                                value.contains('-')) {
                              return 'Numéro de téléphone invalide';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneContact = value;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[300],
                        ),
                        margin: EdgeInsets.all(20),
                        child: isLoading
                            ? CircularProgressIndicator()
                            : IconButton(
                                icon: Icon(
                                  Icons.save_alt,
                                  size: 30,
                                ),
                                onPressed: saveForm,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
