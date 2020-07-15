import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:provider/provider.dart';

import '../providers/palette.dart';
import '../providers/services.dart';
import '../widgets/add_new_palette_form.dart';
import '../widgets/show_total_infos_add.dart';
import '../widgets/palette_item.dart';
import '../providers/service.dart';

class EditCustomerScreen extends StatefulWidget {
  static const routeName = '/edit-customer';

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends State<EditCustomerScreen> {
  var _isLoading = false;

  final _form = GlobalKey<FormState>();

  bool isInit = true;
  Service initService;
  String serviceId;

  void didChangeDependencies() {
    if (isInit) {
      serviceId = ModalRoute.of(context).settings.arguments;
      initService = Provider.of<Services>(context, listen: false)
          .principaleServices
          .firstWhere((element) => element.id == serviceId);
    }
    isInit = false;
    super.didChangeDependencies();
  }

  void _addPalette(int sac, double weight) {
    setState(() {
      initService.customer.palettes.add(Palette(nombreSac: sac, poids: weight));
    });
  }

  void _updatePalette(int index, int sac, double weight) {
    setState(() {
      initService.customer.palettes[index] =
          Palette(nombreSac: sac, poids: weight);
    });
  }

  int getTotalSac() {
    return initService.customer.palettes
        .fold(0, (totalSac, palette) => totalSac += palette.nombreSac);
  }

  double getTotalWeight() {
    return initService.customer.palettes
        .fold(0, (totalWeight, palette) => totalWeight += palette.poids);
  }

  Widget textFieldWidget(
      {BuildContext context,
      String hintText,
      String initialvalue,
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
      initialValue: initialvalue,
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
        title: Text('Are you sure!'),
        content: Text('Do you want to delete the Customer?'),
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

  Future<void> saveForm(context) async {
    if (initService.customer.palettes.length < 1) {
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

    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Services>(context, listen: false).updateService(
        serviceId.toString(),
        initService,
      );
      Navigator.of(context).pop();
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
          return AddNewPaletteForm(addPalette: _addPalette);
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
          onPressed: () => addNewPalette(context),
          child: Icon(Icons.add),
        ),
        appBar: GradientAppBar(
          gradient: LinearGradient(
            colors: [Colors.green[400], Color(0xff0f3443)],
            stops: [0, 0.8],
          ),
          title: Text('Add New Customer'),
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
                          hintText: 'Name',
                          initialvalue: "${initService.customer.fullName}",
                          autoFocus: false,
                          inputType: TextInputType.text,
                          inputAction: TextInputAction.done,
                          prefixIcon: Icons.account_circle,
                          onfieldSubmited: (_) {},
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this field';
                            }

                            return null;
                          },
                          onsaveHandler: (value) {
                            initService.customer.fullName = value;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      textFieldWidget(
                          hintText: 'Phone number',
                          initialvalue: "${initService.customer.phoneNumber}",
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
                              return 'Please fill this field';
                            }
                            if (value.contains('.') ||
                                value.contains(',') ||
                                value.contains('-')) {
                              return "Invalid integer";
                            }
                            return null;
                          },
                          onsaveHandler: (value) {
                            initService.customer.phoneNumber = value;
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                            width: 200,
                            child: textFieldWidget(
                              hintText: 'Tour',
                              initialvalue: "${initService.tour}",
                              autoFocus: false,
                              focusNode: null,
                              inputAction: TextInputAction.done,
                              prefixIcon: Icons.supervised_user_circle,
                              onfieldSubmited: (_) {},
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                if (value.contains('.') ||
                                    value.contains(',') ||
                                    value.contains('-')) {
                                  return "Invalid integer";
                                }
                                return null;
                              },
                              onsaveHandler: (value) {
                                initService.tour = int.parse(value);
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
                        totalPalettes: initService.customer.palettes.length,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: initService.customer.palettes.length,
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
                                      initService.customer.palettes
                                          .removeAt(index);
                                    });
                                  },
                                  confirmDismiss: (direction) async {
                                    return showConfirmeMessage(context, index);
                                  },
                                  child: InkWell(
                                    onLongPress: () {
                                      return updatePaletteForm(
                                          context,
                                          initService.customer.palettes[index]
                                              .nombreSac,
                                          initService
                                              .customer.palettes[index].poids,
                                          index);
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        PalettesItem(
                                            index,
                                            initService.customer.palettes[index]
                                                .nombreSac,
                                            initService
                                                .customer.palettes[index].poids)
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
