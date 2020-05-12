import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/service.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class DeletedCustomerDetailsScreen extends StatelessWidget {
  static const routeName = '/deleted-customer-details';
  bool colored = false;
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
    final String serviceId = ModalRoute.of(context).settings.arguments;
    Services services = Provider.of<Services>(context, listen: false);
    Service service = Provider.of<Services>(context, listen: false)
        .deletedServices
        .firstWhere((s) => s.id == serviceId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
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
            ListTile(
              leading: Icon(
                Icons.delete_sweep,
                size: 40,
              ),
              title: Text(
                DateFormat('dd - MM - yyyy  / hh:mm').format(service.deletedAt),
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
            Column(
              children: service.customer.palettes.map((palette) {
              toggleColor();
              return Container(
                color: colored ? Colors.white : Colors.grey[100],
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        '${palette.nombreSac}',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text(
                        '${palette.poids} KG',
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
              ),
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
                    totalSac(service).toStringAsFixed(0),
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    totalPoids(service).toStringAsFixed(0),
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
