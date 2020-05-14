import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/service.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:olivoalcazar/providers/ticketProvider.dart';
import 'package:olivoalcazar/screens/PrinterSettingScreen.dart';
import 'package:olivoalcazar/screens/add_customer_screen.dart';
import 'package:olivoalcazar/screens/edit_customer_screen.dart';
import 'package:provider/provider.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const routeName = '/customer-details';

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  bool colored = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void toggleColor() {
    colored = !colored;
  }

  double totalSac(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.nombreSac);
  }

  double totalPoids(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.poids);
  }

  @override
  Widget build(BuildContext context) {
    TicketProvider ticketProvider = Provider.of<TicketProvider>(context);
    final String serviceId = ModalRoute.of(context).settings.arguments;
    Service service = Provider.of<Services>(context)
        .principaleServices
        .firstWhere((s) => s.id == serviceId);
    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Colors.,
      //drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Customer Details'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    EditCustomerScreen.routeName,
                    arguments: serviceId);
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 4.0), //(x,y)
                        blurRadius: 5.0,
                      ),
                    ],
                    gradient: LinearGradient(colors: [
                      Color(0xff5b8c5a),
                      Color(0xff596157),
                      Color(0xff52414c),
                      //Color(0xffedc7cf),
                    ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                    shape: BoxShape.circle,
                  ),
                  child: FittedBox(
                    child: Text(
                      '${service.tour}',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: Icon(
                Icons.account_box,
                size: 40,
              ),
              title: Text(
                service.customer.fullName,
                style: TextStyle(fontSize: 30),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.phone_in_talk,
                size: 40,
              ),
              title: Text(
                service.customer.phoneNumber,
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'N',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Sac',
                    style: TextStyle(fontSize: 30),
                  ),
                  Text(
                    'Poids',
                    style: TextStyle(fontSize: 30),
                  ),
                ],
              ),
            ),
            Column(children: <Widget>[
              ListView.builder(
                itemCount: service.customer.palettes.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: colored ? Colors.white : Colors.grey[100],
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(
                            index.toString(),
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            '${service.customer.palettes[index].nombreSac}',
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            '${service.customer.palettes[index].poids} Kg',
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ]),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Total',
                  style: TextStyle(fontSize: 30, color: Colors.green),
                ),
              ],
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    '${totalSac(service).toStringAsFixed(0)} Sac',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '${totalPoids(service).toStringAsFixed(0)} Kg',
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xff707cd2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed(
                            EditCustomerScreen.routeName,
                            arguments: serviceId);
                      }),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff53e69d), shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(
                        Icons.print,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (ticketProvider.getSelectedPrinter() == null) {
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Row(
                                children: <Widget>[
                                  Icon(Icons.warning, color: Colors.orange),
                                  Text(
                                    'There is no printer selected',
                                    style: TextStyle(
                                        color: Colors.orange[100],
                                        fontSize: 15),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.black,
                              action: SnackBarAction(
                                  label: 'Setting',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        PrinterSettingScreen.routeName);
                                  }),
                            ),
                          );
                          return;
                        }
                        print('pass if');
                        ticketProvider.printTicket(
                            service, totalSac(service), totalPoids(service));
                      }),
                ),
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff2cabe3), shape: BoxShape.circle),
                  child: IconButton(
                      icon: Icon(Icons.add, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddCustomerScreen.routeName);
                      }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
