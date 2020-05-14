import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:olivoalcazar/providers/service.dart';

class TicketProvider with ChangeNotifier {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _printers = [];

  PrinterBluetooth selectedPrinter;
  List<PrinterBluetooth> get printers {
    return _printers;
  }

  void selectPrinter(PrinterBluetooth printer) {
    selectedPrinter = printer;
    printerManager.selectPrinter(printer);
    notifyListeners();
  }

  void clearPrinter() {
    selectedPrinter = null;
    notifyListeners();
  }

  PrinterBluetooth getSelectedPrinter() {
    return selectedPrinter;
  }

  void scanPrinters() {
    printerManager.startScan(Duration(seconds: 4));
    printerManager.scanResults.listen((printers) async {
      _printers = printers;
    });
    notifyListeners();
  }

  Future<void> printTestTicket() async {
    printerManager.printTicket(await testTicket());
  }

  Future<Ticket> testTicket() async {
    final Ticket ticket = Ticket(PaperSize.mm58);
    ticket.text('Test Printing Successfuly');
    ticket.feed(2);
    //ticket.cut();
    return ticket;
  }

  Future<void> printTicket(
      Service service, double totalSac, double totalPoids) async {
    printerManager.printTicket(await ticket(service, totalSac, totalPoids));
  }

  Future<Ticket> ticket(
      Service service, double totalSac, double totalPoids) async {
    final Ticket ticket = Ticket(PaperSize.mm58);

    ticket.text('Olivo', styles: PosStyles(bold: true, align: PosAlign.center));
    ticket.text("${service.tour}", styles: PosStyles(align: PosAlign.center));

    ticket.feed(2);
    //ticket.cut();
    return ticket;
  }
}
