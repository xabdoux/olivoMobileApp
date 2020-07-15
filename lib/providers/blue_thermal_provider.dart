import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:system_setting/system_setting.dart';

import '../providers/service.dart';

class BlueThermalProvider with ChangeNotifier {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  //TestPrint testPrint;

  void setDevice(BluetoothDevice device) {
    _device = device;
    notifyListeners();
  }

  bool get isPathImageEmpty {
    if (pathImage == null) {
      return true;
    }
    return false;
  }

  Future<bool> get getState {
    return bluetooth.isOn;
  }

  Future<void> isBluetoothActivated(GlobalKey<ScaffoldState> key) async {
    bool bluetoothIsActivated = await bluetooth.isOn;
    if (!bluetoothIsActivated) {
      SystemSetting.goto(SettingTarget.BLUETOOTH);
    }
  }

  BluetoothDevice get selectedDevice {
    return _device;
  }

  bool get isConnected {
    return _connected;
  }

  List<BluetoothDevice> get devices {
    return _devices;
  }

  List<DropdownMenuItem<BluetoothDevice>> get getDeviceItems {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name),
          value: device,
        ));
      });
    }
    return items;
  }

  Future<void> connect(GlobalKey<ScaffoldState> key) async {
    if (_device == null) {
      show('No device selected.', key);
    } else {
      await bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          try {
            await bluetooth.connect(_device);
            _connected = true;
          } catch (error) {
            _connected = false;
            throw ('Error connect to printer');
          }
        }
      });
    }
    notifyListeners();
  }

  void disconnect(GlobalKey<ScaffoldState> key) {
    bluetooth.isConnected.then((isConnected) {
      print('connected');
      print(isConnected);
      if (isConnected) {
        bluetooth.disconnect().catchError((error) {
          print('disconnect error');
          _connected = true;
          show('Error disconnect', key);
        });
        _connected = false;
      } else {
        _connected = false;
      }
    });

    notifyListeners();
  }

  Future show(
    String message,
    GlobalKey<ScaffoldState> key, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await Future.delayed(Duration(milliseconds: 100));
    key.currentState.removeCurrentSnackBar();
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'new_logo.png';
    var bytes = await rootBundle.load("assets/images/new_logo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');

    pathImage = '$dir/$filename';
    notifyListeners();
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<void> initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          _connected = true;

          break;
        case BlueThermalPrinter.DISCONNECTED:
          _connected = false;

          break;
        default:
          print(state);
          break;
      }
      notifyListeners();
    });

    //if (!mounted) return;

    _devices = devices;

    if (isConnected) {
      _connected = true;
    }
    notifyListeners();
  }

  //SIZE
  Future<void> sampleTicket(GlobalKey<ScaffoldState> key) async {
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        try {
          await bluetooth.printNewLine();
        } catch (error) {
          throw "error printing";
        }
      } else {
        print('not connected');
        key.currentState.removeCurrentSnackBar();
        key.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Not connected to the printer",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });
  }

//SIZE
// 0- normal size text
// 1- only bold text
// 2- bold with medium text
// 3- bold with large text
//ALIGN
// 0- ESC_ALIGN_LEFT
// 1- ESC_ALIGN_CENTER
// 2- ESC_ALIGN_RIGHT
  printTicket(
    Service service,
    int totalSac,
    double totalPoids,
  ) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImage(pathImage); //path of your image/new_logo
        bluetooth.printNewLine();
        bluetooth.printCustom('06 44 87 17 99', 1, 1);
        bluetooth.printCustom('--------------', 1, 1);
        bluetooth.printNewLine();

        var date = DateFormat('dd/MM/yyyy').format(service.createdAt);
        var time = DateFormat('hh:mm').format(service.createdAt);
        bluetooth.printLeftRight(date, time, 1);
        bluetooth.printCustom(service.tour.toString(), 2, 1);
        bluetooth.printNewLine();
        bluetooth.printCustom(service.customer.fullName.toString(), 1, 1);
        bluetooth.printLeftRight('Sac', 'Poids', 1);
        bluetooth.printLeftRight('---', '-----', 1);
        for (var item in service.customer.palettes) {
          bluetooth.printLeftRight('${item.nombreSac}', '${item.poids}', 1);
        }
        bluetooth.printCustom('_____________________________', 1, 1);
        bluetooth.printLeftRight("$totalSac Sac", "$totalPoids Kg", 1);
        bluetooth.printNewLine();
        bluetooth.printCustom('${totalPoids / 2} DH', 2, 1);
        bluetooth.printQRcode('text', 150, 150, 1);
        bluetooth.printCustom('# 234534 43', 0, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }
}
