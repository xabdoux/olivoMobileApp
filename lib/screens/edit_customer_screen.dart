import 'package:flutter/material.dart';
import '../providers/customer.dart';
import '../providers/palette.dart';
import '../providers/service.dart';
import '../providers/services.dart';
import '../providers/textfield_provider.dart';
import '../widgets/dynamic_textfield.dart';
import 'package:provider/provider.dart';

class EditCustomerScreen extends StatefulWidget {
  static const routeName = '/edit-customer';

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  bool isInit = true;
  Service serviceInstance;
  TextfieldProvider dynamicField;
  Service initService;
  Customer initCustomer;
  String serviceId;
  var _isLoading = false;
  void toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void didChangeDependencies() {
    if (isInit) {
      dynamicField = Provider.of<TextfieldProvider>(context, listen: false);
      dynamicField.clearallList();
      serviceId = ModalRoute.of(context).settings.arguments;

      serviceInstance = Provider.of<Services>(context, listen: false)
          .principaleServices
          .firstWhere((element) => element.id == serviceId);
      initService = serviceInstance;
      initCustomer = serviceInstance.customer;
      for (var item in serviceInstance.customer.palettes) {
        var field = DynamicTextField();
        field.sacController.text = item.nombreSac.toString();
        field.poidsController.text = item.poids.toString();
        dynamicField.addEditedTextfield(field);
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //dynamicField.clearList();
    super.dispose();
  }

  final _form = GlobalKey<FormState>();

  int tour;

  List<Palette> palettes = [];

  Widget textFieldWidget(
      {BuildContext context,
      String hintText,
      String initialValue,
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
      initialValue: initialValue,
      textInputAction: TextInputAction.next,
      keyboardType: inputType,
      onFieldSubmitted: (value) {
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

  Future<void> saveForm(TextfieldProvider dynamicField, context) async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    for (DynamicTextField item in dynamicField.all) {
      palettes.add(
        Palette(
          //id: UniqueKey().toString(),
          nombreSac: int.parse(item.sacController.text),
          poids: double.parse(item.poidsController.text),
        ),
      );
    }
    initCustomer.palettes = palettes;
    initService.customer = initCustomer;
    //String serviceId = UniqueKey().toString();
    toggleLoading();
    await Provider.of<Services>(context, listen: false).updateService(
      serviceId.toString(),
      initService,
    );
    toggleLoading();
    // Navigator.of(context).pushReplacementNamed(CustomerDetailsScreen.routeName,
    //     arguments: serviceId);
    dynamicField.clearList();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: dynamicField.addTextfield,
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Edit Service'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () => saveForm(dynamicField, context)),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    textFieldWidget(
                        hintText: 'Name',
                        inputType: TextInputType.text,
                        prefixIcon: Icons.account_circle,
                        initialValue: serviceInstance.customer.fullName,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                        onsaveHandler: (value) {
                          initCustomer = Customer(
                            fullName: value,
                            id: initCustomer.id,
                            phoneNumber: initCustomer.phoneNumber,
                            palettes: initCustomer.palettes,
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    textFieldWidget(
                        hintText: 'Phone number',
                        initialValue: serviceInstance.customer.phoneNumber,
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                        onsaveHandler: (value) {
                          initCustomer = Customer(
                            fullName: initCustomer.fullName,
                            id: initCustomer.id,
                            phoneNumber: value,
                            palettes: initCustomer.palettes,
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Container(
                          width: 200,
                          child: textFieldWidget(
                            hintText: 'Tour',
                            initialValue: serviceInstance.tour.toString(),
                            prefixIcon: Icons.supervised_user_circle,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please fill this field';
                              }
                              return null;
                            },
                            onsaveHandler: (String value) {
                              initService = Service(
                                createdAt: initService.createdAt,
                                id: initService.id,
                                customer: initService.customer,
                                tour: int.parse(value),
                              );
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
                                    return showConfirmeMessage(
                                        context, dynamicField);
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
                _isLoading
                    ? Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black45,
                          ),
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Center()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
