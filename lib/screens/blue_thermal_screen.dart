import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:olivoalcazar/providers/blue_thermal_provider.dart';
import 'package:olivoalcazar/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class BlueThermalScreen extends StatefulWidget {
  static const routeName = '/blue-thermal';
  @override
  _BlueThermalScreenState createState() => new _BlueThermalScreenState();
}

class _BlueThermalScreenState extends State<BlueThermalScreen> {
  bool init = true;
  var _key = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    if (init) {
      final blueThermal = Provider.of<BlueThermalProvider>(context);
      blueThermal.initPlatformState();
      blueThermal.initSavetoPath();
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final blueThermal = Provider.of<BlueThermalProvider>(context, listen: true);
    final BluetoothDevice selectedDevice = blueThermal.selectedDevice;
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
                      value: blueThermal.selectedDevice,
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
                  RaisedButton(
                    color: blueThermal.isConnected
                        ? Colors.red
                        : Colors.green[400],
                    onPressed: blueThermal.isConnected
                        ? () => blueThermal.disconnect()
                        : () => blueThermal.connect(context),
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
                      ? () {
                          blueThermal.sampleTicket();
                        }
                      : null,
                  child:
                      Text('PRINT TEST', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
