import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:olivoalcazar/widgets/add_phone_contact_form.dart';
import 'package:provider/provider.dart';

import '../providers/blue_thermal_provider.dart';
import '../widgets/main_drawer.dart';

class BlueThermalScreen extends StatefulWidget {
  static const routeName = '/blue-thermal';
  @override
  _BlueThermalScreenState createState() => new _BlueThermalScreenState();
}

class _BlueThermalScreenState extends State<BlueThermalScreen> {
  bool init = true;
  var _key = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (init) {
      final blueThermal =
          Provider.of<BlueThermalProvider>(context, listen: false);
      blueThermal.initPlatformState();
      blueThermal.initSavetoPath();
      blueThermal.initEnterpriseNumber();
      init = false;
    }
    super.didChangeDependencies();
  }

  void showPhoneNumberForm(BuildContext ctx, {String number = ""}) {
    showModalBottomSheet(
        context: ctx,
        builder: (bCtx) {
          return AddPhoneContactForm(number: number);
        });
  }

  @override
  Widget build(BuildContext context) {
    final blueThermal = Provider.of<BlueThermalProvider>(context, listen: true);
    final entrepriseNumber = blueThermal.enterpriseNumber;
    final BluetoothDevice selectedDevice = blueThermal.selectedDevice;
    print(blueThermal.isConnected);
    return Scaffold(
      key: _key,
      drawer: MainDrawer(),
      appBar: GradientAppBar(
        gradient: LinearGradient(
          colors: [Colors.green[400], Color(0xff0f3443)],
          stops: [0, 0.8],
        ),
        title: Text('Blue Thermal Printer'),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Device:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: DropdownButton(
                      items: blueThermal.getDeviceItems,
                      onChanged: (value) => blueThermal.setDevice(value),
                      value: selectedDevice,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.grey,
                    onPressed: () {
                      blueThermal.isBluetoothActivated(_key);
                      blueThermal.initPlatformState();
                    },
                    child: Text(
                      'Refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          color: blueThermal.isConnected
                              ? Colors.red
                              : Colors.green[400],
                          onPressed: blueThermal.isConnected
                              ? () => blueThermal.disconnect(_key)
                              : () async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await blueThermal.connect(_key);
                                  } catch (error) {
                                    _key.currentState.removeCurrentSnackBar();
                                    _key.currentState.showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          error,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                },
                          child: Text(
                            blueThermal.isConnected ? 'Disconnect' : 'Connect',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 50),
                child: RaisedButton(
                  color: Color(0xff0f3443),
                  onPressed: selectedDevice != null
                      ? () async {
                          try {
                            await blueThermal.sampleTicket(_key);
                          } catch (error) {}
                        }
                      : null,
                  child:
                      Text('PRINT TEST', style: TextStyle(color: Colors.white)),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(
                  Icons.phone,
                  size: 30,
                ),
                title: Text(entrepriseNumber == ""
                    ? 'Add an enterprise contact number'
                    : "Enterprise contact number"),
                subtitle: Text(entrepriseNumber == ""
                    ? "Click 'add' botton to add contact number"
                    : entrepriseNumber),
                trailing: entrepriseNumber == ""
                    ? IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => showPhoneNumberForm(context),
                      )
                    : IconButton(
                        icon: Icon(Icons.update),
                        onPressed: () => showPhoneNumberForm(context,
                            number: entrepriseNumber),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
