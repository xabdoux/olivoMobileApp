import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import '../providers/customer.dart';
import '../providers/palette.dart';
import '../providers/services.dart';
import '../widgets/add_new_palette_form.dart';
import '../widgets/show_total_infos_add.dart';
import '../widgets/palette_item.dart';
import 'awaiting_customer_detailsScreen.dart';

class AddAwaitingCustomerScreen extends StatefulWidget {
  static const routeName = '/add-awaiting-customer';

  @override
  _AddAwaitingCustomerScreenState createState() =>
      _AddAwaitingCustomerScreenState();
}

class _AddAwaitingCustomerScreenState extends State<AddAwaitingCustomerScreen> {
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
  }

  void _updatePalette(int index, int sac, double weight) {
    setState(() {
      palettes[index] = Palette(nombreSac: sac, poids: weight);
    });
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
      Function onsaveHandler,
      bool autoFocus,
      TextInputAction inputAction,
      FocusNode focusNode,
      Function onfieldSubmited}) {
    return TextFormField(
      style: TextStyle(fontSize: 30),
      autofocus: autoFocus,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, size: 30),
      ),
      textInputAction: inputAction,
      keyboardType: inputType,
      focusNode: focusNode,
      onFieldSubmitted: onfieldSubmited,
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

  Future<bool> showConfirmeMessage(context, int index) async {
    final confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Êtes-vous sûr!'),
        content: Text('Voulez-vous supprimer le client?'),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(ctx).pop(false);
              },
              child: Text('Non')),
          RaisedButton(
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
            child: Text('Oui'),
            color: Colors.red,
          ),
        ],
      ),
    );
    return confirm;
  }

  Future<void> saveForm(context) async {
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
                'Action refusée!',
                style: TextStyle(color: Colors.red[300]),
              )
            ],
          ),
          content: Text('Au moins une palette requise!'),
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

    initCustomer.palettes = palettes;
    try {
      setState(() {
        _isLoading = true;
      });
      final newServiceId = await Provider.of<Services>(context, listen: false)
          .addService(newCustomer: initCustomer, tour: tour, type: "attente");

      Navigator.of(context).pushReplacementNamed(
          AwaitingCustmerDetailsScreen.routeName,
          arguments: newServiceId.toString());
    } catch (error) {
      showDialog<void>(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Oops! il y a eu un problème'),
              content: Text(error),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Ok'))
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
          return AddNewPaletteForm(
            addPalette: _addPalette,
            type: "awaiting",
          );
        });
  }

  void updatePaletteForm(
      BuildContext ctx, int nombreSac, double weight, int index) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return AddNewPaletteForm(
            addPalette: _addPalette,
            updatePalette: _updatePalette,
            nombreSac: nombreSac,
            weight: weight,
            index: index,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow[600],
          onPressed: () => addNewPalette(context),
          child: Icon(Icons.add),
        ),
        appBar: GradientAppBar(
          gradient: LinearGradient(
            colors: [Colors.green[400], Color(0xff0f3443)],
            stops: [0, 0.8],
          ),
          title: Text('Nouveau client en attente'),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.save), onPressed: () => saveForm(context))
          ],
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _form,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      textFieldWidget(
                          hintText: 'Nom',
                          autoFocus: true,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          prefixIcon: Icons.account_circle,
                          onfieldSubmited: (_) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Veuillez remplir ce champ';
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
                          hintText: 'Numéro de téléphone',
                          autoFocus: false,
                          focusNode: null,
                          inputAction: TextInputAction.done,
                          prefixIcon: Icons.phone,
                          onfieldSubmited: (_) {
                            // phoneFocusNode.unfocus();
                            // FocusScope.of(context).requestFocus(tourFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Veuillez remplir ce champ';
                            }
                            if (value.contains('.') ||
                                value.contains(',') ||
                                value.contains('-')) {
                              return "Entier invalide";
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
                              autoFocus: false,
                              focusNode: null,
                              inputAction: TextInputAction.done,
                              prefixIcon: Icons.supervised_user_circle,
                              onfieldSubmited: (_) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Veuillez remplir ce champ';
                                }
                                if (value.contains('.') ||
                                    value.contains(',') ||
                                    value.contains('-')) {
                                  return "Entier invalide";
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
                                  onDismissed: (_) {
                                    setState(() {
                                      palettes.removeAt(index);
                                    });
                                  },
                                  confirmDismiss: (direction) async {
                                    return showConfirmeMessage(context, index);
                                  },
                                  child: InkWell(
                                    onLongPress: () {
                                      return updatePaletteForm(
                                          context,
                                          palettes[index].nombreSac,
                                          palettes[index].poids,
                                          index);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        PalettesItem(
                                          index,
                                          palettes[index].nombreSac,
                                          palettes[index].poids,
                                          type: "awaiting",
                                        )
                                      ],
                                    ),
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
        ));
  }
}
