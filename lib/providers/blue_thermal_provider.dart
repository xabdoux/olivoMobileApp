import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:system_setting/system_setting.dart';

import '../providers/service.dart';

class BlueThermalProvider with ChangeNotifier {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice _device;
  bool _connected = false;
  String pathImage;
  String awaitPathImage;
  String _enterpriseNumber = "";
  //TestPrint testPrint;

  String get enterpriseNumber {
    return _enterpriseNumber;
  }

  Future<void> initEnterpriseNumber() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('enterpriseNumber')) {
      _enterpriseNumber = '';
    } else {
      _enterpriseNumber = prefs.getString('enterpriseNumber');
    }
    notifyListeners();
  }

  Future<void> setEnterpriseNumber(String number) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('enterpriseNumber', number);
      _enterpriseNumber = prefs.getString('enterpriseNumber');
      notifyListeners();
    } catch (error) {}
  }

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
        child: Text('AUCUN'),
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
      show('Aucun appareil sélectionné.', key);
    } else {
      await bluetooth.isConnected.then((isConnected) async {
        if (!isConnected) {
          try {
            await bluetooth.connect(_device);
            _connected = true;
          } catch (error) {
            _connected = false;
            throw ("Erreur de connexion à l'imprimante");
          }
        }
      });
    }
    notifyListeners();
  }

  void disconnect(GlobalKey<ScaffoldState> key) {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.disconnect().catchError((error) {
          _connected = true;
          show('Erreur de déconnexion', key);
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
    final awaitImageName = 'arabic_await.png';
    var bytes = await rootBundle.load("assets/images/new_logo.png");
    var bytes2 = await rootBundle.load("assets/images/arabic_await.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    writeToFile(bytes2, '$dir/$awaitImageName');

    pathImage = '$dir/$filename';
    awaitPathImage = '$dir/$awaitImageName';
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
    } on PlatformException {}

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          _connected = true;

          break;
        case BlueThermalPrinter.DISCONNECTED:
          _connected = false;

          break;
        default:
          break;
      }
      notifyListeners();
    });

    _devices = devices;

    if (isConnected) {
      _connected = true;
    }
    notifyListeners();
  }

  Future<void> sampleTicket(GlobalKey<ScaffoldState> key) async {
    bluetooth.isConnected.then((isConnected) async {
      if (isConnected) {
        try {
          await bluetooth.printNewLine();
        } catch (error) {
          throw "Erreur d'impression";
        }
      } else {
        key.currentState.removeCurrentSnackBar();
        key.currentState.showSnackBar(
          SnackBar(
            content: Text(
              "Non connecté à l'imprimante",
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
        bluetooth.printCustom('$_enterpriseNumber', 1, 1);
        bluetooth.printCustom('--------------', 1, 1);
        bluetooth.printNewLine();

        var date = DateFormat('dd/MM/yyyy').format(service.createdAt);
        var time = DateFormat('hh:mm')
            .format(service.createdAt.add(Duration(hours: 1)));
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
        var sId =
            "${DateFormat('ddMMyyyy').format(service.createdAt)} ${service.id}";
        bluetooth.printCustom('# $sId', 0, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  printAwaitTicket(
    Service service,
    int totalSac,
    double totalPoids,
  ) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImage(pathImage); //path of your image/new_logo
        bluetooth.printNewLine();
        bluetooth.printCustom('$_enterpriseNumber', 1, 1);
        bluetooth.printCustom('--------------', 1, 1);
        bluetooth.printNewLine();

        var date = DateFormat('dd/MM/yyyy').format(service.createdAt);
        var time = DateFormat('hh:mm')
            .format(service.createdAt.add(Duration(hours: 1)));
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
        bluetooth.printImage(awaitPathImage); //path of your await image
        var sId =
            "${DateFormat('ddMMyyyy').format(service.createdAt)} ${service.id}";
        bluetooth.printCustom('# $sId', 0, 1);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }
}
