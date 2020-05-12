import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:olivoalcazar/screens/customer_details_screen.dart';
import 'package:provider/provider.dart';

class CustomerListItem extends StatelessWidget {
  final String serviceId;
  final String fullName;
  final int tour;
  final int poids;
  final int nombrePalettes;
  final int nombreSac;
  final DateTime createdAt;
  final DateTime deletedAt;

  CustomerListItem({
    @required this.serviceId,
    @required this.fullName,
    @required this.tour,
    @required this.poids,
    @required this.nombrePalettes,
    @required this.nombreSac,
    @required this.createdAt,
    @required this.deletedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(serviceId),
      background: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          color: Colors.red[200],
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Services>(context, listen: false).deleteCustomer(serviceId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure!'),
            content: Text('Do you want to restore the Customer?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
              RaisedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
                color: Colors.red,
              ),
            ],
          ),
        );
      },
      child: ListTile(
        onTap: () {
          print('sdsd');
          Navigator.of(context).pushNamed(CustomerDetailsScreen.routeName,
              arguments: serviceId);
        },
        title: Text(fullName),
        subtitle: Text(createdAt.toString()),
        leading: Text(tour.toString()),
        trailing: Text('$poids KG'),
      ),
    );
  }
}
