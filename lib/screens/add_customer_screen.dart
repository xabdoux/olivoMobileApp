import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/customer.dart';
import 'package:olivoalcazar/providers/palette.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:olivoalcazar/providers/textfield_provider.dart';
import 'package:olivoalcazar/screens/customer_details_screen.dart';
import 'package:olivoalcazar/widgets/dynamic_textfield.dart';
import 'package:provider/provider.dart';

class AddCustomerScreen extends StatelessWidget {
  //const AddCustomerScreen({Key key}) : super(key: key);
  static const routeName = '/add-customer';

  final _form = GlobalKey<FormState>();
  var initCustomer = Customer(
    id: DateTime.now().millisecond.toString(),
    fullName: '',
    phoneNumber: '',
    palettes: [],
  );
  int tour;
  List<Palette> palettes = [];
  Widget textFieldWidget(
      {BuildContext context,
      String hintText,
      TextInputType inputType = TextInputType.number,
      IconData prefixIcon,
      Function validator,
      Function onsaveHandler}) {
    return TextFormField(
      style: TextStyle(fontSize: 30),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, size: 30),
      ),
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      onFieldSubmitted: (_) {
        FocusScope.of(context).nextFocus();
      },
      validator: validator,
      onSaved: onsaveHandler,
    );
  }

  Widget backgoundDismisble() {
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red[200],
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ));
  }

  Future<bool> showConfirmeMessage(
      context, TextfieldProvider dynamicTextField) {
    if (dynamicTextField.all.length == 1) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(
                Icons.warning,
                color: Colors.red[300],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Action Denied!',
                style: TextStyle(color: Colors.red[300]),
              )
            ],
          ),
          content: Text('You can not delete all palettes'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('Ok'),
              color: Colors.blue[300],
            ),
          ],
        ),
      );
    }
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure!'),
        content: Text('Do you want to restore the Customer?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('No')),
          RaisedButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text('Yes'),
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  void saveForm(TextfieldProvider dynamicField, context) {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    for (DynamicTextField item in dynamicField.all) {
      palettes.add(
        Palette(
          id: UniqueKey().toString(),
          nombreSac: int.parse(item.sacController.text),
          poids: int.parse(item.poidsController.text),
        ),
      );
    }
    initCustomer.palettes = palettes;
    String serviceId = UniqueKey().toString();
    Provider.of<Services>(context, listen: false).addService(
        serviceId: serviceId,
        newCustomer: initCustomer,
        tour: tour,
        isPrincipale: true);

    Navigator.of(context).pushReplacementNamed(CustomerDetailsScreen.routeName,
        arguments: serviceId);
    dynamicField.clearList();
  }

  @override
  Widget build(BuildContext context) {
    final dynamicField = Provider.of<TextfieldProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: dynamicField.addTextfield,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Add New Customer'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () => saveForm(dynamicField, context))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              textFieldWidget(
                  hintText: 'Name',
                  inputType: TextInputType.text,
                  prefixIcon: Icons.account_circle,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                  onsaveHandler: (value) {
                    initCustomer = Customer(
                        id: initCustomer.id,
                        fullName: value,
                        phoneNumber: initCustomer.phoneNumber,
                        palettes: initCustomer.palettes);
                  }),
              SizedBox(
                height: 20,
              ),
              textFieldWidget(
                  hintText: 'Phone number',
                  prefixIcon: Icons.phone,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                  onsaveHandler: (value) {
                    initCustomer = Customer(
                        id: initCustomer.id,
                        fullName: initCustomer.fullName,
                        phoneNumber: value,
                        palettes: initCustomer.palettes);
                  }),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                    width: 200,
                    child: textFieldWidget(
                      hintText: 'Tour',
                      prefixIcon: Icons.supervised_user_circle,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please fill this field';
                        }
                        return null;
                      },
                      onsaveHandler: (value) {
                        tour = int.parse(value);
                      },
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Sac', style: TextStyle(fontSize: 30)),
                  Text('Poids', style: TextStyle(fontSize: 30)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Consumer<TextfieldProvider>(
                builder: (_, dynamicTextField, d) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dynamicTextField.all.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: <Widget>[
                        Flexible(
                          flex: 5,
                          child: Dismissible(
                            key: UniqueKey(),
                            background: backgoundDismisble(),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) =>
                                dynamicTextField.removeTextField(index),
                            confirmDismiss: (direction) {
                              return showConfirmeMessage(context, dynamicField);
                            },
                            child: dynamicTextField.all[index],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
