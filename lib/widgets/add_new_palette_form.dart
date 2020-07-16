import 'package:flutter/material.dart';

class AddNewPaletteForm extends StatefulWidget {
  final Function addPalette;
  final Function updatePalette;
  final int nombreSac;
  final double weight;
  final int index;
  final String type;
  AddNewPaletteForm(
      {@required this.addPalette,
      this.updatePalette,
      this.nombreSac,
      this.weight,
      this.index,
      this.type = "principale"});

  @override
  _AddNewPaletteFormState createState() => _AddNewPaletteFormState();
}

class _AddNewPaletteFormState extends State<AddNewPaletteForm> {
  final _formPalette = GlobalKey<FormState>();
  int nbrSac;
  double poids;

  TextEditingController sacController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    sacController.text =
        widget.nombreSac == null ? "" : widget.nombreSac.toString();
    weightController.text =
        widget.weight == null ? "" : widget.weight.toString();
    super.initState();
  }

  void saveForm() {
    if (!_formPalette.currentState.validate()) {
      return;
    }
    _formPalette.currentState.save();

    if (widget.nombreSac == null && widget.weight == null) {
      widget.addPalette(nbrSac, poids);
    } else {
      print('entred in else');
      print('${widget.index}');
      print('$nbrSac');
      print('$poids');
      widget.updatePalette(widget.index, nbrSac, poids);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomKeyboard = MediaQuery.of(context).viewInsets.bottom;
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
                          controller: sacController,
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
                            if (value.contains(",") ||
                                value.contains(".") ||
                                value.contains('-')) {
                              return 'Not a valid integer';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            nbrSac = int.parse(value);
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
                          controller: weightController,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (_) => saveForm(),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please fill this field';
                            }
                            if (value.contains('-')) {
                              return "Invalid number";
                            }
                            if (value.contains(",")) {
                              return 'Use "." instead of ","';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            poids = double.parse(value);
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
                        color: widget.type == "principale"
                            ? Colors.green[300]
                            : Colors.yellow[600],
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
