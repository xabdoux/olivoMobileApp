import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/ticketProvider.dart';
import 'package:olivoalcazar/widgets/main_drawer.dart';
import 'package:provider/provider.dart';

class PrinterSettingScreen extends StatelessWidget {
  const PrinterSettingScreen({Key key}) : super(key: key);

  static const routeName = '/printer-setting';

  @override
  Widget build(BuildContext context) {
    TicketProvider ticketProvider = Provider.of<TicketProvider>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('bluetooth Printers'),
      ),
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  ticketProvider.getSelectedPrinter() != null
                      ? Column(
                          children: <Widget>[
                            Text(
                              'Selected Printer',
                              style: TextStyle(fontSize: 25),
                            ),
                            ListTile(
                              title: Text(
                                  ticketProvider.getSelectedPrinter().name),
                              subtitle: Text(
                                  ticketProvider.getSelectedPrinter().address),
                              trailing: Icon(Icons.check_box,
                                  color: Colors.green[300]),
                            ),
                          ],
                        )
                      : Text(
                          'No printer selected !',
                          style: TextStyle(fontSize: 25),
                        ),
                  Divider(),
                  Center(
                    child: ticketProvider.printers.length == 0
                        ? Text(
                            'Start new Scan',
                            style: TextStyle(fontSize: 25),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: ticketProvider.printers.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  ticketProvider.selectPrinter(
                                      ticketProvider.printers[index]);
                                },
                                title:
                                    Text(ticketProvider.printers[index].name),
                                subtitle: Text(
                                    ticketProvider.printers[index].address),
                                trailing: ticketProvider.getSelectedPrinter() ==
                                        ticketProvider.printers[index]
                                    ? Icon(
                                        Icons.check_box,
                                        color: Colors.green[300],
                                      )
                                    : Icon(Icons.check_box_outline_blank),
                              );
                            },
                          ),
                  ),
                ],
              )),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                width: 200,
                child: RaisedButton(
                    onPressed: ticketProvider.getSelectedPrinter() == null
                        ? null
                        : () async {
                            ticketProvider.printTestTicket();
                          },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.print),
                        Text(
                          ' Test Printer',
                        ),
                      ],
                    )),
              ),
              ticketProvider.getSelectedPrinter() == null
                  ? Text('')
                  : RaisedButton(
                      onPressed: () {
                        ticketProvider.clearPrinter();
                      },
                      child: Text('Remove Printer'),
                    )
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            ticketProvider.scanPrinters();
          },
          child: Icon(Icons.search)),
    );
  }
}
