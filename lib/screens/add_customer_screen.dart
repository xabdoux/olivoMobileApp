import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/customer.dart';
import 'package:olivoalcazar/providers/palette.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:olivoalcazar/providers/textfield_provider.dart';
import 'package:olivoalcazar/screens/customer_details_screen.dart';
import 'package:olivoalcazar/widgets/dynamic_textfield.dart';
import 'package:provider/provider.dart';
import 'package:olivoalcazar/widgets/add_new_palette_form.dart';
import 'package:olivoalcazar/widgets/show_total_infos_add.dart';
import 'package:olivoalcazar/widgets/palette_item.dart';

class AddCustomerScreen extends StatefulWidget {
  static const routeName = '/add-customer';

  @override
  _AddCustomerScreenState createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  var _isLoading = false;

  final _form = GlobalKey<FormState>();

  var initCustomer = Customer(
    id: DateTime.now().millisecond.toString(),
    fullName: '',
    phoneNumber: '',
    palettes: [],
  );

  int tour;
  List<Palette> palettes = [];

  void _addPalette(int sac, double weight) {
    setState(() {
      palettes.add(Palette(nombreSac: sac, poids: weight));
    });
    print(palettes.length);
  }

  int getTotalSac() {
    return palettes.fold(
        0, (totalSac, palette) => totalSac += palette.nombreSac);
  }

  double getTotalWeight() {
    return palettes.fold(
        0, (totalWeight, palette) => totalWeight += palette.poids);
  }

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
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red[200],
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ));
  }

  Future<bool> showConfirmeMessage(
      context, TextfieldProvider dynamicTextField, int index) async {
    final confirm = await showDialog(
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
    return confirm;
  }

  Future<void> saveForm(TextfieldProvider dynamicField, context) async {
    if (palettes.length < 1) {
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
          content: Text('Minimum one palette required!'),
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
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    // for (DynamicTextField item in dynamicField.all) {
    //   palettes.add(
    //     Palette(
    //       nombreSac: int.parse(item.sacController.text),
    //       poids: double.parse(item.poidsController.text),
    //     ),
    //   );
    // }
    initCustomer.palettes = palettes;
    try {
      setState(() {
        _isLoading = true;
      });
      final newServiceId =
          await Provider.of<Services>(context, listen: false).addService(
        newCustomer: initCustomer,
        tour: tour,
      );

      Navigator.of(context).pushReplacementNamed(
          CustomerDetailsScreen.routeName,
          arguments: newServiceId.toString());
      dynamicField.clearList();
    } catch (error) {
      showDialog<void>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Somthing went wrong'),
              content: Text(error),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okey'))
              ],
            );
          });
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addNewPalette(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return AddNewPaletteForm(_addPalette);
        });
  }

  @override
  Widget build(BuildContext context) {
    final dynamicField = Provider.of<TextfieldProvider>(context, listen: false);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => addNewPalette(context),
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _form,
                  child: SingleChildScrollView(
                    child: Column(
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
                        ShowTotalInfosAdd(
                          totalSac: getTotalSac(),
                          totalWeight: getTotalWeight(),
                          totalPalettes: palettes.length,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: palettes.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
                              children: <Widget>[
                                Flexible(
                                  flex: 5,
                                  child: Dismissible(
                                    key: UniqueKey(),
                                    background: backgoundDismisble(),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) async {
                                      setState(() {
                                        palettes.removeAt(index);
                                      });
                                    },
                                    confirmDismiss: (direction) async {
                                      return showConfirmeMessage(
                                          context, dynamicField, index);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        PalettesItem(
                                            index,
                                            palettes[index].nombreSac,
                                            palettes[index].poids)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
        ));
  }
}
