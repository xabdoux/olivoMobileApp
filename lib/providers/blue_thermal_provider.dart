import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olivoalcazar/providers/service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

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

  void connect(BuildContext context) {
    if (_device == null) {
      show('No device selected.', context);
    } else {
      bluetooth.isConnected.then((isConnected) {
        if (!isConnected) {
          bluetooth.connect(_device).catchError((error) {
            _connected = false;
          });
          _connected = true;
        }
      });
    }
    notifyListeners();
  }

  void disconnect() {
    bluetooth.disconnect();
    _connected = true;
    notifyListeners();
  }

  Future show(
    String message,
    BuildContext context, {
    Duration duration: const Duration(seconds: 3),
  }) async {
    await new Future.delayed(new Duration(milliseconds: 100));
    Scaffold.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
          style: new TextStyle(
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
    final filename = 'logo.png';
    var bytes = await rootBundle.load("assets/images/logo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');

    pathImage = '$dir/$filename';
    notifyListeners();
  }

  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
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
  sampleTicket() async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printNewLine();
        bluetooth.printCustom("HEADER", 3, 1);
        // bluetooth.printNewLine();
        // bluetooth.printImage(pathImage); //path of your image/logo
        // bluetooth.printNewLine();
        // bluetooth.printLeftRight("LEFT", "RIGHT", 0);
        // bluetooth.printLeftRight("LEFT", "RIGHT", 1);
        // bluetooth.printNewLine();
        // bluetooth.printLeftRight("LEFT", "RIGHT", 2);
        // bluetooth.printLeftRight("LEFT", "RIGHT", 3);
        // bluetooth.printLeftRight("LEFT", "RIGHT", 4);
        // bluetooth.printCustom("Body left", 1, 0);
        // bluetooth.printCustom("Body right", 0, 2);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        // bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
        // bluetooth.printNewLine();
        // bluetooth.printNewLine();
        bluetooth.paperCut();
      }
    });
  }

  printTicket(Service service, double totalSac, double totalPoids) async {
    bluetooth.isConnected.then((isConnected) {
      if (isConnected) {
        bluetooth.printImage(pathImage); //path of your image/logo
        bluetooth.printNewLine();
        bluetooth.printCustom('06 44 87 17 96', 1, 1);
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
//SIZE
// 0- normal size text
// 1- only bold text
// 2- bold with medium text
// 3- bold with large text
//ALIGN
// 0- ESC_ALIGN_LEFT
// 1- ESC_ALIGN_CENTER
// 2- ESC_ALIGN_RIGHT